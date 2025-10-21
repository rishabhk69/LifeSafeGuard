import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/main/profile_model.dart';
import 'package:untitled/constants/app_utils.dart';

import '../api/repository/base/auth/main_repo.dart';

class ProfileEvent {}

class ProfileRefreshEvent extends ProfileEvent {

  int? offset;
  int? size;
  String? userId;

  ProfileRefreshEvent(this.size,this.offset,this.userId);
}

class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  final ProfileModel profileModel;

  ProfileSuccessState(this.profileModel);
}

class ProfileErrorState extends ProfileState {
  String errorMsg;

  ProfileErrorState(this.errorMsg);
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final MainRepository repository;
  String? userName;
  List<Incidents> allIncidents = [];
  bool hasMore = true;
  bool isLoadingMore = false;

  ProfileBloc(this.repository) : super(ProfileInitialState()) {
    on<ProfileRefreshEvent>(_onProfileRefresh);
  }

  Future<void> _onProfileRefresh(
      ProfileRefreshEvent event, Emitter<ProfileState> emit) async {

    // Avoid duplicate load calls
    if (isLoadingMore) return;
    isLoadingMore = true;

    // If offset == 0 → it's a fresh load
    if (event.offset == 0) {
      emit(ProfileLoadingState());
      allIncidents.clear();
      hasMore = true;
    }

    try {
      final result = await repository.getProfile(
          size: event.size, offset: event.offset, userId: event.userId);

      if (result.isSuccess) {
        ProfileModel profileModel = ProfileModel.fromJson(result.data);

        userName = profileModel.userName;

        if ((profileModel.incidents ?? []).isNotEmpty) {
          allIncidents.addAll(profileModel.incidents!);
        } else {
          hasMore = false; // No more data
        }

        profileModel.incidents = allIncidents;

        await AppUtils().setUserData(jsonEncode(profileModel));
        emit(ProfileSuccessState(profileModel));
      } else {
        emit(ProfileErrorState(result.data.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(ProfileErrorState(e.toString()));
    } finally {
      isLoadingMore = false;
    }
  }
}

