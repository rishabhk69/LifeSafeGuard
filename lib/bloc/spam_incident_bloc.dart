import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/common_model.dart';

import '../../api/repository/base/auth/main_repo.dart';
import '../api/model/main/block_incident_model.dart';

class SpamIncidentEvent {}

class SpamIncidentRefreshEvent extends SpamIncidentEvent {

  String? userId;
  String? incidentId;

  SpamIncidentRefreshEvent({this.userId, this.incidentId});


}

class SpamIncidentState {}

class SpamIncidentInitialState extends SpamIncidentState {}

class SpamIncidentLoadingState extends SpamIncidentState {}

class SpamIncidentSuccessState extends SpamIncidentState {
  final CommonModel spamIncidentData;

  SpamIncidentSuccessState(this.spamIncidentData);
}

class SpamIncidentErrorState extends SpamIncidentState {
  String errorMsg;
  SpamIncidentErrorState(this.errorMsg);
}

class SpamIncidentBloc extends Bloc<SpamIncidentEvent, SpamIncidentState> {
  final MainRepository repository;

  SpamIncidentBloc(this.repository) : super(SpamIncidentInitialState()) {
    on<SpamIncidentRefreshEvent>(_onSpamIncidentRefresh);
  }

  Future<void> _onSpamIncidentRefresh(
      SpamIncidentRefreshEvent event, Emitter<SpamIncidentState> emit) async {
    emit(SpamIncidentLoadingState());
    try {
      final result = await repository.spamIncident(
           incidentId: event.incidentId,
          userId: event.userId,

      ); // API call

      if (result.isSuccess) {
        CommonModel spamIncidentData = CommonModel.fromJson(result.data);
        emit(SpamIncidentSuccessState(spamIncidentData));
      } else {
        emit(SpamIncidentErrorState(result.data.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(SpamIncidentErrorState(e.toString()));
    }
  }
}
