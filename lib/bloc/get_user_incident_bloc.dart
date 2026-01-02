import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/city_list_model.dart';
import 'package:untitled/api/model/main/profile_model.dart';

import '../api/repository/base/auth/main_repo.dart';

class UserIncidentsEvent {}

class UserIncidentsRefreshEvent extends UserIncidentsEvent {

  String userId;
  int size;
  int offSet;

  UserIncidentsRefreshEvent(this.userId,this.size,this.offSet);
}

class UserIncidentsState {}

class UserIncidentsInitialState extends UserIncidentsState {}

class UserIncidentsLoadingState extends UserIncidentsState {}

class UserIncidentsSuccessState extends UserIncidentsState {
  ProfileModel userIncidentsModel;

  UserIncidentsSuccessState(this.userIncidentsModel);
}

class UserIncidentsErrorState extends UserIncidentsState {
  String errorMsg;

  UserIncidentsErrorState(this.errorMsg);
}

class UserIncidentsBloc extends Bloc<UserIncidentsEvent, UserIncidentsState> {
  Cities? selectedCity;
  final MainRepository repository;


  UserIncidentsBloc(this.repository) : super(UserIncidentsInitialState()) {
    on<UserIncidentsRefreshEvent>(_onUserIncidentsRefresh);
  }

  Future<void> _onUserIncidentsRefresh(
      UserIncidentsRefreshEvent event, Emitter<UserIncidentsState> emit) async {
    emit(UserIncidentsLoadingState());
    try {
      final result = await repository.getIncidentsById(id: event.userId,offset: event.offSet,size: event.size);

      if (result.isSuccess) {
        ProfileModel  userIncidents = ProfileModel.fromJson(result.data);
        // List<UserIncidentsModel> UserIncidents = (result.data as List)
        //     .map((e) => UserIncidentsModel.fromJson(e as Map<String, dynamic>))
        //     .toList();
        emit(UserIncidentsSuccessState(userIncidents));
      } else {
        emit(UserIncidentsErrorState(result.data.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(UserIncidentsErrorState(e.toString()));
    }
  }
}
