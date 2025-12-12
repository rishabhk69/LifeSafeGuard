
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/main/post_incidents_model.dart';

import '../../api/repository/base/auth/main_repo.dart';

class EditIncidentsEvent {}

class EditIncidentsRefreshEvent extends EditIncidentsEvent {

  String? title;
  String? description;
  String? category;
  String? city;
  String? userId;
  String? incidentId;
  bool? reportAnonymously;


  EditIncidentsRefreshEvent({this.title, this.incidentId,this.description, this.category,
   this.reportAnonymously,
    this.userId,this.city});
}

class EditIncidentsState {}

class EditIncidentsInitialState extends EditIncidentsState {}

class EditIncidentsLoadingState extends EditIncidentsState {}

class EditIncidentsSuccessState extends EditIncidentsState {
  final PostIncidentsModel editIncidentsData;

  EditIncidentsSuccessState(this.editIncidentsData);
}

class EditIncidentsErrorState extends EditIncidentsState {
  String errorMsg;
  EditIncidentsErrorState(this.errorMsg);
}

class EditIncidentsBloc extends Bloc<EditIncidentsEvent, EditIncidentsState> {
  final MainRepository repository;

  EditIncidentsBloc(this.repository) : super(EditIncidentsInitialState()) {
    on<EditIncidentsRefreshEvent>(_onEditIncidentsRefresh);
  }

  Future<void> _onEditIncidentsRefresh(
      EditIncidentsRefreshEvent event, Emitter<EditIncidentsState> emit) async {
    emit(EditIncidentsLoadingState());
    try {
      final result = await repository.editIncidents(
        category: event.category,
          description: event.description,
          reportAnonymously: event.reportAnonymously,
          title:event.title,
          city: event.city,
          userId: event.userId,
        incidentId: event.incidentId,
      ); // API call

      if (result.isSuccess) {
        PostIncidentsModel editIncidentsData = PostIncidentsModel.fromJson(result.data);
        emit(EditIncidentsSuccessState(editIncidentsData));
      } else {
        emit(EditIncidentsErrorState(result.data.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(EditIncidentsErrorState(e.toString()));
    }
  }
}
