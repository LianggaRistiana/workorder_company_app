import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/selected_service_template_draft.dart';

enum GenerateServiceStatus { initial, loading, success, error }

class GenerateServiceState extends Equatable {
  final GenerateServiceStatus status;
  final SelectedServiceTemplateDraft selectedDraft;
  final List<ServiceEntity>? generatedServices;
  final String? errorMessage;

  bool get isLoading => status == GenerateServiceStatus.loading;
  bool get isSuccess => status == GenerateServiceStatus.success;

  const GenerateServiceState({
    required this.status,
    required this.selectedDraft,
    this.generatedServices,
    this.errorMessage,
  });

  factory GenerateServiceState.initial() => const GenerateServiceState(
      selectedDraft: SelectedServiceTemplateDraft(selectedServiceTemplate: []),
      status: GenerateServiceStatus.initial);

  GenerateServiceState copyWith({
    GenerateServiceStatus? status,
    SelectedServiceTemplateDraft? selectedDraft,
    List<ServiceEntity>? generatedServices,
    String? errorMessage,
  }) {
    return GenerateServiceState(
      selectedDraft: selectedDraft ?? this.selectedDraft,
      status: status ?? this.status,
      generatedServices: generatedServices ?? this.generatedServices,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        selectedDraft,
        status,
        generatedServices,
        errorMessage,
      ];
}
