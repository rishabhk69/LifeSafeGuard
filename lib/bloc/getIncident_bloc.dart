import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/main/incidents_model.dart';

import '../api/repository/base/auth/main_repo.dart';

class IncidentsEvent {}

class IncidentsRefreshEvent extends IncidentsEvent {

  int? offset;
  int? size;

  IncidentsRefreshEvent(this.size,this.offset);
}

class IncidentsState {}

class IncidentsInitialState extends IncidentsState {}

class IncidentsLoadingState extends IncidentsState {}

class IncidentsSuccessState extends IncidentsState {
  final List<IncidentsModel> incidentsModel;

  IncidentsSuccessState(this.incidentsModel);
}

class IncidentsErrorState extends IncidentsState {
  String errorMsg;

  IncidentsErrorState(this.errorMsg);
}

class IncidentsBloc extends Bloc<IncidentsEvent, IncidentsState> {
  final MainRepository repository;

  IncidentsBloc(this.repository) : super(IncidentsInitialState()) {
    on<IncidentsRefreshEvent>(_onIncidentsRefresh);
  }

  Future<void> _onIncidentsRefresh(
      IncidentsRefreshEvent event, Emitter<IncidentsState> emit) async {
    emit(IncidentsLoadingState());
    try {
      final result = await repository.getIncidents(size: event.size, offset :event.offset); // API call

      if (result.isSuccess) {
        List<IncidentsModel> incidents = (result.data as List)
            .map((e) => IncidentsModel.fromJson(e as Map<String, dynamic>))
            .toList();
        emit(IncidentsSuccessState(incidents));
      } else {
        emit(IncidentsErrorState(result.data.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(IncidentsErrorState(e.toString()));
    }
  }
}
