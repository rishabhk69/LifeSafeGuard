import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/main/blocked_list_model.dart';

import '../../api/repository/base/auth/main_repo.dart';

class BlockedIncidentsEvent {}

class BlockedIncidentsRefreshEvent extends BlockedIncidentsEvent {

  int? offset;
  int? size;

  BlockedIncidentsRefreshEvent({this.size, this.offset});
}

class BlockedIncidentsState {}

class BlockedIncidentsInitialState extends BlockedIncidentsState {}

class BlockedIncidentsLoadingState extends BlockedIncidentsState {}

class BlockedIncidentsSuccessState extends BlockedIncidentsState {
  List<BlockedListModel> blockedListModel;

  BlockedIncidentsSuccessState(this.blockedListModel);
}

class BlockedIncidentsErrorState extends BlockedIncidentsState {
  String errorMsg;
  BlockedIncidentsErrorState(this.errorMsg);
}

class BlockedIncidentsBloc extends Bloc<BlockedIncidentsEvent, BlockedIncidentsState> {
  final MainRepository repository;

  BlockedIncidentsBloc(this.repository) : super(BlockedIncidentsInitialState()) {
    on<BlockedIncidentsRefreshEvent>(_onBlockedIncidentsRefresh);
  }

  Future<void> _onBlockedIncidentsRefresh(
      BlockedIncidentsRefreshEvent event, Emitter<BlockedIncidentsState> emit) async {
    emit(BlockedIncidentsLoadingState());
    try {
      final result = await repository.getBlockedIncidents(event.offset, event.size); // API call

      if (result.isSuccess) {
        List<BlockedListModel> blockedListModel = (result.data as List)
            .map((e) => BlockedListModel.fromJson(e as Map<String, dynamic>))
            .toList();
        // BlockedListModel blockedListModel = BlockedListModel.fromJson(result.data);
        emit(BlockedIncidentsSuccessState(blockedListModel));
      } else {
        emit(BlockedIncidentsErrorState(result.data.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(BlockedIncidentsErrorState(e.toString()));
    }
  }
}
