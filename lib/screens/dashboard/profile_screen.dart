import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/api/model/main/incidents_model.dart';
import 'package:untitled/api/model/main/profile_model.dart';
import 'package:untitled/bloc/dashboard_bloc.dart';
import 'package:untitled/bloc/getIncident_bloc.dart';
import 'package:untitled/bloc/get_profile_bloc.dart';
import 'package:untitled/bloc/update_profile_bloc.dart';
import 'package:untitled/common/locator/locator.dart';
import 'package:untitled/common/service/common_builder_dialog.dart';
import 'package:untitled/common/service/dialog_service.dart';
import 'package:untitled/common/service/toast_service.dart';
import 'package:untitled/constants/base_appbar.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/common_function.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/constants/sizes.dart';
import 'package:untitled/localization/fitness_localization.dart';

import '../../constants/app_config.dart';
import '../../constants/app_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final ScrollController _scrollController = ScrollController();
  int offset = 0;
  final int size = 10;

  @override
  void initState() {
    super.initState();

    // Fetch first page
    _scrollController.addListener(() async {
      final bloc = context.read<ProfileBloc>();

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          bloc.hasMore &&
          !bloc.isLoadingMore) {

        String userId = await AppUtils().getUserId();
        offset += size;
        bloc.add(ProfileRefreshEvent(size, offset, userId,true));
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.scaffoldColor,
      appBar: BaseAppBar(
        onTap: () {
          context.push("/blockedIncidents");
        },
        isProfile: true,
        showAction: true,
        isMainBar: true,
        // widgets: [Icon(Icons.verified, color: Colors.blue),],
        title: BlocProvider.of<ProfileBloc>(context).userName,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            if (profileState is ProfileLoadingState) {
              return BuilderDialog();
            } else if (profileState is ProfileSuccessState) {
              return Column(
                children: [
                  const SizedBox(height: 10),

                  // Profile Image + Name + Stats
                  Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundImage: NetworkImage(
                              AppConfig.IMAGE_BASE_URL +
                                  (profileState.profileModel.profilePhotoUrl ??
                                      ""),
                            ), // Replace with actual image
                          ),
                          Positioned(
                            top: 3,
                            right: 1,
                            child:  BlocListener<UpdateProfileBloc,UpdateProfileState>(
                              listener: (context,loginState){
                                if(loginState is UpdateProfileLoadingState){
                                  locator<DialogService>().showLoader();
                                }
                                else if(loginState is UpdateProfileSuccessState){
                                  BlocProvider.of<ProfileBloc>(context, listen: false).add(
                                      ProfileRefreshEvent(10, 0, profileState.profileModel.userId??"",true));
                                  locator<DialogService>().hideLoader();
                                  locator<ToastService>().show(loginState.commonModel.message??"");
                                }
                                else if(loginState is UpdateProfileErrorState){
                                  locator<DialogService>().hideLoader();
                                  locator<ToastService>().show(loginState.errorMsg??"");
                                }
                              },child: InkWell(
                              onTap: (){
                                String userId = profileState.profileModel.userId??"";
                                CommonFunction().pickImage('gallery').then((onValue){
                                  if(onValue.path.isNotEmpty){
                                    BlocProvider.of<UpdateProfileBloc>(context).add(UpdateProfileRefreshEvent(
                                      userId: userId,
                                      profilePhoto:File(onValue.path),

                                    ));
                                  }
                                });
                              },
                              child: Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white
                                  ),
                                  child: SvgPicture.asset(ImageHelper.editGrey,color: ColorConstant.primaryColor,)),
                            ),),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          context.push('/updateProfileScreen');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${profileState.profileModel.firstName ?? ""} ${profileState.profileModel.lastName ?? ""}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            addWidth(5),
                            SvgPicture.asset(ImageHelper.editGrey),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profileState.profileModel.phone ?? "",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${profileState.profileModel.totalIncidents ?? ""} incidents",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  (profileState.profileModel.incidents ?? []).isEmpty
                      ? Center(child: Text('No Incidents'))
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                              ),
                          itemCount:
                              profileState.profileModel.incidents?.length,
                          // Number of posts
                          itemBuilder: (context, index) {
                            final item = profileState.profileModel.incidents![index];
                            return InkWell(
                              onTap: (){
                                context.push('/profilePreviewScreen',extra:
                                  {
                                    "index":index,
                                    "incidentData":profileState.profileModel
                                  }
                                );

                                // BlocProvider.of<IncidentsBloc>(context, listen: false)
                                //     .add(IncidentsRefreshEvent(10, 0));
                                // BlocProvider.of<DashboardBloc>(context).add(DashboardRefreshEvent(1));
                              },
                              onLongPress: (){
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextButton(onPressed: (){},child: Text(
                                            GuardLocalizations.of(context)!.translate("viewIncident") ?? "",
                                            style: TextStyle(
                                              color: ColorConstant.blackColor
                                            ),)),
                                        Divider(),
                                        TextButton(onPressed: (){},child: Text(
                                            GuardLocalizations.of(context)!.translate("editIncident") ?? "",
                                            style: TextStyle(
                                              color: ColorConstant.blackColor
                                            ),)),
                                        Divider(),
                                        TextButton(onPressed: (){},child: Text(GuardLocalizations.of(context)!.translate("deleteIncident") ?? "",
                                          style: TextStyle(
                                              color: ColorConstant.blackColor
                                          ),)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: buildItem(item),
                            );
                          },
                        ),
                ],
              );
            } else if (profileState is ProfileErrorState) {
              return Center(child: Text(profileState.errorMsg));
            }
            return Container();
          },
        ),
      ),
    );
  }

  buildItem(IncidentsModel item){
    return item
        .isVideo ==
        "true"
        ? Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                AppConfig.IMAGE_BASE_URL +
                    (item
                        .media![0]
                        .thumbnail ??
                        "")
                        .toString(),
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(
              4,
            ),
          ),
        ),
        Positioned(
            right: 5,
            top: 5,
            child: SvgPicture.asset(ImageHelper.playCircle)),
      ],
    )
        : (item
        .media??[]).isEmpty ? Icon(Icons.image):Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                AppConfig.IMAGE_BASE_URL +
                    (item
                        .media![0]
                        .name ??
                        "")
                        .toString(),
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(
              4,
            ),
          ),
        ),
        Positioned(
            right: 5,
            top: 5,
            child: SvgPicture.asset(ImageHelper.photoIcWhite)),
      ],
    );
  }

}
