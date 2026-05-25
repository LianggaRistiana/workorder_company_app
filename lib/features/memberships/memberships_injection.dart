import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/memberships/data/datasources/memberships_remote_datasource.dart';
import 'package:workorder_company_app/features/memberships/data/repositories/memberships_repository_impl.dart';
import 'package:workorder_company_app/features/memberships/domain/repositories/memberships_repository.dart';
import 'package:workorder_company_app/features/memberships/domain/usecases/claim_membership_code_usecase.dart';
import 'package:workorder_company_app/features/memberships/domain/usecases/delete_membership_code_usecase.dart';
import 'package:workorder_company_app/features/memberships/domain/usecases/get_members_usecase.dart';
import 'package:workorder_company_app/features/memberships/domain/usecases/get_membership_codes_usecase.dart';
import 'package:workorder_company_app/features/memberships/domain/usecases/upload_membership_csv_file_usecase.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/claim/claim_membership_code_cubit.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/code_list/membership_code_list_bloc.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/delete/delete_membership_code_cubit.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/member_list/member_list_bloc.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/upload_csv/upload_membership_csv_cubit.dart';

Future<void> initMembershipsFeature() async {
  sl.registerLazySingleton<MembershipsRepository>(
      () => MembershipsRepositoryImpl(sl()));
  sl.registerLazySingleton<MembershipsRemoteDatasource>(
      () => MembershipsRemoteDatasourceImpl(sl()));

  sl.registerLazySingleton<GetMembershipCodesUsecase>(
      () => GetMembershipCodesUsecase(sl()));
  sl.registerLazySingleton<ClaimMembershipCodeUsecase>(
      () => ClaimMembershipCodeUsecase(sl()));
  sl.registerLazySingleton<GetMembersUsecase>(() => GetMembersUsecase(sl()));
  sl.registerLazySingleton<DeleteMembershipCodeUsecase>(
      () => DeleteMembershipCodeUsecase(sl()));
  sl.registerLazySingleton<UploadMembershipCsvFileUsecase>(
      () => UploadMembershipCsvFileUsecase(sl()));

  sl.registerFactory(() => MembershipCodeListBloc(sl()));
  sl.registerFactory(() => MemberListBloc(sl()));
  sl.registerFactory(() => ClaimMembershipCodeCubit(sl()));
  sl.registerFactory(() => DeleteMembershipCodeCubit(sl()));
  sl.registerFactory(() => UploadMembershipCsvCubit(sl()));
}
