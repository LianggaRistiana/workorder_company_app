import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/template_config/domain/usecases/get_service_templates_usecase.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/service_template_list/service_template_list_state.dart';

class ServiceTemplateListCubit extends Cubit<ServiceTemplateListState> {
  final GetServiceTemplatesUsecase getServiceTemplatesUsecase;

  ServiceTemplateListCubit({
    required this.getServiceTemplatesUsecase,
  }) : super(ServiceTemplateListState.initial());

  Future<void> fetchServiceTemplates(String companyTypeId) async {
    emit(state.copyWith(status: ServiceTemplateListStatus.loading));
    final result = await getServiceTemplatesUsecase(companyTypeId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ServiceTemplateListStatus.error,
        errorMessage: failure.message,
      )),
      (templates) => emit(state.copyWith(
        status: ServiceTemplateListStatus.success,
        serviceTemplates: templates,
      )),
    );
  }
}
