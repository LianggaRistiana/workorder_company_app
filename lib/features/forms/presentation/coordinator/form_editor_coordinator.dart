import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/domain/draft/form_draft.dart';
import 'package:workorder_company_app/features/forms/domain/draft/option_draft.dart';

class FormEditorCoordinator extends ChangeNotifier {
  final FormDraft _draft;

  // HACK : Bug potentially, isDirty will be true at first changed, user can by pass with change to the same value
  bool _isDirty = false;

  FormEditorCoordinator(FormDraft draft) : _draft = draft;

  FormDraft get draft => _draft;
  bool get isDirty => _isDirty;

  /// =========================
  /// Basic Info
  /// =========================

  void updateTitle(String value) {
    _draft.updateTitle(value);
    if (!_isDirty) _isDirty = true;
    notifyListeners();
  }

  void updateDescription(String value) {
    _draft.updateDescription(value);
    if (!_isDirty) _isDirty = true;
    notifyListeners();
  }

  void updateFormType(FormType value) {
    _draft.updateFormType(value);
    if (!_isDirty) _isDirty = true;
    notifyListeners();
  }

  /// =========================
  /// Field Management
  /// =========================

  void addField(FieldType type) {
    _draft.addField(type);
    if (!_isDirty) _isDirty = true;
    notifyListeners();
  }

  void removeField(int index) {
    _draft.removeField(index);
    if (!_isDirty) _isDirty = true;
    notifyListeners();
  }

  void moveField(int oldIndex, int newIndex) {
    _draft.moveField(oldIndex, newIndex);
    if (!_isDirty) _isDirty = true;
    notifyListeners();
  }

  void updateFieldLabel(int index, String label) {
    _draft.fields[index].updateLabel(label);
    if (!_isDirty) _isDirty = true;
    notifyListeners();
  }

  void updateFieldRequired(int index, bool required) {
    _draft.fields[index].updateRequired(required);
    if (!_isDirty) _isDirty = true;
    notifyListeners();
  }

  void updateFieldPlaceholder(int index, String placeholder) {
    _draft.fields[index].updateFieldPlaceholder(placeholder);
    if (!_isDirty) _isDirty = true;
    notifyListeners();
  }

  void updateFieldMin(int index, int min) {
    _draft.fields[index].updateMin(min);
    if (!_isDirty) _isDirty = true;
    notifyListeners();
  }

  void updateFieldMax(int index, int max) {
    _draft.fields[index].updateMax(max);
    if (!_isDirty) _isDirty = true;
    notifyListeners();
  }

  /// =========================
  /// Option Management
  /// =========================

  void addOption(int fieldIndex) {
    _draft.fields[fieldIndex].addOption(OptionDraft());
    if (!_isDirty) _isDirty = true;
    notifyListeners();
  }

  void removeOption(int fieldIndex, String optionKey) {
    _draft.fields[fieldIndex].removeOptionByKey(optionKey);
    if (!_isDirty) _isDirty = true;
    notifyListeners();
  }

  void updateOptionValue(
    int fieldIndex,
    String optionKey,
    String value,
  ) {
    _draft.fields[fieldIndex].updateOptionValue(optionKey, value);
    if (!_isDirty) _isDirty = true;
    notifyListeners();
  }

  /// =========================
  /// Validation
  /// =========================

  bool hasField() {
    return _draft.fields.isNotEmpty;
  }
}
