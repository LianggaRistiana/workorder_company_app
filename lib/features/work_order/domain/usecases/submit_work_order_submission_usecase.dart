import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/use_case_exceutor.dart';
import 'package:workorder_company_app/features/submissions/domain/draft/submisson_draft.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/submission_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/repositories/work_order_repository.dart';

class SubmitWorkOrderSubmissionUseCase {
  final WorkOrderRepository _repository;

  SubmitWorkOrderSubmissionUseCase(this._repository);

  FutureEitherWithMeta<WorkOrderEntity> call(
    WorkOrderEntity workOrder,
    SubmissionDraft submission,
  ) {
    return UseCaseExecutor.run<SubmissionEntity, Result<WorkOrderEntity>>(
      map: () => submission.toEntity(),
      authorize: null,
      action: (submission) => _repository.submitWorkOrderSubmission(
        workOrder.id,
        submission,
      ),
    );
  }
}
