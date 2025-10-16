import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/main/incidents_model.dart';

import '../api/repository/base/auth/main_repo.dart';

class IncidentsEvent {}

class IncidentsRefreshEvent extends IncidentsEvent {

  int? offset;
  int? size;

  IncidentsRefreshEvent(this.size,this.offset);
}

class InitializeRefreshEvent extends IncidentsEvent {

  bool? isInitialized;

  InitializeRefreshEvent(this.isInitialized);
}

class IncidentsState {}

class IncidentsInitialState extends IncidentsState {}

class IncidentsLoadingState extends IncidentsState {}

class IncidentsSuccessState extends IncidentsState {
  final List<IncidentsModel> incidentsModel;

  IncidentsSuccessState(this.incidentsModel);
}


class InitializeSuccessState extends IncidentsState {
  bool? isInitialized;

  InitializeSuccessState(this.isInitialized);
}

class IncidentsErrorState extends IncidentsState {
  String errorMsg;

  IncidentsErrorState(this.errorMsg);
}

class IncidentsLoadMoreEvent extends IncidentsEvent {
  final int size;
  final int offset;
  IncidentsLoadMoreEvent(this.size, this.offset);
}

class IncidentsBloc extends Bloc<IncidentsEvent, IncidentsState> {
  final MainRepository repository;
  bool isInitialize = false;
  List<IncidentsModel> allIncidents = []; // ✅ cache list

  IncidentsBloc(this.repository) : super(IncidentsInitialState()) {
    on<IncidentsRefreshEvent>(_onIncidentsRefresh);
    on<IncidentsLoadMoreEvent>(_onLoadMore);
    on<InitializeRefreshEvent>(_onInitializeRefresh);
  }

  Future<void> _onIncidentsRefresh(
      IncidentsRefreshEvent event, Emitter<IncidentsState> emit) async {
    emit(IncidentsLoadingState());
    try {
      final result = await repository.getIncidents(
        size: event.size,
        offset: event.offset,
      );

      if (result.isSuccess) {
        allIncidents = (result.data as List)
            .map((e) => IncidentsModel.fromJson(e as Map<String, dynamic>))
            .toList();
        emit(IncidentsSuccessState(allIncidents));
      } else {
        emit(IncidentsErrorState("Something went wrong"));
      }
    } catch (e) {
      emit(IncidentsErrorState(e.toString()));
    }
  }

  Future<void> _onLoadMore(
      IncidentsLoadMoreEvent event, Emitter<IncidentsState> emit) async {
    try {
      final result = await repository.getIncidents(
        size: event.size,
        offset: event.offset,
      );

      if (result.isSuccess) {
        final newData = (result.data as List)
            .map((e) => IncidentsModel.fromJson(e as Map<String, dynamic>))
            .toList();

        if (newData.isNotEmpty) {
          allIncidents.addAll(newData);
          emit(IncidentsSuccessState(List.from(allIncidents))); // ✅ update UI
        }
      }
    } catch (e) {
      emit(IncidentsErrorState(e.toString()));
    }
  }

  Future<void> _onInitializeRefresh(
      InitializeRefreshEvent event, Emitter<IncidentsState> emit) async {
    if (event.isInitialized == true) isInitialize = true;
    emit(InitializeSuccessState(event.isInitialized ?? false));
  }
}
