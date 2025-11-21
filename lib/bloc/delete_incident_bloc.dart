import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/common_model.dart';

import '../../api/repository/base/auth/main_repo.dart';

class DeleteIncidentEvent {}

class DeleteIncidentRefreshEvent extends DeleteIncidentEvent {

  String incidentId;
  String reason;
  DeleteIncidentRefreshEvent(this.incidentId,this.reason);
}

class DeleteIncidentState {}

class DeleteIncidentInitialState extends DeleteIncidentState {}

class DeleteIncidentLoadingState extends DeleteIncidentState {}

class DeleteIncidentSuccessState extends DeleteIncidentState {
  final CommonModel commonModel;

  DeleteIncidentSuccessState(this.commonModel);
}

class DeleteIncidentErrorState extends DeleteIncidentState {
  String errorMsg;
  DeleteIncidentErrorState(this.errorMsg);
}

class DeleteIncidentBloc extends Bloc<DeleteIncidentEvent, DeleteIncidentState> {
  final MainRepository repository;

  DeleteIncidentBloc(this.repository) : super(DeleteIncidentInitialState()) {
    on<DeleteIncidentRefreshEvent>(_onDeleteIncidentRefresh);
  }

  Future<void> _onDeleteIncidentRefresh(
      DeleteIncidentRefreshEvent event, Emitter<DeleteIncidentState> emit) async {
    emit(DeleteIncidentLoadingState());
    try {
      final result = await repository.deleteIncident(event.incidentId,event.reason);

      if (result.isSuccess) {
        CommonModel commonModel = CommonModel.fromJson(result.data);
        emit(DeleteIncidentSuccessState(commonModel));
      } else {
        emit(DeleteIncidentErrorState(result.error));
      }
    } catch (e) {
      emit(DeleteIncidentErrorState(e.toString()));
    }
  }
}
