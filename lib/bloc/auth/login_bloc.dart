import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/auth/login_model.dart';

import '../../api/repository/base/auth/main_repo.dart';

class LoginEvent {}

class LoginRefreshEvent extends LoginEvent {

  String phoneNumber;
  bool type;
  LoginRefreshEvent(this.phoneNumber,this.type);
}

class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final LoginModel loginData;

  LoginSuccessState(this.loginData);
}

class LoginErrorState extends LoginState {
  String errorMsg;
  LoginErrorState(this.errorMsg);
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final MainRepository repository;

  LoginBloc(this.repository) : super(LoginInitialState()) {
    on<LoginRefreshEvent>(_onLoginRefresh);
  }

  Future<void> _onLoginRefresh(
      LoginRefreshEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    try {
      final result = await repository.getLogin(event.phoneNumber,event.type); // API call

      if (result.isSuccess) {
        LoginModel loginData = LoginModel.fromJson(result.data);
        emit(LoginSuccessState(loginData));
      } else {
        emit(LoginErrorState(result.data.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(LoginErrorState(e.toString()));
    }
  }
}
