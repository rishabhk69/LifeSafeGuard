import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/city_list_model.dart';

import '../api/repository/base/auth/main_repo.dart';

class InstructionEvent {}

class InstructionRefreshEvent extends InstructionEvent {

  InstructionRefreshEvent();
}

class InstructionState {}

class InstructionInitialState extends InstructionState {}

class InstructionLoadingState extends InstructionState {}

class InstructionSuccessState extends InstructionState {
  dynamic dynamicResponse;

  InstructionSuccessState(this.dynamicResponse);
}

class InstructionErrorState extends InstructionState {
  String errorMsg;

  InstructionErrorState(this.errorMsg);
}

class InstructionBloc extends Bloc<InstructionEvent, InstructionState> {
  Cities? selectedCity;
  final MainRepository repository;


  InstructionBloc(this.repository) : super(InstructionInitialState()) {
    on<InstructionRefreshEvent>(_onInstructionRefresh);
  }

  Future<void> _onInstructionRefresh(
      InstructionRefreshEvent event, Emitter<InstructionState> emit) async {
    emit(InstructionLoadingState());
    try {
      final result = await repository.instructionData();

      if (result.isSuccess) {
        dynamic data = result.data;
        if (data is String) {
          data = jsonDecode(data);
        }
        dynamic instructionData = data;
        emit(InstructionSuccessState(instructionData));
      } else {
        emit(InstructionErrorState(result.data.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(InstructionErrorState(e.toString()));
    }
  }
}
