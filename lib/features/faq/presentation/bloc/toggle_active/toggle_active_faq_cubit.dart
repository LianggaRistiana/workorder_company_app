import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';
import 'package:workorder_company_app/features/faq/domain/usecases/toggle_active_faq_usecase.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/toggle_active/toggle_active_faq_state.dart';

class ToggleActiveFaqCubit extends Cubit<ToggleActiveFaqState> {
  final ToggleActiveFaqUsecase toggleActiveFaqUsecase;

  ToggleActiveFaqCubit(this.toggleActiveFaqUsecase)
      : super(const ToggleActiveFaqState());

  bool _isProcessing = false;
  Future<void> toggleFaq() async {
    if (_isProcessing) return;
    appLogger.i("isProcessing : $_isProcessing");

    _isProcessing = true;

    final previousState = state;
    final newValue = !state.isActive;

    emit(ToggleActiveFaqState(isActive: newValue));

    final result = await toggleActiveFaqUsecase(newValue);

    result.fold(
      (failure) => emit(ToggleActiveFaqState(
        isActive: previousState.isActive,
        errorMessage: failure.message,
      )),
      (company) {
        appLogger.i(company);
        emit(ToggleActiveFaqState(
          isActive: newValue,
          updatedCompany: company,
        ));
      },
    );

    _isProcessing = false;
  }

  void initActiveStatus({
    required bool isActive,
  }) {
    emit(ToggleActiveFaqState(isActive: isActive));
  }
}
