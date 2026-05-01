import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/template_config/domain/usecases/get_service_preview_usecase.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/service_preview/service_preview_state.dart';

class ServicePreviewCubit extends Cubit<ServicePreviewState> {
  final GetServicePreviewUsecase getServicePreviewUsecase;

  ServicePreviewCubit({
    required this.getServicePreviewUsecase,
  }) : super(ServicePreviewState.initial());

  Future<void> fetchServicePreview(String serviceTemplateId) async {
    emit(state.copyWith(status: ServicePreviewStatus.loading));
    final result = await getServicePreviewUsecase(serviceTemplateId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ServicePreviewStatus.error,
        errorMessage: failure.message,
      )),
      (preview) => emit(state.copyWith(
        status: ServicePreviewStatus.success,
        servicePreview: preview,
      )),
    );
  }
}
