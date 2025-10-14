part of 'create_new_service_page.dart';

// ignore_for_file: invalid_use_of_protected_member
extension CreateNewServiceWidgetBuilder on CreateServicePageState {
  Widget _buildServiceSettingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _serviceKey,
        child: Column(
          children: [
            // _buildServiceSetting(),
            ServiceSettingCard(
              titleController: _titleController,
              descController: _descController,
              accessType: accessType,
              isActive: isActive,
              onAccessTypeChanged: (type) {
                setState(() => accessType = type);
              },
              onStatusChanged: (status) {
                setState(() => isActive = status);
              },
            ),
            const SizedBox(height: 24),
            _buildPositionsRequiredSetting(),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkOrdertab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          FormsSelector(
            selectedFormsOrder: selectedWorkOrderForms,
            onAdd: (formOrder) {
              setState(() => selectedWorkOrderForms.add(formOrder));
            },
            // onRemove: (formOrder) {
            //   setState(() {
            //     selectedWorkOrderForms.remove(formOrder);
            //     for (var i = 0; i < selectedWorkOrderForms.length; i++) {
            //       selectedWorkOrderForms[i] =
            //           selectedWorkOrderForms[i].copyWith(order: i + 1);
            //     }
            //   });
            // },
            onRemove: (formOrder) {
              setState(() {
                selectedWorkOrderForms.removeWithCallback(
                  formOrder,
                  (item, i) {
                    selectedWorkOrderForms[i] = item.copyWith(order: i + 1);
                  },
                );
              });
            },

            // onReorder: (oldIndex, newIndex) {
            //   setState(() {
            //     if (newIndex > oldIndex) newIndex -= 1;
            //     final item = selectedWorkOrderForms.removeAt(oldIndex);
            //     selectedWorkOrderForms.insert(newIndex, item);
            //     for (var i = 0; i < selectedWorkOrderForms.length; i++) {
            //       selectedWorkOrderForms[i] =
            //           selectedWorkOrderForms[i].copyWith(order: i + 1);
            //     }
            //   });
            // },
            onReorder: (oldIndex, newIndex) {
              setState(() {
                selectedWorkOrderForms.reorderWithCallback(
                  oldIndex,
                  newIndex,
                  (item, i) {
                    selectedWorkOrderForms[i] = item.copyWith(order: i + 1);
                  },
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // 🔹 Selector untuk Report
          FormsSelector(
            selectedFormsOrder: selectedReportForms,
            onAdd: (formOrder) {
              setState(() => selectedReportForms.add(formOrder));
            },
            // onRemove: (formOrder) {
            //   setState(() {
            //     selectedReportForms.remove(formOrder);
            //     for (var i = 0; i < selectedReportForms.length; i++) {
            //       selectedReportForms[i] =
            //           selectedReportForms[i].copyWith(order: i + 1);
            //     }
            //   });
            // },
            onRemove: (formOrder) {
              setState(() {
                selectedReportForms.removeWithCallback(
                  formOrder,
                  (item, i) {
                    selectedReportForms[i] = item.copyWith(order: i + 1);
                  },
                );
              });
            },
            // onReorder: (oldIndex, newIndex) {
            //   setState(() {
            //     if (newIndex > oldIndex) newIndex -= 1;
            //     final item = selectedReportForms.removeAt(oldIndex);
            //     selectedReportForms.insert(newIndex, item);
            //     for (var i = 0; i < selectedReportForms.length; i++) {
            //       selectedReportForms[i] =
            //           selectedReportForms[i].copyWith(order: i + 1);
            //     }
            //   });
            // },
            onReorder: (oldIndex, newIndex) {
              setState(() {
                selectedReportForms.reorderWithCallback(
                  oldIndex,
                  newIndex,
                  (item, i) {
                    selectedReportForms[i] = item.copyWith(order: i + 1);
                  },
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPositionsRequiredSetting() {
    return RequiredPositionsSetting(
      requiredStaff: requiredStaff,
      onAdd: (pos) {
        setState(() {
          requiredStaff.add(RequiredStaffEntity(
            position: pos,
            minimumStaff: 1,
            maximumStaff: 1,
          ));
        });
      },
      onRemove: (pos) {
        setState(() {
          requiredStaff.removeWhere((s) => s.position.id == pos.id);
        });
      },
      onMinChange: (staff, newMin) {
        setState(() {
          final index = requiredStaff.indexOf(staff);
          requiredStaff[index] = staff.copyWith(minimumStaff: newMin);
        });
      },
      onMaxChange: (staff, newMax) {
        setState(() {
          final index = requiredStaff.indexOf(staff);
          requiredStaff[index] = staff.copyWith(maximumStaff: newMax);
        });
      },
    );
  }
}
