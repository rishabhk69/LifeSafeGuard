import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/city_list_model.dart';

import '../api/repository/base/auth/main_repo.dart';

class CityListEvent {}

class CityListRefreshEvent extends CityListEvent {

  CityListRefreshEvent();
}

class AddSelectedCityEvent extends CityListEvent {

  Cities? isInitialized;


  AddSelectedCityEvent(this.isInitialized);
}

class CityListState {}

class CityListInitialState extends CityListState {}

class CityListLoadingState extends CityListState {}

class CityListSuccessState extends CityListState {
  CityListModel cityListModel;

  CityListSuccessState(this.cityListModel);
}


class SelectedCitySuccessState extends CityListState {
  Cities? selectedCity;

  SelectedCitySuccessState(this.selectedCity);
}

class CityListErrorState extends CityListState {
  String errorMsg;

  CityListErrorState(this.errorMsg);
}

class CityListBloc extends Bloc<CityListEvent, CityListState> {
  final MainRepository repository;
  String? selectedCity;


  CityListBloc(this.repository) : super(CityListInitialState()) {
    on<CityListRefreshEvent>(_onCityListRefresh);
    on<AddSelectedCityEvent>(_addSelectedCityEvent);
  }

  Future<void> _onCityListRefresh(
      CityListRefreshEvent event, Emitter<CityListState> emit) async {
    emit(CityListLoadingState());
    try {
      final result = await repository.getCityList();

      if (result.isSuccess) {
        CityListModel  cityList = CityListModel.fromJson(result.data);
        // List<CityListModel> cityList = (result.data as List)
        //     .map((e) => CityListModel.fromJson(e as Map<String, dynamic>))
        //     .toList();
        emit(CityListSuccessState(cityList));
      } else {
        emit(CityListErrorState(result.data.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(CityListErrorState(e.toString()));
    }
  }


  Future<void> _addSelectedCityEvent(
      AddSelectedCityEvent event, Emitter<CityListState> emit) async {
    selectedCity = event.isInitialized?.city;
        emit(SelectedCitySuccessState(event.isInitialized));
  }
}
