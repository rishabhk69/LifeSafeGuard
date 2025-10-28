import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/common_model.dart';

import '../../api/repository/base/auth/main_repo.dart';

class DeleteAccountEvent {}

class DeleteAccountRefreshEvent extends DeleteAccountEvent {

  String userId;
  String reason;
  DeleteAccountRefreshEvent(this.userId,this.reason);
}

class DeleteAccountState {}

class DeleteAccountInitialState extends DeleteAccountState {}

class DeleteAccountLoadingState extends DeleteAccountState {}

class DeleteAccountSuccessState extends DeleteAccountState {
  final CommonModel commonModel;

  DeleteAccountSuccessState(this.commonModel);
}

class DeleteAccountErrorState extends DeleteAccountState {
  String errorMsg;
  DeleteAccountErrorState(this.errorMsg);
}

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final MainRepository repository;

  DeleteAccountBloc(this.repository) : super(DeleteAccountInitialState()) {
    on<DeleteAccountRefreshEvent>(_onDeleteAccountRefresh);
  }

  Future<void> _onDeleteAccountRefresh(
      DeleteAccountRefreshEvent event, Emitter<DeleteAccountState> emit) async {
    emit(DeleteAccountLoadingState());
    try {
      final result = await repository.deleteAccount(event.userId,event.reason); // API call

      if (result.isSuccess) {
        CommonModel commonModel = CommonModel.fromJson(result.data);
        emit(DeleteAccountSuccessState(commonModel));
      } else {
        emit(DeleteAccountErrorState(result.error ?? "Something went wrong"));
      }
    } catch (e) {
      emit(DeleteAccountErrorState(e.toString()));
    }
  }
}
