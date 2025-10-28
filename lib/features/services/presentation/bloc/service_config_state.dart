import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/domain/entities/ordered_form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/service_form_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/required_staff_entity.dart';

class ServiceConfigState extends Equatable {
  final ServiceConfig serviceConfig;
  final bool isConfigLoading;
  final String? errorMessage;
  final bool isSubmitted;

  const ServiceConfigState({
    required this.serviceConfig,
    this.isConfigLoading = false,
    this.errorMessage,
    this.isSubmitted = false,
  });

  ServiceConfigState copyWith({
    ServiceConfig? serviceConfig,
    bool? isConfigLoading,
    String? errorMessage,
    bool? isSubmitted,
  }) {
    return ServiceConfigState(
      serviceConfig: serviceConfig ?? this.serviceConfig,
      isConfigLoading: isConfigLoading ?? this.isConfigLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }

  @override
  List<Object?> get props => [serviceConfig, isConfigLoading, errorMessage];
}

class ServiceConfig extends Equatable {
  final String title;
  final String description;
  final List<RequiredStaffEntity> requiredStaff;
  final List<OrderedFormEntity> selectedIntakeForms;
  final List<ServiceFormEntity> selectedWorkOrderForms;
  final List<ServiceFormEntity> selectedReportForms;
  final ServiceAccessType accessType;
  final bool isActive;

  const ServiceConfig({
    this.title = '',
    this.description = '',
    this.requiredStaff = const [],
    this.selectedIntakeForms = const [],
    this.selectedWorkOrderForms = const [],
    this.selectedReportForms = const [],
    this.accessType = ServiceAccessType.internal,
    this.isActive = true,
  });

  ServiceConfig copyWith({
    String? title,
    String? description,
    List<RequiredStaffEntity>? requiredStaff,
    List<OrderedFormEntity>? selectedIntakeForms,
    List<ServiceFormEntity>? selectedWorkOrderForms,
    List<ServiceFormEntity>? selectedReportForms,
    ServiceAccessType? accessType,
    bool? isActive,
  }) {
    return ServiceConfig(
      title: title ?? this.title,
      description: description ?? this.description,
      requiredStaff: requiredStaff ?? this.requiredStaff,
      selectedIntakeForms: selectedIntakeForms ?? this.selectedIntakeForms,
      selectedWorkOrderForms: selectedWorkOrderForms ?? this.selectedWorkOrderForms,
      selectedReportForms: selectedReportForms ?? this.selectedReportForms,
      accessType: accessType ?? this.accessType,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
    title,
    description,
    requiredStaff,
    selectedIntakeForms,
    selectedWorkOrderForms,
    selectedReportForms,
    accessType,
    isActive,
  ];
}
