import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/invitation_codes/data/datasources/invitation_codes_remote_datasource.dart';
import 'package:workorder_company_app/features/invitation_codes/data/repositories/invitation_codes_repository_impl.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/repositories/invitation_codes_repository.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/usecases/claim_invitation_code_usecase.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/usecases/create_invitation_code_usecase.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/usecases/get_invitation_codes_usecase.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/usecases/preview_invitation_code_usecase.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/usecases/revoke_invitation_code_usecase.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/usecases/update_invitation_code_usecase.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/bloc/actions/invitation_code_action_cubit.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/bloc/claim/claim_invitation_code_cubit.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/bloc/code_list/invitation_code_list_bloc.dart';

Future<void> initInvitationCodesFeature() async {
  // Datasource
  sl.registerLazySingleton<InvitationCodesRemoteDatasource>(
    () => InvitationCodesRemoteDatasourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<InvitationCodesRepository>(
    () => InvitationCodesRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton<GetInvitationCodesUsecase>(
    () => GetInvitationCodesUsecase(sl()),
  );
  sl.registerLazySingleton<CreateInvitationCodeUsecase>(
    () => CreateInvitationCodeUsecase(sl()),
  );
  sl.registerLazySingleton<UpdateInvitationCodeUsecase>(
    () => UpdateInvitationCodeUsecase(sl()),
  );
  sl.registerLazySingleton<RevokeInvitationCodeUsecase>(
    () => RevokeInvitationCodeUsecase(sl()),
  );
  sl.registerLazySingleton<PreviewInvitationCodeUsecase>(
    () => PreviewInvitationCodeUsecase(sl()),
  );
  sl.registerLazySingleton<ClaimInvitationCodeUsecase>(
    () => ClaimInvitationCodeUsecase(sl()),
  );

  // BLoC / Cubits
  sl.registerFactory<InvitationCodeListBloc>(
    () => InvitationCodeListBloc(sl()),
  );
  sl.registerFactory<InvitationCodeActionCubit>(
    () => InvitationCodeActionCubit(sl(), sl(), sl()),
  );
  sl.registerFactory<ClaimInvitationCodeCubit>(
    () => ClaimInvitationCodeCubit(sl(), sl()),
  );
}
