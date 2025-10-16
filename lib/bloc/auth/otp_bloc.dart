import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/auth/otp_verify_model.dart';

import '../../api/repository/base/auth/main_repo.dart';

class OtpEvent {}

class OtpRefreshEvent extends OtpEvent {

  String? phoneNumber;
  String? otp;
  OtpRefreshEvent({this.phoneNumber, this.otp});
}

class OtpState {}

class OtpInitialState extends OtpState {}

class OtpLoadingState extends OtpState {}

class OtpSuccessState extends OtpState {
  final OtpVerifyModel otpData;

  OtpSuccessState(this.otpData);
}

class OtpErrorState extends OtpState {
  String errorMsg;
  OtpErrorState(this.errorMsg);
}

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final MainRepository repository;

  OtpBloc(this.repository) : super(OtpInitialState()) {
    on<OtpRefreshEvent>(_onOtpRefresh);
  }

  Future<void> _onOtpRefresh(
      OtpRefreshEvent event, Emitter<OtpState> emit) async {
    emit(OtpLoadingState());
    try {
      final result = await repository.verifyOtp(event.phoneNumber??"",event.otp??""); // API call

      if (result.isSuccess) {
        OtpVerifyModel otpData = OtpVerifyModel.fromJson(result.data);
        emit(OtpSuccessState(otpData));
      } else {
        emit(OtpErrorState(result.error ?? "Something went wrong"));
      }
    } catch (e) {
      emit(OtpErrorState(e.toString()));
    }
  }
}
