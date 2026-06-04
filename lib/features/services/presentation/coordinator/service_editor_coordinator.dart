import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/condition_evaluator.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/services/domain/draft/service_draft.dart';

class ServiceEditorCoordinator extends ChangeNotifier {
  ServiceDraft _draft;

  ServiceEditorCoordinator(ServiceDraft initial) : _draft = initial;

  ServiceDraft get draft => _draft;

  bool get isManualDrafting => draft.isManualDrafting;

  void _update(ServiceDraft newDraft) {
    _draft = newDraft;
    notifyListeners();
  }

  // ========================
  // BASIC UPDATE
  // ========================

  void updateTitle(String value) {
    _update(_draft.copyWith(title: value));
  }

  void updateReviewNeed(bool value) {
    _update(_draft.copyWith(reviewNeed: value));
  }

  void updateDescription(String value) {
    _update(_draft.copyWith(description: value));
  }

  void updateIsActive(bool value) {
    _update(_draft.copyWith(isActive: value));
  }

  void updateAccessType(ServiceAccessType value) {
    _update(_draft.copyWith(accessType: value));
  }

  void updateRequestApprovalAccess(ServiceRequestApprovalAccess value) {
    _update(_draft.copyWith(requestApprovalAccess: value));
  }

  void updateIntakeForm(FormEntity? form) {
    _update(_draft.copyWith(intakeForm: form));
  }

  void updateReviewForm(FormEntity? form) {
    _update(_draft.copyWith(reviewForm: form));
  }

  void updateDraftingType(WorkOrderDraftingType value) {
    _update(_draft.updateDraftingType(value));
  }

  // ========================
  // WORK ORDER
  // ========================

  void addWorkOrder(FormEntity? form, PositionEntity? position) {
    if (position == null) {
      _addWorkOrderGeneral(form);
    } else {
      _addWorkOrderWithPosition(form, position);
    }
  }

  void _addWorkOrderGeneral(FormEntity? form) {
    if (_draft.isManualDrafting) {
      if (form == null) {
        return;
      }
      _update(_draft.addManualWorkOrder(form));
    } else if (_draft.isAutoDrafting) {
      _update(_draft.addAutoWorkOrder());
    }
  }

  void _addWorkOrderWithPosition(FormEntity? form, PositionEntity position) {
    if (_draft.isManualDrafting) {
      if (form == null) {
        return;
      }
      _update(_draft.addManualWorkOrderWithPosition(form, position));
    } else if (_draft.isAutoDrafting) {
      _update(_draft.addAutoWorkOrderWithPosition(position));
    }
  }

  void updateWorkOrderForm(int index, FormEntity form) {
    _update(_draft.updateWorkOrderForm(index, form));
  }

  void updateShowReportToRequester(int index, bool value) {
    _update(_draft.updateShowReportToRequester(index, value));
  }

  void removeWorkOrder(int index) {
    _update(_draft.removeWorkOrder(index));
  }

  void updateDepartment(int index, dynamic position) {
    _update(_draft.updateDepartment(index, position));
  }

  void updateMinStaff(int index, int? value) {
    _update(_draft.updateMinStaff(index, value));
  }

  void updateMaxStaff(int index, int? value) {
    _update(_draft.updateMaxStaff(index, value));
  }

  void updateApproval(int index, dynamic value) {
    _update(_draft.updateApproval(index, value));
  }

  void updateWorkReportApproval(int index, dynamic value) {
    final current = _draft.workOrders[index];
    _update(
      _draft.updateWorkOrder(
        index,
        current.copyWith(workReportApprovalAccess: value),
      ),
    );
  }

  void updateReportForm(int index, dynamic form) {
    final current = _draft.workOrders[index];
    _update(
      _draft.updateWorkOrder(
        index,
        current.copyWith(reportForm: form),
      ),
    );
  }

  // ========================
  // STEP VALIDATION
  // ========================

  bool canGoNext(int step) {
    switch (step) {
      case 0:
        return _validateConfig();
      case 1:
        return _validateRequest();
      case 2:
        return _validateWorkOrder();
      case 3:
        return _validateReport();
      default:
        return true;
    }
  }

  bool _validateConfig() {
    return _draft.title.trim().isNotEmpty;
  }

  bool _validateRequest() {
    return allOf([
      () => _draft.intakeForm != null,
      () => _draft.reviewForm != null,
    ]);
  }

  bool _validateWorkOrder() {
    return allOf([
      () => _draft.hasAtLeastOneWorkOrder,
      () => _draft.allWorkOrderHasDepartment,
      () => _draft.allWorkOrderHasValidStaff,
      () => _draft.allWorkOrderHasValidForm,
    ]);
  }

  bool _validateReport() {
    return true;
  }

  // ========================
  // FINAL BUILD
  // ========================

  bool isDirty(ServiceDraft? initalData) {
    if (initalData == null) {
      return _draft != ServiceDraft.initial();
    } else {
      return _draft != initalData;
    }
  }
}
