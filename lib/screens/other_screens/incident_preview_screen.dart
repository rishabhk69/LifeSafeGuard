import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/api/model/main/incidents_model.dart';
import 'package:untitled/api/model/main/profile_model.dart';
import 'package:untitled/bloc/get_comments_bloc.dart';
import 'package:untitled/common/locator/locator.dart';
import 'package:untitled/common/service/dialog_service.dart';
import 'package:untitled/constants/app_config.dart';
import 'package:untitled/constants/app_styles.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/constants/sizes.dart';
import 'package:untitled/localization/fitness_localization.dart';
import 'package:video_player/video_player.dart';

import '../dashboard/comments_bottomsheet.dart';

class IncidentPreviewScreen extends StatefulWidget {
  int? index;
  final ProfileModel incidentData;
  IncidentPreviewScreen(this.index,this.incidentData);

  @override
  State<IncidentPreviewScreen> createState() => _IncidentPreviewScreenState();
}

class _IncidentPreviewScreenState extends State<IncidentPreviewScreen> {
  ProfileModel? incidentData;
  VideoPlayerController? _videoController;
  int _currentPage = 0;
  int currentIndex = 0;
  final PageController _pageController = PageController();
  String? address;


  @override
  void dispose() {
    _videoController?.pause();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ProfileModel? incidentData = widget.incidentData;
    if(incidentData.incidents?[widget.index!].isVideo=='true') {
      _initializeVideoIfNeeded(
          incidentData.incidents?[widget.index!].media?[0].name ?? "");
    }
  }

  Future<void> _initializeVideoIfNeeded(String originUrl) async {
      _videoController?.dispose();
      _videoController = VideoPlayerController.network(AppConfig.VIDEO_BASE_URL+originUrl)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
            _videoController?.play();
            _videoController?.setLooping(true);
          }
        });
      setState(() {});
  }

  getAddress(lat,long) async {
    // address = await CommonFunction().getAddressFromLatLng(lat.toDouble(), long.toDouble());
    address = 'Jaipur';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    incidentData =  widget.incidentData;
    address = 'Jaipur';
    // if(address==null) {
    //   getAddress(
    //       incidentData!.incidents![widget.index!].incidentLocation?.latitude ??
    //           0.0,
    //       incidentData!.incidents![widget.index!].incidentLocation?.longitude ??
    //           0.0);
    // }
    return SafeArea(child: Scaffold(
      backgroundColor: ColorConstant.blackColor,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            context.pop();
          },
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          GuardLocalizations.of(context)!.translate("incidentPreview") ?? "",
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body:  Stack(
        children: [
          incidentData!.incidents![widget.index!].isVideo == 'true'?
          Center(
            child: AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: InkWell(
                  onTap: (){
                    if(!_videoController!.value.isPlaying){
                      _videoController!.play();
                    }
                  },
                  child: VideoPlayer(_videoController!)),
            )
          ) :
          Center(
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
                    itemCount: incidentData?.incidents?[widget.index!].media?.length ?? 0,
                    itemBuilder: (context, mediaIndex) {
                      return Image.network(
                        AppConfig.IMAGE_BASE_URL +
                            (incidentData?.incidents?[widget.index!].media![mediaIndex].name??""),
                        fit: BoxFit.fitWidth,
                        // width: double.infinity,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate((incidentData?.incidents?[widget.index!].media??[]).length, (dotIndex) {
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(GuardLocalizations.of(context)!.translate("filter") ?? "",style: MyTextStyleBase.headingStyleLight,),
                          Icon(Icons.check,color: Colors.green,)
                        ],
                      ),
                      onPressed: () async {
                        context.pop();
                        // context.pop();
                        await _videoController?.pause();
                        context.push('/filterScreen');
                      },
                    ),
                    Divider(),
                    TextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(GuardLocalizations.of(context)!.translate("allText") ?? "",style: MyTextStyleBase.headingStyleLight,),
                          Icon(Icons.check,color: Colors.green,)
                        ],
                      ),
                      onPressed: () async {
                        await _videoController?.pause();
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
                    BlocProvider.of<CommentsBloc>(context).add(CommentsRefreshEvent(20, 0, incidentData!.incidents![widget.index!].incidentId));
                    showCommentsBottomSheet(context,incidentData as IncidentsModel);
                  },
                  child: Column(
                    children: [
                      SvgPicture.asset(ImageHelper.messageIc,
                        fit: BoxFit.scaleDown,
                        height: 35,
                        width: 35,),
                      Text(incidentData!.incidents![widget.index!].commentCount.toString(),style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          color: ColorConstant.whiteColor
                      ),),
                    ],
                  ),
                ),
                // SizedBox(height: 20),
                // SvgPicture.asset(ImageHelper.sendIc,
                //   fit: BoxFit.scaleDown,
                //   height: 35,
                //   width: 35,),

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
                InkWell(
                  onTap: () async {
                    // String userId = await AppUtils().getUserId();
                    // if(incidentData.userId==userId){
                    //   BlocProvider.of<ProfileBloc>(context, listen: false).add(
                    //       ProfileRefreshEvent(10, 0, userId));
                    //   BlocProvider.of<DashboardBloc>(context).add(DashboardRefreshEvent(2));
                    // }
                    // else{
                    //   showDialog(
                    //     context: context,
                    //     builder: (context) => OtherUserProfileDialog(
                    //       incidentState.incidentsModel[index],
                    //     ),
                    //   );
                    // }
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: (incidentData!.profilePhotoUrl??"").isEmpty ? Icon(Icons.person):CircleAvatar(
                          backgroundImage:
                          NetworkImage(AppConfig.IMAGE_BASE_URL+(incidentData!.profilePhotoUrl??"")), // User profile
                          radius: 25,
                        ),
                      ),
                      addWidth(5),
                      Text(incidentData!.userName??"",style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: ColorConstant.whiteColor
                      ),)

                    ],
                  ),
                ),
                addHeight(5),
                Text(incidentData!.incidents![widget.index!].category??"",style: GoogleFonts.poppins(
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
                      address??"",
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
                      incidentData!.incidents![widget.index!].time??"",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: ColorConstant.whiteColor
                      ),
                    ),
                  ],
                ),

                InkWell(
                  onTap: () async {
                    await _videoController?.pause();
                    // await _videoController?.dispose();
                    context.push('/incidentDetails',extra: incidentData);
                  },
                  child: Text(GuardLocalizations.of(context)!.translate("seeMore") ?? "",
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
      )
    ));
  }
}
