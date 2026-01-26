import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/main/incidents_model.dart';
import 'package:untitled/constants/app_utils.dart';

import '../api/repository/base/auth/main_repo.dart';

class IncidentsEvent {}

class IncidentsRefreshEvent extends IncidentsEvent {

  int? offset;
  int? size;
  String? city;
  String? type;
  bool? isFilter;

  IncidentsRefreshEvent(this.size,this.offset, {this.type, this.city,this.isFilter});
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
  bool isFilter;
  IncidentsSuccessState(this.incidentsModel,this.isFilter);
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
  bool isFilter = false;
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


      String userId = await AppUtils().getUserId();
      final result = await repository.getIncidents(
        userId: userId,
        city: event.city,
        size: event.size,
        offset: event.offset,
        type: event.type,
      );
      if(event.isFilter??false){
        isFilter = event.isFilter!;
      }
      else{
        isFilter = false;
      }
      if (result.isSuccess) {
        allIncidents = (result.data as List)
            .map((e) => IncidentsModel.fromJson(e as Map<String, dynamic>))
            .toList();
        emit(IncidentsSuccessState(allIncidents,isFilter));
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
          emit(IncidentsSuccessState(List.from(allIncidents),isFilter));
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
