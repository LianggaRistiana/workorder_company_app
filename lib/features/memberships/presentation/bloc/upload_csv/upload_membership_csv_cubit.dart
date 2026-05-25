import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/memberships/domain/usecases/upload_membership_csv_file_usecase.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/upload_csv/upload_membership_csv_state.dart';

class UploadMembershipCsvCubit extends Cubit<UploadMembershipCsvState> {
  final UploadMembershipCsvFileUsecase _uploadMembershipCsvFile;

  UploadMembershipCsvCubit(this._uploadMembershipCsvFile)
      : super(const UploadMembershipCsvState());

  Future<void> upload(String filePath) async {
    emit(state.copyWith(status: UploadMembershipCsvStatus.loading));

    final result = await _uploadMembershipCsvFile(filePath);

    result.fold(
      (failure) => emit(state.copyWith(
        status: UploadMembershipCsvStatus.failure,
        errorMessage: failure.message,
      )),
      (membershipCodes) => emit(state.copyWith(
        status: UploadMembershipCsvStatus.success,
        membershipCodes: membershipCodes,
      )),
    );
  }

  void reset() {
    emit(const UploadMembershipCsvState());
  }
}
