import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/invitations/data/datasources/receiver_invitations_remote_datasource.dart';
import 'package:workorder_company_app/features/invitations/data/datasources/sender_invitations_remote_datasource.dart';
import 'package:workorder_company_app/features/invitations/data/repositories/invitations_repository_impl.dart';
import 'package:workorder_company_app/features/invitations/domain/repositories/invitations_repository.dart';
import 'package:workorder_company_app/features/invitations/domain/usecases/get_invitations_history_usecase.dart';
import 'package:workorder_company_app/features/invitations/domain/usecases/invite_employees_usecase.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/history_invitations_list/history_invitations_list_bloc.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/invite/invite_employees_cubit.dart';

Future<void> initInvitationsFeature() async {
  sl.registerSingleton<SenderInvitationsRemoteDatasource>(
    SenderInvitationsRemoteDatasourceImpl(sl()),
  );
  sl.registerSingleton<ReceiverInvitationsRemoteDatasource>(
    ReceiverInvitationsRemoteDatasourceImpl(),
  );

  sl.registerLazySingleton<InvitationsRepository>(
    () => InvitationsRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton<GetInvitationsHistoryUsecase>(
    () => GetInvitationsHistoryUsecase(sl()),
  );

  sl.registerLazySingleton<InviteEmployeesUsecase>(
    () => InviteEmployeesUsecase(sl()),
  );

  sl.registerFactory<InviteEmployeesCubit>(() => InviteEmployeesCubit(sl()));
  sl.registerFactory<HistoryInvitationsListBloc>(
    () => HistoryInvitationsListBloc(sl()),
  );
}
