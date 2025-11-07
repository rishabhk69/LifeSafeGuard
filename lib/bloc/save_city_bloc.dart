import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/city_list_model.dart';

import '../api/repository/base/auth/main_repo.dart';

class SaveCityEvent {}

class SaveCityRefreshEvent extends SaveCityEvent {

  Cities? selectedCity;

  SaveCityRefreshEvent(this.selectedCity);
}

class SaveCityState {}

class SaveCityInitialState extends SaveCityState {}

class SaveCityLoadingState extends SaveCityState {}

class SaveCitySuccessState extends SaveCityState {
  Cities? selectedCity;

  SaveCitySuccessState(this.selectedCity);
}

class SaveCityErrorState extends SaveCityState {
  String errorMsg;

  SaveCityErrorState(this.errorMsg);
}

class SaveCityBloc extends Bloc<SaveCityEvent, SaveCityState> {
  final MainRepository repository;
  Cities? selectedCity;


  SaveCityBloc(this.repository) : super(SaveCityInitialState()) {
    on<SaveCityRefreshEvent>(_onSaveCityRefresh);
  }

  Future<void> _onSaveCityRefresh(
      SaveCityRefreshEvent event, Emitter<SaveCityState> emit) async {
    emit(SaveCityLoadingState());
    try {
      selectedCity = event.selectedCity;
        emit(SaveCitySuccessState(event.selectedCity));
    } catch (e) {
      emit(SaveCityErrorState(e.toString()));
    }
  }
}
