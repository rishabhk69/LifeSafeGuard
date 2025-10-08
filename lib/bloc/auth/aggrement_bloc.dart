import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/auth/agreement_model.dart';

import '../../api/repository/base/auth/main_repo.dart';

class AgreementEvent {}

class AgreementRefreshEvent extends AgreementEvent {

  AgreementRefreshEvent();
}

class AgreementState {}

class AgreementInitialState extends AgreementState {}

class AgreementLoadingState extends AgreementState {}

class AgreementSuccessState extends AgreementState {
   dynamic agreementModel;

  AgreementSuccessState(this.agreementModel);
}

class AgreementErrorState extends AgreementState {
  String errorMsg;
  AgreementErrorState(this.errorMsg);
}

class AgreementBloc extends Bloc<AgreementEvent, AgreementState> {
  final MainRepository repository;

  AgreementBloc(this.repository) : super(AgreementInitialState()) {
    on<AgreementRefreshEvent>(_onAgreementRefresh);
  }

  Future<void> _onAgreementRefresh(
      AgreementRefreshEvent event, Emitter<AgreementState> emit) async {
    emit(AgreementLoadingState());
    try {
      final result = await repository.agreementData(); // API call

      if (result.isSuccess) {
        emit(AgreementSuccessState(result.data));
      } else {
        emit(AgreementErrorState(result.data.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(AgreementErrorState(e.toString()));
    }
  }
}
