import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/common_model.dart';

import '../../api/repository/base/auth/main_repo.dart';

class UpdateProfileEvent {}

class UpdateProfileRefreshEvent extends UpdateProfileEvent {

  String? firstName; String? lastName; String? userId; File? profilePhoto;
  UpdateProfileRefreshEvent(
      {this.firstName, this.lastName, this.userId, this.profilePhoto});
}

class UpdateProfileState {}

class UpdateProfileInitialState extends UpdateProfileState {}

class UpdateProfileLoadingState extends UpdateProfileState {}

class UpdateProfileSuccessState extends UpdateProfileState {
  final CommonModel commonModel;

  UpdateProfileSuccessState(this.commonModel);
}

class UpdateProfileErrorState extends UpdateProfileState {
  String errorMsg;
  UpdateProfileErrorState(this.errorMsg);
}

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final MainRepository repository;

  UpdateProfileBloc(this.repository) : super(UpdateProfileInitialState()) {
    on<UpdateProfileRefreshEvent>(_onUpdateProfileRefresh);
  }

  Future<void> _onUpdateProfileRefresh(
      UpdateProfileRefreshEvent event, Emitter<UpdateProfileState> emit) async {
    emit(UpdateProfileLoadingState());
    try {
      final result = await repository.updateProfile(
          firstName: event.firstName,
          lastName: event.lastName,
          profilePhoto: event.profilePhoto,
          userId: event.userId,); // API call

      if (result.isSuccess) {
        CommonModel commonModel = CommonModel.fromJson(result.data);
        emit(UpdateProfileSuccessState(commonModel));
      } else {
        emit(UpdateProfileErrorState(result.data.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(UpdateProfileErrorState(e.toString()));
    }
  }
}
