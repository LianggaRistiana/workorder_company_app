import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/submissions/core/file_upload_manager.dart';
import 'package:workorder_company_app/features/submissions/presentation/cubit/file_upload_progress_state.dart';

class FileUploadProgressCubit extends Cubit<FileUploadProgressState> {
  final UploadManager _manager;
  StreamSubscription? _sub;

  FileUploadProgressCubit(this._manager) : super(const FileUploadProgressState()) {
    _sub = _manager.stream.listen((tasks) {
      emit(FileUploadProgressState(tasks: tasks));
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
