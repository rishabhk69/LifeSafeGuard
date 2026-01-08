import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/api/model/main/profile_model.dart';
import 'package:untitled/bloc/get_user_incident_bloc.dart';
import 'package:untitled/common/service/common_builder_dialog.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/localization/fitness_localization.dart';

import '../../constants/app_config.dart';

class OtherProfileScreen extends StatefulWidget {
  dynamic userId;
  dynamic username;
  OtherProfileScreen(this.userId,this.username);


  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {

  final ScrollController _scrollController = ScrollController();
  int offset = 0;
  final int size = 10;

  @override
  void initState() {
    super.initState();

    // Fetch first page
    // _scrollController.addListener(() async {
    //   final bloc = context.read<UserIncidentsBloc>();
    //
    //   if (_scrollController.position.pixels >=
    //       _scrollController.position.maxScrollExtent - 200 &&
    //       bloc.hasMore &&
    //       !bloc.isLoadingMore) {
    //
    //     String userId = await AppUtils().getUserId();
    //     offset += size;
    //     bloc.add(UserIncidentsRefreshEvent(widget.userId,size, offset));
    //   }
    // });
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
      appBar: AppBar(
        leading: InkWell(
            onTap: (){
              context.pop();
            },
            child: const Icon(Icons.arrow_back, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        title:  Text(
          widget.username,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: BlocBuilder<UserIncidentsBloc, UserIncidentsState>(
          builder: (context, profileState) {
            if (profileState is UserIncidentsLoadingState) {
              return BuilderDialog();
            } else if (profileState is UserIncidentsSuccessState) {
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
                                  (profileState.userIncidentsModel.profilePhotoUrl ??
                                      ""),
                            ), // Replace with actual image
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
                              '${profileState.userIncidentsModel.firstName ?? ""} ${profileState.userIncidentsModel.lastName ?? ""}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // addWidth(5),
                            // SvgPicture.asset(ImageHelper.editGrey),
                          ],
                        ),
                      ),
                        RichText(
                                text: TextSpan(
                                    text:   profileState.userIncidentsModel.totalIncidents ?? "",
                                    style: TextStyle( fontSize: 18,
                                      fontWeight: FontWeight.bold,color: Colors.black),
                                    children: [
                                      const TextSpan(
                                        text: ' ',
                                        style: TextStyle(color: Colors.grey, fontSize: 14),
                                      ),
                                     const TextSpan(
                                        text: 'incidents',
                                       style: TextStyle(color: Colors.grey, fontSize: 14),
                                      ),
                                    ])),

                      // const SizedBox(height: 4),
                      // Text(
                      //   "${profileState.userIncidentsModel.totalIncidents ?? ""} incidents",
                      //   style: TextStyle(color: Colors.grey, fontSize: 14),
                      // ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  (profileState.userIncidentsModel.incidents ?? []).isEmpty
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
                    profileState.userIncidentsModel.incidents?.length,
                    // Number of posts
                    itemBuilder: (context, index) {
                      final item = profileState.userIncidentsModel.incidents![index];
                      return InkWell(
                        onTap: (){
                          context.push('/incidentPreviewScreen',extra:
                          {
                            "index":index,
                            "incidentData":profileState.userIncidentsModel.toJson()
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
            } else if (profileState is UserIncidentsErrorState) {
              return Center(child: Text(profileState.errorMsg));
            }
            return Container();
          },
        ),
      ),
    );
  }

  buildItem(Incidents item){
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
