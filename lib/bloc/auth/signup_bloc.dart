import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/auth/signup_model.dart';

import '../../api/repository/base/auth/main_repo.dart';

class SignupEvent {}

class SignupRefreshEvent extends SignupEvent {

  String? firstName; String? lastName; String? userName; File? profilePhoto;
  SignupRefreshEvent(
      {this.firstName, this.lastName, this.userName, this.profilePhoto});
}

class SignupState {}

class SignupInitialState extends SignupState {}

class SignupLoadingState extends SignupState {}

class SignupSuccessState extends SignupState {
  final SignUpModel signupData;

  SignupSuccessState(this.signupData);
}

class SignupErrorState extends SignupState {
  String errorMsg;
  SignupErrorState(this.errorMsg);
}

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final MainRepository repository;

  SignupBloc(this.repository) : super(SignupInitialState()) {
    on<SignupRefreshEvent>(_onSignupRefresh);
  }

  Future<void> _onSignupRefresh(
      SignupRefreshEvent event, Emitter<SignupState> emit) async {
    emit(SignupLoadingState());
    try {
      final result = await repository.getSignUp(
          firstName: event.firstName,
          lastName: event.lastName,
          profilePhoto: event.profilePhoto,
          userName: event.userName,); // API call

      if (result.isSuccess) {
        SignUpModel signupData = SignUpModel.fromJson(result.data);
        emit(SignupSuccessState(signupData));
      } else {
        emit(SignupErrorState(result.data.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(SignupErrorState(e.toString()));
    }
  }
}
