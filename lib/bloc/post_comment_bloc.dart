import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/repository/base/auth/main_repo.dart';
import '../api/model/common_model.dart';
import '../api/model/main/block_incident_model.dart';

class PostCommentEvent {}

class PostCommentRefreshEvent extends PostCommentEvent {

  String? lastName;
  String? firstName;
  String? userName;
  String? userId;
  String? incidentId;
  String? comment;

  PostCommentRefreshEvent({this.lastName, this.firstName, this.userName,
    this.userId, this.incidentId, this.comment});


}

class PostCommentState {}

class PostCommentInitialState extends PostCommentState {}

class PostCommentLoadingState extends PostCommentState {}

class PostCommentSuccessState extends PostCommentState {
  final CommonModel postCommentData;

  PostCommentSuccessState(this.postCommentData);
}

class PostCommentErrorState extends PostCommentState {
  String errorMsg;
  PostCommentErrorState(this.errorMsg);
}

class PostCommentBloc extends Bloc<PostCommentEvent, PostCommentState> {
  final MainRepository repository;

  PostCommentBloc(this.repository) : super(PostCommentInitialState()) {
    on<PostCommentRefreshEvent>(_onPostCommentRefresh);
  }

  Future<void> _onPostCommentRefresh(
      PostCommentRefreshEvent event, Emitter<PostCommentState> emit) async {
    emit(PostCommentLoadingState());
    try {
      final result = await repository.postComment(
         userName: event.userName,
         lastName: event.lastName,
         firstName: event.firstName,
         comment: event.comment,
         incidentId: event.incidentId,
         userId: event.userId,

      ); // API call

      if (result.isSuccess) {
        CommonModel postCommentData = CommonModel.fromJson(result.data);
        emit(PostCommentSuccessState(postCommentData));
      } else {
        emit(PostCommentErrorState(result.data.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(PostCommentErrorState(e.toString()));
    }
  }
}
