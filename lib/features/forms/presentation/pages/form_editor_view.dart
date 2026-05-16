import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/forms/domain/draft/form_draft.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/presentation/controller/form_config_controller.dart';
import 'package:workorder_company_app/features/forms/presentation/coordinator/form_editor_coordinator.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/field_type_buttom_sheet_content.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/fields_editor_tab_view.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/form_config_editor_tab_view.dart';
import 'package:workorder_company_app/shared/utils/confirm_dialog.dart';
import 'package:workorder_company_app/shared/utils/confirm_leave.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/custom_step_indicator.dart';
import 'package:workorder_company_app/shared/widgets/app_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/step_navigation_bar.dart';

class FormEditorView extends StatefulWidget {
  final bool isLoading;
  final FormEntity? initialEntity;
  final Future<void> Function(FormDraft draft) onSubmit;

  const FormEditorView.create({
    super.key,
    required this.isLoading,
    required this.onSubmit,
    this.initialEntity,
  });

  const FormEditorView.update({
    super.key,
    required this.isLoading,
    required this.onSubmit,
    required this.initialEntity,
  });

  @override
  State<FormEditorView> createState() => _FormEditorViewState();
}

class _FormEditorViewState extends State<FormEditorView>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final FormEditorCoordinator _coordinator;
  late final FormConfigController _controllers;

  final _formKey = GlobalKey<FormState>();
  final _fieldsKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final draft = widget.initialEntity != null
        ? FormDraft.fromEntity(widget.initialEntity!)
        : FormDraft.empty();

    _coordinator = FormEditorCoordinator(draft);

    _coordinator.addListener(() {
      setState(() {});
    });

    _controllers = FormConfigController(
      title: TextEditingController(text: draft.title),
      description: TextEditingController(text: draft.description),
    );

    _controllers.title.addListener(() {
      _coordinator.updateTitle(
        _controllers.title.text,
      );
    });

    _controllers.description.addListener(() {
      _coordinator.updateDescription(
        _controllers.description.text,
      );
    });

    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _formKey.currentState?.dispose();
    _fieldsKey.currentState?.dispose();
    _controllers.dispose();
    super.dispose();
  }

  void _openFieldTypePicker() {
    showAppBottomSheet(
      context,
      content: FieldTypeBottomSheetContent(
        onSelected: (type) {
          _coordinator.addField(type);
        },
      ),
    );
  }

  void _onNext() {
    FocusScope.of(context).unfocus();
    final currentIndex = _tabController.index;
    bool isValid = false;

    switch (currentIndex) {
      case 0:
        isValid = _formKey.currentState?.validate() ?? false;
        break;
      case 1:
    }

    if (isValid && currentIndex < _tabController.length - 1) {
      _tabController.animateTo(currentIndex + 1);
    }
  }

  void _onPrevious() {
    FocusScope.of(context).unfocus();
    if (_tabController.index > 0) {
      _tabController.animateTo(_tabController.index - 1);
    }
  }

  void _submitForm() {
    _coordinator.updateTitle(_controllers.title.text);
    _coordinator.updateDescription(_controllers.description.text);

    FocusScope.of(context).unfocus();
    if (!_coordinator.isDirty) {
      context.showWarning("Anda belum melakukan perubahan");
      return;
    }

    if (!_coordinator.hasField()) {
      context.showError("Pertanyaan tidak boleh kosong");
      return;
    }

    if (!(_fieldsKey.currentState?.validate() ?? false)) {
      return;
    }

    widget.onSubmit(_coordinator.draft);
  }

  // HACK : Redundant Tab Controllers
  // The Scaffold is wrapped in a DefaultTabController(length: 4),
  // but the TabBarView explicitly receives controller: _tabController.
  // Impact: DefaultTabController is entirely unused and redundant.
  // It adds unnecessary widget nesting.
  // Fix: Remove the DefaultTabController wrapper entirely and just return the Scaffold.
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.initialEntity == null ? "Buat Formulir" : "Update Formulir",
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(72),
            child: SizedBox(
              width: double.infinity,
              child: CustomStepIndicator(
                currentStep: _tabController.index,
                steps: const [
                  'Konfigurasi',
                  'Pertanyaan',
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: StepNavigationBar(
          isLoading: widget.isLoading,
          currentStep: _tabController.index,
          totalSteps: 2,
          onPrevious: _onPrevious,
          onNext: _onNext,
          finalAction: FilledButton.icon(
            onPressed: widget.isLoading ? null : _submitForm,
            icon: const Icon(AppIcon.submit),
            label: Text(
              widget.isLoading ? "Loading..." : "Simpan",
            ),
          ),
        ),
        body: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            BackNavigationHandler.handle(
              context: context,
              isDirty: _coordinator.isDirty,
              onConfirmLeave: () {
                return showConfirmDialog(
                  context: context,
                  title: "Data belum disimpan",
                  message:
                      "Apakah Anda yakin ingin meninggalkan halaman ini tanpa menyimpan perubahan?",
                  type: ConfirmDialogType.warning,
                );
              },
            );
          },
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              FormConfigEditorTabView(
                titleController: _controllers.title,
                descController: _controllers.description,
                formType: _coordinator.draft.formType,
                formKey: _formKey,
                onFormTypeChanged: (type) {
                  _coordinator.updateFormType(type);
                },
              ),
              Form(
                key: _fieldsKey,
                child: FieldsEditorTabView(
                    coordinator: _coordinator,
                    onAddField: _openFieldTypePicker),
              )
            ],
          ),
        ),
      ),
    );
  }
}
