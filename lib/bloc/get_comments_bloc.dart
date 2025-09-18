import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/model/comments_model.dart';

import '../api/repository/base/auth/main_repo.dart';

class CommentsEvent {}

class CommentsRefreshEvent extends CommentsEvent {

  int? offset;
  int? size;
  String? incidentId;

  CommentsRefreshEvent(this.size,this.offset,this.incidentId);
}

class CommentsState {}

class CommentsInitialState extends CommentsState {}

class CommentsLoadingState extends CommentsState {}

class CommentsSuccessState extends CommentsState {
  final List<CommentsModel> commentsModel;

  CommentsSuccessState(this.commentsModel);
}

class CommentsErrorState extends CommentsState {
  String errorMsg;

  CommentsErrorState(this.errorMsg);
}

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final MainRepository repository;

  CommentsBloc(this.repository) : super(CommentsInitialState()) {
    on<CommentsRefreshEvent>(_onCommentsRefresh);
  }

  Future<void> _onCommentsRefresh(
      CommentsRefreshEvent event, Emitter<CommentsState> emit) async {
    emit(CommentsLoadingState());
    try {
      final result = await repository.getComments(size: event.size, offset :event.offset,incidentId: event.incidentId);

      if (result.isSuccess) {
        List<CommentsModel> comments = (result.data as List)
            .map((e) => CommentsModel.fromJson(e as Map<String, dynamic>))
            .toList();
        emit(CommentsSuccessState(comments));
      } else {
        emit(CommentsErrorState(result.data.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(CommentsErrorState(e.toString()));
    }
  }
}
