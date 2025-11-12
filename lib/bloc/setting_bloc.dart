import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/city_list_model.dart';
import 'package:untitled/api/model/main/incident_type_list_model.dart';
import 'package:untitled/api/model/setting_model.dart';

import '../api/repository/base/auth/main_repo.dart';

class SettingEvent {}

class SettingRefreshEvent extends SettingEvent {

  SettingRefreshEvent();
}

class SettingState {}

class SettingInitialState extends SettingState {}

class SettingLoadingState extends SettingState {}

class SettingSuccessState extends SettingState {
  SettingModel settingModel;

  SettingSuccessState(this.settingModel);
}

class SettingErrorState extends SettingState {
  String errorMsg;

  SettingErrorState(this.errorMsg);
}

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  Cities? selectedCity;
  final MainRepository repository;


  SettingBloc(this.repository) : super(SettingInitialState()) {
    on<SettingRefreshEvent>(_onSettingRefresh);
  }

  Future<void> _onSettingRefresh(
      SettingRefreshEvent event, Emitter<SettingState> emit) async {
    emit(SettingLoadingState());
    try {
      final result = await repository.settingData();

      if (result.isSuccess) {
        dynamic data = result.data;
        if (data is String) {
          data = jsonDecode(data);
        }
        SettingModel settingModel = SettingModel.fromJson(data);
        emit(SettingSuccessState(settingModel));
      } else {
        emit(SettingErrorState(result.data.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(SettingErrorState(e.toString()));
    }
  }
}
