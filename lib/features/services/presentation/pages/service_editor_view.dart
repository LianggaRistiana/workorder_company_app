import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/services/domain/draft/service_draft.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/presentation/controller/service_config_controllers.dart';
import 'package:workorder_company_app/features/services/presentation/coordinator/service_editor_coordinator.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_config_form_tab_view.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_request_form_tab_view.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_work_order_form_tab_view.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_work_report_form_tab_view.dart';
import 'package:workorder_company_app/shared/utils/confirm_dialog.dart';
import 'package:workorder_company_app/shared/utils/confirm_leave.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/custom_step_indicator.dart';
import 'package:workorder_company_app/shared/widgets/step_navigation_bar.dart';

class ServiceEditorView extends StatefulWidget {
  final bool isLoading;
  final ServiceEntity? initialEntity; // ServiceEntity
  final Future<void> Function(ServiceDraft draft) onSubmit;

  const ServiceEditorView.create({
    super.key,
    required this.isLoading,
    required this.onSubmit,
    this.initialEntity,
  });

  const ServiceEditorView.update({
    super.key,
    required this.isLoading,
    required this.onSubmit,
    required this.initialEntity,
  });

  @override
  State<ServiceEditorView> createState() => _ServiceEditorViewState();
}

class _ServiceEditorViewState extends State<ServiceEditorView>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final ServiceEditorCoordinator _coordinator;
  late final ServiceConfigControllers _controllers;

  final _configFormKey = GlobalKey<FormState>();
  final _workOrderFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final draft = widget.initialEntity != null
        ? ServiceDraft.fromEntity(widget.initialEntity!)
        : ServiceDraft.initial();

    _coordinator = ServiceEditorCoordinator(draft);

    _coordinator.addListener(() {
      setState(() {});
    });

    _controllers = ServiceConfigControllers(
      title: TextEditingController(text: draft.title),
      description: TextEditingController(text: draft.description),
    );

    _tabController = TabController(length: 4, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  void _onNext() {
    FocusScope.of(context).unfocus();
    final current = _tabController.index;

    // FIXME[High] : fix this later, add onchange in title and description
    _coordinator.updateTitle(
      _controllers.title.text,
    );

    _coordinator.updateDescription(
      _controllers.description.text,
    );

    _configFormKey.currentState?.validate();
    _workOrderFormKey.currentState?.validate();

    if (_coordinator.canGoNext(current)) {
      if (current < 3) {
        _tabController.animateTo(current + 1);
      }
    } else {
      context.showWarning("Data belum lengkap");
    }
  }

  void _onPrevious() {
    FocusScope.of(context).unfocus();
    if (_tabController.index > 0) {
      _tabController.animateTo(_tabController.index - 1);
    }
  }

  Future<void> _onSubmit() async {
    FocusScope.of(context).unfocus();
    final finalDraft = _coordinator.buildFinal(
      title: _controllers.title.text,
      description: _controllers.description.text,
    );

    if (!_coordinator.isDirty(widget.initialEntity != null
        ? ServiceDraft.fromEntity(widget.initialEntity!)
        : null)) {
      context.showWarning("Anda belum melakukan perubahan");
      return;
    }

    await widget.onSubmit(finalDraft);
  }

  @override
  void dispose() {
    _coordinator.dispose();
    _tabController.dispose();
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = _coordinator.draft;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.initialEntity == null ? "Buat Layanan" : "Update Layanan",
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(72),
            child: SizedBox(
              width: double.infinity,
              child: CustomStepIndicator(
                currentStep: _tabController.index,
                steps: const [
                  'Konfigurasi',
                  'Permintaan',
                  'Perintah Kerja',
                  'Laporan'
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: StepNavigationBar(
          isLoading: widget.isLoading,
          currentStep: _tabController.index,
          totalSteps: 4,
          onPrevious: _onPrevious,
          onNext: _onNext,
          finalAction: FilledButton.icon(
            onPressed: widget.isLoading ? null : _onSubmit,
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
            final isDirty = _coordinator.isDirty(widget.initialEntity != null
                ? ServiceDraft.fromEntity(widget.initialEntity!)
                : null);
            BackNavigationHandler.handle(
              context: context,
              isDirty: isDirty,
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
              Form(
                key: _configFormKey,
                child: ServiceConfigFormTabView(
                  isUpdate: widget.initialEntity != null,
                  isActive: draft.isActive,
                  titleController: _controllers.title,
                  descriptionController: _controllers.description,
                  accessType: draft.accessType,
                  onActiveChanged: _coordinator.updateIsActive,
                  onAccessTypeChanged: _coordinator.updateAccessType,
                ),
              ),
              ServiceRequestFormTabView(
                approvalAccess: draft.requestApprovalAccess,
                intakeForm: draft.intakeForm,
                reviewForm: draft.reviewForm,
                reviewNeed: draft.reviewNeed,
                onApprovalAccessChanged:
                    _coordinator.updateRequestApprovalAccess,
                onIntakeFormChanged: _coordinator.updateIntakeForm,
                onReviewFormChanged: _coordinator.updateReviewForm,
                onReviewNeedChanged: _coordinator.updateReviewNeed,
              ),
              Form(
                key: _workOrderFormKey,
                child: ServiceWorkOrderFormTabView(
                  workOrders: draft.workOrders,
                  onAdd: _coordinator.addWorkOrder,
                  onRemove: _coordinator.removeWorkOrder,
                  onDepartmentUpdate: _coordinator.updateDepartment,
                  onMinChange: _coordinator.updateMinStaff,
                  onMaxChange: _coordinator.updateMaxStaff,
                  onApprovalChange: _coordinator.updateApproval,
                ),
              ),
              ServiceWorkReportFormTabView(
                workOrders: draft.workOrders,
                onApprovalChange: _coordinator.updateWorkReportApproval,
                onFormUpdate: _coordinator.updateReportForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
