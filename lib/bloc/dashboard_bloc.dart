import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardEvent {}

class DashboardRefreshEvent extends DashboardEvent {
  final int currentIndex;
  DashboardRefreshEvent(this.currentIndex);
}

class DashboardState {}

class DashboardInitialState extends DashboardState {}

class DashboardLoadingState extends DashboardState {}

class DashboardSuccessState extends DashboardState {
  final int selectedIndex;
  DashboardSuccessState(this.selectedIndex);
}

class DashboardErrorState extends DashboardState {
  final String errorMsg;
  DashboardErrorState(this.errorMsg);
}

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  int? selectedIndex;

  DashboardBloc() : super(DashboardInitialState()) {
    on<DashboardRefreshEvent>((event, emit) async {
      selectedIndex = event.currentIndex;
      emit(DashboardLoadingState());
      try {
        emit(DashboardSuccessState(event.currentIndex));
      } catch (e) {
        emit(DashboardErrorState(e.toString()));
      }
    });
  }
}
