import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/service_template_entity.dart';
import 'package:workorder_company_app/features/template_config/domain/usecases/generate_service_by_templates_usecase.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/generate_service/generate_service_state.dart';

class GenerateServiceCubit extends Cubit<GenerateServiceState> {
  final GenerateServiceByTemplatesUsecase generateServiceUsecase;

  GenerateServiceCubit({
    required this.generateServiceUsecase,
  }) : super(GenerateServiceState.initial());

  Future<void> generateServices() async {
    if (state.isLoading) {
      return;
    }
    emit(state.copyWith(status: GenerateServiceStatus.loading));
    final result = await generateServiceUsecase(state.selectedDraft);
    result.fold(
      (failure) => emit(state.copyWith(
        status: GenerateServiceStatus.error,
        errorMessage: failure.message,
      )),
      (services) => emit(state.copyWith(
        status: GenerateServiceStatus.success,
        generatedServices: services,
      )),
    );
  }

  Future<void> addSelectedTemplate(ServiceTemplateEntity template) async {
    if (state.isLoading) {
      return;
    }
    emit(state.copyWith(
      selectedDraft: state.selectedDraft.copyWith(
        selectedServiceTemplate: [
          ...state.selectedDraft.selectedServiceTemplate,
          template,
        ],
      ),
    ));
  }

  Future<void> removeSelectedTemplate(ServiceTemplateEntity template) async {
    if (state.isLoading) {
      return;
    }
    emit(state.copyWith(
      selectedDraft: state.selectedDraft.copyWith(
        selectedServiceTemplate: state.selectedDraft.selectedServiceTemplate
            .where((element) => element.id != template.id)
            .toList(),
      ),
    ));
  }

  Future<void> clearSelectedTemplates() async {
    if (state.isLoading) {
      return;
    }
    emit(state.copyWith(
      selectedDraft: state.selectedDraft.copyWith(
        selectedServiceTemplate: [],
      ),
    ));
  }
}
