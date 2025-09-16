import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/bloc/getIncident_bloc.dart';
import 'package:untitled/common/locator/locator.dart';
import 'package:untitled/common/service/common_builder_dialog.dart';
import 'package:untitled/common/service/dialog_service.dart';
import 'package:untitled/constants/app_config.dart';
import 'package:untitled/constants/app_styles.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/common_function.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/constants/sizes.dart';
import 'package:untitled/constants/strings.dart';
import 'package:video_player/video_player.dart';

import '../../constants/common_function.dart';


class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final PageController _pageController = PageController();

  int currentIndex = 0;
  late VideoPlayerController _videoController;
  String? address;

  @override
  void initState() {
    super.initState();
  }

  void _initializeVideo(String originUrl) {
    _videoController = VideoPlayerController.network(originUrl)
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
        _videoController.setLooping(true);
      });
  }

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
    _videoController.pause();
    _videoController.dispose();
    _initializeVideo('');
  }

  @override
  void dispose() {
    _videoController.pause();
    _videoController.dispose();
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

              return  PageView.builder(
                scrollDirection: Axis.vertical,
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: incidentState.incidentsModel.length,
                itemBuilder: (context, index) {
                  _initializeVideo(incidentState.incidentsModel[index].mediaUrls?[0]??"");
                  return Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      // Video Player
                      incidentState.incidentsModel[index].isVideo??false ?
                      Center(
                        child: _videoController.value.isInitialized && currentIndex == index
                            ? AspectRatio(
                          aspectRatio: _videoController.value.aspectRatio,
                          child: VideoPlayer(_videoController),
                        )
                            : const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ) : PageView.builder(
                        scrollDirection: Axis.vertical,
                        controller: _pageController,
                        onPageChanged: _onPageChanged,
                        itemCount: incidentState.incidentsModel[index].mediaUrls?.length,
                        itemBuilder: (context, mediaIndex) {
                          return Image.network(AppConfig.IMAGE_BASE_URL+incidentState.incidentsModel[index].mediaUrls![mediaIndex]);
                        },
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
                                  child: Text(StringHelper.incidentDetails,style: MyTextStyleBase.headingStyleLight,),
                                  onPressed: (){
                                    context.pop();
                                    context.push('/incidentDetails');
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
                            SvgPicture.asset(ImageHelper.messageIc,
                              fit: BoxFit.scaleDown,
                              height: 35,
                              width: 35,),
                            Text('20.3k',style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                color: ColorConstant.whiteColor
                            ),),
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
                                  child: CircleAvatar(
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
                                FutureBuilder<String>(
                                  future: CommonFunction().getAddressFromLatLng(
                                    incidentState.incidentsModel[index].location?.latitude ?? 0.0,
                                    incidentState.incidentsModel[index].location?.longitude ?? 0.0,
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Text(
                                        "Loading...",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: ColorConstant.whiteColor,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text(
                                        "Error",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: ColorConstant.whiteColor,
                                        ),
                                      );
                                    } else {
                                      return Text(
                                        snapshot.data ?? "No address available",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: ColorConstant.whiteColor,
                                        ),
                                      );
                                    }
                                  },
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
