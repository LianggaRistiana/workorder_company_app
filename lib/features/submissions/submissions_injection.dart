
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/submissions/presentation/bloc/submission_bloc.dart';

Future<void> initSubmissionsFeature() async {
  sl.registerFactory<SubmissionBloc>(
      () => SubmissionBloc(publicGetServiceFormUsecase : sl()));
}
