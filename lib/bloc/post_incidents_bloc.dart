import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/main/post_incidents_model.dart';

import '../../api/repository/base/auth/main_repo.dart';

class PostIncidentsEvent {}

class PostIncidentsRefreshEvent extends PostIncidentsEvent {

  String? title;
  String? description;
  String? category;
  String? latitude;
  String? longitude;
  String? city;
  String? state;
  String? userId;
  String? address;
  String? pinCode;
  String? time;
  bool? reportAnonymously;
  bool? isCameraUpload;
  bool? isVideo;
  bool? isEdited;
  List<File>? files;

  PostIncidentsRefreshEvent({this.title, this.address,this.pinCode,this.description, this.category,
    this.latitude, this.longitude, this.reportAnonymously,
    this.isCameraUpload, this.isVideo, this.files,this.userId,this.state,this.city,this.isEdited,this.time});
}

class PostIncidentsState {}

class PostIncidentsInitialState extends PostIncidentsState {}

class PostIncidentsLoadingState extends PostIncidentsState {}

class PostIncidentsSuccessState extends PostIncidentsState {
  final PostIncidentsModel postIncidentsData;

  PostIncidentsSuccessState(this.postIncidentsData);
}

class PostIncidentsErrorState extends PostIncidentsState {
  String errorMsg;
  PostIncidentsErrorState(this.errorMsg);
}

class PostIncidentsBloc extends Bloc<PostIncidentsEvent, PostIncidentsState> {
  final MainRepository repository;

  PostIncidentsBloc(this.repository) : super(PostIncidentsInitialState()) {
    on<PostIncidentsRefreshEvent>(_onPostIncidentsRefresh);
  }

  Future<void> _onPostIncidentsRefresh(
      PostIncidentsRefreshEvent event, Emitter<PostIncidentsState> emit) async {
    emit(PostIncidentsLoadingState());
    try {
      final result = await repository.postIncidents(
        category: event.category,
          description: event.description,
          files: event.files,
          isCameraUpload: event.isCameraUpload,
          isVideo: event.isVideo,
          latitude: event.latitude,
          longitude:  event.longitude,
          reportAnonymously: event.reportAnonymously,
          title:event.title,
          city: event.city,
          isEdited: event.isEdited,
          state: event.state,
          userId: event.userId,
          address: event.address,
          pincode: event.pinCode,
          time: event.time,
      ); // API call

      if (result.isSuccess) {
        PostIncidentsModel postIncidentsData = PostIncidentsModel.fromJson(result.data);
        emit(PostIncidentsSuccessState(postIncidentsData));
      } else {
        emit(PostIncidentsErrorState(result.data.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(PostIncidentsErrorState(e.toString()));
    }
  }
}
