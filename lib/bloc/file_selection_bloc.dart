import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/repository/base/auth/auth_repo.dart';

class FileSelectionEvent {}

class FileSelectionRefreshEvent extends FileSelectionEvent {

  XFile? selectedFile ;
  int? isPhoto ;
  FileSelectionRefreshEvent(this.selectedFile,{this.isPhoto});
  
}

class FileSelectionState {}

class FileSelectionInitialState extends FileSelectionState {}

class FileSelectionLoadingState extends FileSelectionState {}

class FileSelectionSuccessState extends FileSelectionState {
  XFile? selectedFile ;

  FileSelectionSuccessState(this.selectedFile);
}

class FileSelectionErrorState extends FileSelectionState {
  String errorMsg;
  FileSelectionErrorState(this.errorMsg);
}

class FileSelectionBloc extends Bloc<FileSelectionEvent, FileSelectionState> {
  // AuthRepository authRepository = AuthRepository();
  XFile? selectedFile;
  int? isImage;

  FileSelectionBloc(/*this.authRepository*/) : super(FileSelectionInitialState());

  Stream<FileSelectionState> mapEventToState(FileSelectionEvent event) async* {
    if (event is FileSelectionRefreshEvent) {
      yield FileSelectionLoadingState();
      try{
        if(event.selectedFile!=null) {
          selectedFile = event.selectedFile;
          isImage = event.isPhoto;
          yield FileSelectionSuccessState(event.selectedFile);
        }
        else{
          yield FileSelectionErrorState('File Not selected');
        }
      }
      catch(e){
        yield FileSelectionErrorState(e.toString());
      }
    }
  }
}
