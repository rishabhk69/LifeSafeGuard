import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/common_model.dart';

import '../../api/repository/base/auth/main_repo.dart';
import '../api/model/main/block_incident_model.dart';

class SupportHelpEvent {}

class SupportHelpRefreshEvent extends SupportHelpEvent {

  String? supportType;
      String? subject;
  String? details;
      String? inqueryType;
  String? name;
      String? number;
  String? email;

  SupportHelpRefreshEvent({
    this.supportType,
    this.subject,
    this.details,
    this.inqueryType,
    this.number,
    this.name,
    this.email,
});
}

class SupportHelpState {}

class SupportHelpInitialState extends SupportHelpState {}

class SupportHelpLoadingState extends SupportHelpState {}

class SupportHelpSuccessState extends SupportHelpState {
  final CommonModel SupportHelpData;

  SupportHelpSuccessState(this.SupportHelpData);
}

class SupportHelpErrorState extends SupportHelpState {
  String errorMsg;
  SupportHelpErrorState(this.errorMsg);
}

class SupportHelpBloc extends Bloc<SupportHelpEvent, SupportHelpState> {
  final MainRepository repository;

  SupportHelpBloc(this.repository) : super(SupportHelpInitialState()) {
    on<SupportHelpRefreshEvent>(_onSupportHelpRefresh);
  }

  Future<void> _onSupportHelpRefresh(
      SupportHelpRefreshEvent event, Emitter<SupportHelpState> emit) async {
    emit(SupportHelpLoadingState());
    try {
      final result = await repository.supportHelp(
        supportType: event.supportType,
        subject: event.subject,
        details: event.details,
        inqueryType: event.inqueryType,
        name: event.name,
        number: event.number,
        email: event.email
      ); // API call

      if (result.isSuccess) {
        CommonModel supportHelpData = CommonModel.fromJson(result.data);
        emit(SupportHelpSuccessState(supportHelpData));
      } else {
        emit(SupportHelpErrorState(result.data.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(SupportHelpErrorState(e.toString()));
    }
  }
}
