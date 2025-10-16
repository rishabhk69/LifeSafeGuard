import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/api/model/main/incidents_model.dart';
import 'package:untitled/bloc/getIncident_bloc.dart';
import 'package:untitled/bloc/get_comments_bloc.dart';
import 'package:untitled/common/locator/locator.dart';
import 'package:untitled/common/service/common_builder_dialog.dart';
import 'package:untitled/common/service/dialog_service.dart';
import 'package:untitled/constants/app_config.dart';
import 'package:untitled/constants/app_styles.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/constants/sizes.dart';
import 'package:untitled/constants/strings.dart';
import 'package:untitled/screens/dashboard/comments_bottomsheet.dart';
import 'package:video_player/video_player.dart';


class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final PageController _pageController = PageController();

  int currentIndex = 0;
  VideoPlayerController? _videoController;
  String? address;
  int _currentPage = 0;
  bool isInitialized = false;

  void _initializeVideo(String? originUrl) async {
    if (originUrl == null || originUrl.isEmpty) {
      return;
    }

    await _videoController?.pause();
    await _videoController?.dispose();

    _videoController = VideoPlayerController.network(originUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _videoController?.play();
          _videoController?.setLooping(true);
        }
      });
  }

  void _onPageChanged(int index, List<IncidentsModel> incidents) {
    setState(() {
      currentIndex = index;
      _currentPage = index;
    });

    // Initialize video
    final current = incidents[index];
    if (current.isVideo == 'true' && current.media!.isNotEmpty) {
      _initializeVideo(AppConfig.VIDEO_BASE_URL + current.media![0].name!);
    } else {
      _videoController?.pause();
      _videoController?.dispose();
      _videoController = null;
    }

    // ✅ Load next page if reached near the end
    if (index == incidents.length - 1) {
      final bloc = BlocProvider.of<IncidentsBloc>(context, listen: false);
      final nextOffset = bloc.allIncidents.length;
      bloc.add(IncidentsLoadMoreEvent(10, nextOffset));
    }
  }


  @override
  void initState() {
    super.initState();
    BlocProvider.of<IncidentsBloc>(context, listen: false)
        .add(IncidentsRefreshEvent(10, 0));
    // _initializeFirst();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<IncidentsBloc,IncidentsState>(
            builder: (context,incidentState){
          if(incidentState is IncidentsLoadingState){
            return BuilderDialog();
          }
            else if(incidentState is IncidentsSuccessState){
            final incidents = incidentState.incidentsModel;

            if (incidents.isNotEmpty && isInitialized == false) {
              // find the first video in the list
              final firstVideo = incidents.firstWhere(
                    (e) => e.isVideo == 'true' && e.media!.isNotEmpty,
              );

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _initializeVideo(AppConfig.VIDEO_BASE_URL + firstVideo.media![0].name!);
                setState(() {
                  isInitialized = true;
                });
              });
                        }

            return  PageView.builder(
                scrollDirection: Axis.vertical,
                controller: _pageController,
                onPageChanged: (index) => _onPageChanged(index, incidents),
                itemCount: incidentState.incidentsModel.length,
                itemBuilder: (context, index) {
                  if (index == incidents.length) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  }
                  return Stack(
                    children: [
                      incidentState.incidentsModel[index].isVideo == 'true'?
                        Center(
                          child: (_videoController != null &&
                              _videoController!.value.isInitialized &&
                              currentIndex == index)
                              ? AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: VideoPlayer(_videoController!),
                          )
                              : const CircularProgressIndicator(color: Colors.white),
                        ) : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 200,
                              child: PageView.builder(
                                controller: _pageController,
                                scrollDirection: Axis.horizontal,
                                physics: const PageScrollPhysics(),
                                // onPageChanged: _onPageChanged,
                                itemCount: incidentState.incidentsModel[index].media?.length ?? 0,
                                itemBuilder: (context, mediaIndex) {
                                  return Image.network(
                                    AppConfig.IMAGE_BASE_URL +
                                        incidentState.incidentsModel[index].media![mediaIndex].name!,
                                    fit: BoxFit.fitWidth,
                                    // width: double.infinity,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate((incidentState.incidentsModel[index].media??[]).length, (dotIndex) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: _currentPage == dotIndex ? 10 : 8,
                                  height: _currentPage == dotIndex ? 10 : 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentPage == dotIndex ? Colors.white : Colors.grey,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),


                      // Overlay (Like TikTok UI)
                      Positioned(
                        top: 20,
                        right: 16,
                        child: IconButton(
                          icon:  Icon(Icons.more_horiz),color: Colors.white, onPressed: () {
                          locator<DialogService>().showCommonDialog(context, Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton(
                                  child: Text(StringHelper.filter,style: MyTextStyleBase.headingStyleLight,),
                                  onPressed: (){
                                    context.pop();
                                    context.pop();
                                    context.push('/filterScreen');
                                  },
                                ),
                                Divider(),
                                TextButton(
                                  child: Text(StringHelper.allText,style: MyTextStyleBase.headingStyleLight,),
                                  onPressed: (){
                                    context.pop();
                                    // context.push('/incidentDetails',extra: incidentState.incidentsModel[index]);
                                  },
                                ),
                              ],
                            ),
                          ));
                        },),
                      ),
                      Positioned(
                        bottom: 80,
                        right: 16,
                        child: Column(
                          children: [
                           InkWell(
                             onTap: (){
                               BlocProvider.of<CommentsBloc>(context).add(CommentsRefreshEvent(20, 0, incidentState.incidentsModel[index].incidentId));
                               showCommentsBottomSheet(context,incidentState.incidentsModel[index]);
                             },
                             child: Column(
                               children: [
                                 SvgPicture.asset(ImageHelper.messageIc,
                                   fit: BoxFit.scaleDown,
                                   height: 35,
                                   width: 35,),
                                 Text(incidentState.incidentsModel[index].commentCount.toString(),style: GoogleFonts.poppins(
                                     fontWeight: FontWeight.w400,
                                     color: ColorConstant.whiteColor
                                 ),),
                               ],
                             ),
                           ),
                            SizedBox(height: 20),
                            SvgPicture.asset(ImageHelper.sendIc,
                              fit: BoxFit.scaleDown,
                              height: 35,
                              width: 35,),

                          ],
                        ),
                      ),

                      // Caption / User info
                      Positioned(
                        bottom: 30,
                        left: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            Row(
                              children: [
                                SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: (incidentState.incidentsModel[index].profilePic??"").isEmpty ? Icon(Icons.person):CircleAvatar(
                                    backgroundImage:
                                    NetworkImage(incidentState.incidentsModel[index].profilePic??""), // User profile
                                    radius: 25,
                                  ),
                                ),
                                addWidth(5),
                                Text(incidentState.incidentsModel[index].userName??"",style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: ColorConstant.whiteColor
                                ),)

                              ],
                            ),
                            addHeight(5),
                            Text(incidentState.incidentsModel[index].category??"",style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: ColorConstant.whiteColor
                            ),),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                SvgPicture.asset(ImageHelper.locationIc),
                                addWidth(5),
                                Text(
                                incidentState.incidentsModel[index].address??"",
                                style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: ColorConstant.whiteColor,
                                 ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(ImageHelper.timerIc),
                                addWidth(5),
                                Text(
                                  incidentState.incidentsModel[index].time??"",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: ColorConstant.whiteColor
                                  ),
                                ),
                              ],
                            ),

                            InkWell(
                              onTap: (){
                                context.push('/incidentDetails',extra: incidentState.incidentsModel[index]);
                              },
                              child: Text(StringHelper.seeMore,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: ColorConstant.whiteColor
                                ),),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
          }
            else if(incidentState is IncidentsErrorState){
              return Center(
              child: Text(incidentState.errorMsg),
              );
              }
            return Container();
        })
      ),
    );
  }
}
