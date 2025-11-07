import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/city_list_model.dart';

import '../api/repository/base/auth/main_repo.dart';

class CityListEvent {}

class CityListRefreshEvent extends CityListEvent {

  CityListRefreshEvent();
}

class CityListState {}

class CityListInitialState extends CityListState {}

class CityListLoadingState extends CityListState {}

class CityListSuccessState extends CityListState {
  CityListModel cityListModel;

  CityListSuccessState(this.cityListModel);
}

class CityListErrorState extends CityListState {
  String errorMsg;

  CityListErrorState(this.errorMsg);
}

class CityListBloc extends Bloc<CityListEvent, CityListState> {
  Cities? selectedCity;
  final MainRepository repository;


  CityListBloc(this.repository) : super(CityListInitialState()) {
    on<CityListRefreshEvent>(_onCityListRefresh);
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
}
