import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/api/model/main/incidents_model.dart';
import 'package:untitled/api/model/main/profile_model.dart';
import 'package:untitled/bloc/dashboard_bloc.dart';
import 'package:untitled/bloc/delete_incident_bloc.dart';
import 'package:untitled/bloc/get_comments_bloc.dart';
import 'package:untitled/bloc/get_profile_bloc.dart';
import 'package:untitled/common/locator/locator.dart';
import 'package:untitled/common/service/dialog_service.dart';
import 'package:untitled/common/service/toast_service.dart';
import 'package:untitled/constants/app_config.dart';
import 'package:untitled/constants/app_styles.dart';
import 'package:untitled/constants/app_utils.dart';
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
  TextEditingController detailController = TextEditingController();
  String? address;
  String? userId;


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


  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
      _currentPage = index;
    });
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
    await AppUtils().getUserId();
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
    return SafeArea(
      child: Scaffold(
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
        actions: [
          BlocListener<DeleteIncidentBloc,DeleteIncidentState>(
            listener: (context,deleteListener) {
              if(deleteListener is DeleteIncidentLoadingState){
                locator<DialogService>().showLoader();
              }
              else if(deleteListener is DeleteIncidentSuccessState){
                locator<DialogService>().hideLoader();
                context.pop();
                context.go('/dashboardScreen');
                BlocProvider.of<DashboardBloc>(context).add(DashboardRefreshEvent(0));
                locator<ToastService>().show(deleteListener.commonModel.message??"");
              }
              else if(deleteListener is DeleteIncidentErrorState){
                locator<DialogService>().hideLoader();
                locator<ToastService>().show(deleteListener.errorMsg);
              }
            },child:  IconButton(
            icon:  Icon(Icons.more_horiz),color: Colors.black, onPressed: () {
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
                        Text(
                          GuardLocalizations.of(context)!.translate("deleteIncident") ?? "",
                          style: MyTextStyleBase.headingStyleLight,),
                        // Icon(Icons.check,color: Colors.green,)
                      ],
                    ),
                    onPressed: () async {
                      context.pop();
                      await _videoController?.pause();
                      locator<DialogService>().showDeleteDialog(
                          detailController: detailController,
                          title: GuardLocalizations.of(context)!.translate("areYouSure") ?? "",
                          subTitle: GuardLocalizations.of(context)!.translate("youWantToDeleteIncident") ?? "",
                          negativeButtonText:  GuardLocalizations.of(context)!.translate("no") ?? "",
                          positiveButtonText: GuardLocalizations.of(context)!.translate("yes") ?? "",
                          negativeTap: () {
                            context.pop();
                          },
                          positiveTap: () async {
                            if(detailController.text.isEmpty){
                              locator<ToastService> ().show(GuardLocalizations.of(context)!.translate("enterReason") ?? "");
                            }
                            else{
                              context.read<DeleteIncidentBloc>().add(
                                  DeleteIncidentRefreshEvent(widget.incidentData.incidents![widget.index!].incidentId.toString(),detailController.text));
                              context.pop();
                            }
                          }
                      );
                      // context.push('/filterScreen');
                    },
                  ),
                  // Divider(),
                  // TextButton(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(GuardLocalizations.of(context)!.translate("edit") ?? "",style: MyTextStyleBase.headingStyleLight,),
                  //       // Icon(Icons.check,color: Colors.green,)
                  //     ],
                  //   ),
                  //   onPressed: () async {
                  //     await _videoController?.pause();
                  //     locator<ToastService>().show('Coming soon');
                  //     context.pop();
                  //     // context.push('/incidentDetails',extra: incidentState.incidentsModel[index]);
                  //   },
                  // ),
                ],
              ),
            ));
          },),
          )
        ],
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
                    onPageChanged: _onPageChanged,
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
                    String userId = await AppUtils().getUserId();
                    if(incidentData!.userId==userId){
                    context.pop();
                    }
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
