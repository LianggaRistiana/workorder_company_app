
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/forms/domain/usecases/public_submit_intake_forms_usecase.dart';
import 'package:workorder_company_app/features/submissions/presentation/bloc/submission_bloc.dart';

Future<void> initSubmissionsFeature() async {
  sl.registerLazySingleton<PublicSubmitIntakeFormsUsecase>(() => PublicSubmitIntakeFormsUsecase(sl()));

  sl.registerFactory<SubmissionBloc>(
      () => SubmissionBloc(publicGetServiceFormUsecase : sl(), publicSubmitIntakeFormsUsecase: sl()));
}
