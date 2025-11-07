import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/city_list_model.dart';
import 'package:untitled/api/model/main/incident_type_list_model.dart';

import '../api/repository/base/auth/main_repo.dart';

class IncidentTypeEvent {}

class IncidentTypeRefreshEvent extends IncidentTypeEvent {

  IncidentTypeRefreshEvent();
}

class IncidentTypeState {}

class IncidentTypeInitialState extends IncidentTypeState {}

class IncidentTypeLoadingState extends IncidentTypeState {}

class IncidentTypeSuccessState extends IncidentTypeState {
  IncidentTypeModel incidentTypeModel;

  IncidentTypeSuccessState(this.incidentTypeModel);
}

class IncidentTypeErrorState extends IncidentTypeState {
  String errorMsg;

  IncidentTypeErrorState(this.errorMsg);
}

class IncidentTypeBloc extends Bloc<IncidentTypeEvent, IncidentTypeState> {
  Cities? selectedCity;
  final MainRepository repository;


  IncidentTypeBloc(this.repository) : super(IncidentTypeInitialState()) {
    on<IncidentTypeRefreshEvent>(_onIncidentTypeRefresh);
  }

  Future<void> _onIncidentTypeRefresh(
      IncidentTypeRefreshEvent event, Emitter<IncidentTypeState> emit) async {
    emit(IncidentTypeLoadingState());
    try {
      final result = await repository.getTypeList();

      if (result.isSuccess) {
        IncidentTypeModel  incidentType = IncidentTypeModel.fromJson(result.data);
        emit(IncidentTypeSuccessState(incidentType));
      } else {
        emit(IncidentTypeErrorState(result.data.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(IncidentTypeErrorState(e.toString()));
    }
  }
}
