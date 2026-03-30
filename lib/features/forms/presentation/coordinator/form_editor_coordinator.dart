import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/domain/draft/form_draft.dart';
import 'package:workorder_company_app/features/forms/domain/draft/option_draft.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';

class FormEditorCoordinator extends ChangeNotifier {
  final FormDraft _draft;

  FormEditorCoordinator(FormDraft draft) : _draft = draft;

  FormDraft get draft => _draft;

  /// =========================
  /// Basic Info
  /// =========================

  void updateTitle(String value) {
    _draft.updateTitle(value);
    notifyListeners();
  }

  void updateDescription(String value) {
    _draft.updateDescription(value);
    notifyListeners();
  }

  void updateFormType(FormType value) {
    _draft.updateFormType(value);
    notifyListeners();
  }

  /// =========================
  /// Field Management
  /// =========================

  void addField(FieldType type) {
    _draft.addField(type);
    notifyListeners();
  }

  void removeField(int index) {
    _draft.removeField(index);
    notifyListeners();
  }

  void moveField(int oldIndex, int newIndex) {
    _draft.moveField(oldIndex, newIndex);
    notifyListeners();
  }

  void updateFieldLabel(int index, String label) {
    _draft.fields[index].updateLabel(label);
    notifyListeners();
  }

  void updateFieldRequired(int index, bool required) {
    _draft.fields[index].updateRequired(required);
    notifyListeners();
  }

  void updateFieldPlaceholder(int index, String placeholder) {
    _draft.fields[index].updateFieldPlaceholder(placeholder);
    notifyListeners();
  }

  void updateFieldMin(int index, int min) {
    _draft.fields[index].updateMin(min);
    notifyListeners();
  }

  void updateFieldMax(int index, int max) {
    _draft.fields[index].updateMax(max);
    notifyListeners();
  }

  /// =========================
  /// Option Management
  /// =========================

  void addOption(int fieldIndex) {
    _draft.fields[fieldIndex].addOption(OptionDraft());
    notifyListeners();
  }

  void removeOption(int fieldIndex, String optionKey) {
    _draft.fields[fieldIndex].removeOptionByKey(optionKey);
    notifyListeners();
  }

  void updateOptionValue(
    int fieldIndex,
    String optionKey,
    String value,
  ) {
    _draft.fields[fieldIndex].updateOptionValue(optionKey, value);
    notifyListeners();
  }

  /// =========================
  /// Validation
  /// =========================

  bool hasField() {
    return _draft.fields.isNotEmpty;
  }

  bool isDirty(ServiceEntity? entity) {
    if (entity == null) {
      return _draft.title.isNotEmpty ||
          _draft.description.isNotEmpty ||
          _draft.formType != FormType.workOrder ||
          _draft.fields.isNotEmpty;
    } else {
      // TODO : to draft and equatable it
      return true;
    }
  }
}
