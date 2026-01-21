import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/api/model/main/incidents_model.dart';
import 'package:untitled/api/model/main/profile_model.dart';
import 'package:untitled/bloc/get_comments_bloc.dart';
import 'package:untitled/common/locator/locator.dart';
import 'package:untitled/common/service/common_builder_dialog.dart';
import 'package:untitled/common/service/dialog_service.dart';
import 'package:untitled/common/service/toast_service.dart';
import 'package:untitled/constants/common_function.dart';
import '../../bloc/post_comment_bloc.dart';
import '../../constants/app_config.dart';
import '../../constants/app_utils.dart';
import 'package:untitled/localization/fitness_localization.dart';

void showCommentsBottomSheet(BuildContext context, IncidentsModel incidentsModel) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF121212), // dark bg
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          bottom: true,
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return BlocBuilder<CommentsBloc,CommentsState>(
                builder: (context, commentsState){
                if(commentsState is CommentsLoadingState){
                  return BuilderDialog();
                }
                else if(commentsState is CommentsSuccessState){
                  return Column(
                    children: [
                      // drag handle
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        height: 4,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Comments",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: commentsState.commentsModel.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: /*commentsState.commentsModel[index].isReportedAnonymously??false ?
                                    SvgPicture.asset(ImageHelper.unknownUser):*/
                                    commentsState.commentsModel[index].profilePicURL!.contains('DemoProfilePic.svg') ?
                                    SvgPicture.network(AppConfig.IMAGE_BASE_URL+(commentsState.commentsModel[index].profilePicURL??"")):
                                    CircleAvatar(
                                      backgroundImage:
                                      NetworkImage(AppConfig.IMAGE_BASE_URL+(commentsState.commentsModel[index].profilePicURL??"")), // User profile
                                      radius: 25,
                                    ),
                                  ),
                                  // CircleAvatar(
                                  //   radius: 20,
                                  //   backgroundImage: NetworkImage(commentsState.commentsModel[index].profilePicURL??""),
                                  // ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          commentsState.commentsModel[index].userName??"",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          commentsState.commentsModel[index].comment??"",
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          // incidentState.incidentsModel[index].time??"",
                                          CommonFunction().formatLocal(commentsState.commentsModel[index].time??""),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                        child: Row(
                          children: [
                            // CircleAvatar(
                            //   radius: 18,
                            //   backgroundImage: NetworkImage(
                            //     "https://randomuser.me/api/portraits/men/1.jpg",
                            //   ),
                            // ),
                            // const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2C2C2C),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(color: Colors.grey.shade800),
                                ),
                                child: TextField(
                                  controller: commentsController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: GuardLocalizations.of(context)!.translate("addComments") ?? "",
                                    hintStyle: const TextStyle(color: Colors.white54),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),
                            BlocListener<PostCommentBloc,PostCommentState>(
                            listener: (context,postListener){
                              if(postListener is PostCommentLoadingState){
                                locator<DialogService>().showLoader();
                              }
                              else if(postListener is PostCommentSuccessState){
                                commentsController.clear();
                                context.pop();
                                locator<DialogService>().hideLoader();
                                locator<ToastService>().show(postListener.postCommentData.message??"");
                                BlocProvider.of<CommentsBloc>(context).add(CommentsRefreshEvent(20, 0, incidentsModel.incidentId));
                              }
                              else if(postListener is PostCommentErrorState){
                                commentsController.clear();
                                locator<DialogService>().hideLoader();
                              }
                            },child:  GestureDetector(
                              onTap: () {
                                if(commentsController.text.trim().isNotEmpty){
                                  AppUtils().getUserData().then((onValue){
                                    var profileData = ProfileModel.fromJson(onValue);
                                    BlocProvider.of<PostCommentBloc>(context).add(PostCommentRefreshEvent(
                                        comment: commentsController.text.trim(),
                                        firstName:profileData.firstName,
                                        lastName: profileData.lastName,
                                        userId: profileData.userId,
                                        userName: profileData.userName,
                                        incidentId:incidentsModel.incidentId
                                    ));
                                  });

                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFFF9E30),
                                ),
                                child: const Icon(Icons.send, color: Colors.white, size: 20),
                              ),
                            ),)

                          ],
                        ),
                      )

                    ],
                  );
                }
                else if(commentsState is CommentsErrorState){}
                return Container();
              });
            },
          ),
        ),
      );
    },
  );
}

TextEditingController commentsController = TextEditingController();