import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/repository/base/auth/main_repo.dart';

class SetIncidentsEvent {}

class SetIncidentsRefreshEvent extends SetIncidentsEvent {

  String? incidentName;

  SetIncidentsRefreshEvent({this.incidentName});


}

class SetIncidentsState {}

class SetIncidentsInitialState extends SetIncidentsState {}

class SetIncidentsLoadingState extends SetIncidentsState {}

class SetIncidentsSuccessState extends SetIncidentsState {
  final String selectedIncidentName;

  SetIncidentsSuccessState(this.selectedIncidentName);
}

class SetIncidentsErrorState extends SetIncidentsState {
  String errorMsg;
  SetIncidentsErrorState(this.errorMsg);
}

class SetIncidentsBloc extends Bloc<SetIncidentsEvent, SetIncidentsState> {
  String selectedIncident = 'Select Type';
  SetIncidentsBloc() : super(SetIncidentsInitialState()) {
    on<SetIncidentsRefreshEvent>(_onSetIncidentsRefresh);
  }

  Future<void> _onSetIncidentsRefresh(
      SetIncidentsRefreshEvent event, Emitter<SetIncidentsState> emit) async {
    emit(SetIncidentsLoadingState());
    try {
      selectedIncident = event.incidentName??"";
        emit(SetIncidentsSuccessState(event.incidentName??""));
    } catch (e) {
      emit(SetIncidentsErrorState(e.toString()));
    }
  }
}
