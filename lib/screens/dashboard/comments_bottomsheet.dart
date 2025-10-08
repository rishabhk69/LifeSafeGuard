import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/bloc/get_comments_bloc.dart';
import 'package:untitled/common/service/common_builder_dialog.dart';
import 'package:untitled/constants/custom_text_field.dart';
import 'package:untitled/constants/strings.dart';

void showCommentsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF121212), // dark bg
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return SafeArea(
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
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(commentsState.commentsModel[index].profilePicURL??""),
                                ),
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
                                        commentsState.commentsModel[index].time??"",
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
                      margin: EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CommonTextFieldWidget(
                                isPassword: false,
                                hintText: StringHelper.addComments,
                                textController: commentsController),
                          ),
                          SizedBox(width: 5,),
                          ElevatedButton(onPressed: (){}, child: Text('Post'))
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
      );
    },
  );
}

TextEditingController commentsController = TextEditingController();

/// Sample comments data
final List<Map<String, String>> comments = [
  {
    "avatar":
    "https://randomuser.me/api/portraits/women/68.jpg",
    "name": "Nancy Sharma",
    "text":
    "Lorem ipsum dolor sit amet conse. In in velit tellus mauris elementum ultricies vitae diam malesuada.",
    "date": "12 June, 2025 | 03:36 pm",
  },
  {
    "avatar":
    "https://randomuser.me/api/portraits/men/33.jpg",
    "name": "Rajesh Roy",
    "text": "Lorem ipsum dolor sit amet conse. In in velit tellus.",
    "date": "12 June, 2025 | 03:36 pm",
  },
  {
    "avatar":
    "https://randomuser.me/api/portraits/women/12.jpg",
    "name": "Nancy Sharma",
    "text":
    "Lorem ipsum dolor sit amet conse. In in velit tellus mauris elementum ultricies vitae diam malesuada.",
    "date": "12 June, 2025 | 03:39 pm",
  },
];
