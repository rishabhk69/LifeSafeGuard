

import 'package:flutter_bloc/flutter_bloc.dart';

class IncrementEvent {}

class IncrementRefreshEvent extends IncrementEvent {
  int value;
  IncrementRefreshEvent(this.value);
}

class IncrementState {}

class IncrementInitialState extends IncrementState {}

class IncrementLoadingState extends IncrementState {}

class IncrementSuccessState extends IncrementState {
  int? updatedVal;

  IncrementSuccessState(this.updatedVal);
}

class IncrementErrorState extends IncrementState {
  String errorMsg;
  IncrementErrorState(this.errorMsg);
}

class IncrementBloc extends Bloc<IncrementEvent, IncrementState> {

  IncrementBloc() : super(IncrementInitialState());

  Stream<IncrementState> mapEventToState(IncrementEvent event) async* {
    if (event is IncrementRefreshEvent) {
      yield IncrementLoadingState();
      try{
        yield IncrementSuccessState(event.value);
      }
      catch (e){
        // Catcher.reportCheckedError(e, stackTrace);
      }
    }
  }
}
