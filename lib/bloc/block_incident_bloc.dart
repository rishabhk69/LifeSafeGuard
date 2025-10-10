import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/repository/base/auth/main_repo.dart';
import '../api/model/main/block_incident_model.dart';

class BlockIncidentEvent {}

class BlockIncidentRefreshEvent extends BlockIncidentEvent {

  String? title;
  String? description;
  String? userId;
  String? incidentId;
  List<String>? urls;

  BlockIncidentRefreshEvent({this.title, this.description, this.userId,
    this.incidentId, this.urls});


}

class BlockIncidentState {}

class BlockIncidentInitialState extends BlockIncidentState {}

class BlockIncidentLoadingState extends BlockIncidentState {}

class BlockIncidentSuccessState extends BlockIncidentState {
  final BlockIncidentModel blockIncidentData;

  BlockIncidentSuccessState(this.blockIncidentData);
}

class BlockIncidentErrorState extends BlockIncidentState {
  String errorMsg;
  BlockIncidentErrorState(this.errorMsg);
}

class BlockIncidentBloc extends Bloc<BlockIncidentEvent, BlockIncidentState> {
  final MainRepository repository;

  BlockIncidentBloc(this.repository) : super(BlockIncidentInitialState()) {
    on<BlockIncidentRefreshEvent>(_onBlockIncidentRefresh);
  }

  Future<void> _onBlockIncidentRefresh(
      BlockIncidentRefreshEvent event, Emitter<BlockIncidentState> emit) async {
    emit(BlockIncidentLoadingState());
    try {
      final result = await repository.blockIncident(
          description: event.description,
         incidentId: event.incidentId,
          title:event.title,
          urls: event.urls,
          userId: event.userId,

      ); // API call

      if (result.isSuccess) {
        BlockIncidentModel blockIncidentData = BlockIncidentModel.fromJson(result.data);
        emit(BlockIncidentSuccessState(blockIncidentData));
      } else {
        emit(BlockIncidentErrorState(result.data.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(BlockIncidentErrorState(e.toString()));
    }
  }
}
