import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/bloc/get_profile_bloc.dart';
import 'package:untitled/common/service/common_builder_dialog.dart';
import 'package:untitled/constants/base_appbar.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/constants/sizes.dart';

import '../../constants/app_config.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.scaffoldColor,
      appBar: BaseAppBar(
        onTap: () {
          context.push("/blockedIncidents");
        },
        showAction: true,
        isMainBar: true,
        // widgets: [Icon(Icons.verified, color: Colors.blue),],
        title: BlocProvider.of<ProfileBloc>(context).userName,
      ),
      body: SingleChildScrollView(
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
                            child: SvgPicture.asset(ImageHelper.editOrange),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          context.push('/signupScreen');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              profileState.profileModel.userName ?? "",
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

                  // Grid of Posts
                  (profileState.profileModel.incidents ?? []).isEmpty
                      ? SizedBox()
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, // 3 images per row
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                              ),
                          itemCount:
                              profileState.profileModel.incidents?.length,
                          // Number of posts
                          itemBuilder: (context, index) {
                            return profileState
                                        .profileModel
                                        .incidents?[index]
                                        .isVideo ==
                                    "true"
                                ? Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              AppConfig.IMAGE_BASE_URL +
                                                  (profileState
                                                              .profileModel
                                                              .incidents?[index]
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
                                : Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              AppConfig.IMAGE_BASE_URL +
                                                  (profileState
                                                              .profileModel
                                                              .incidents?[index]
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
}
