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
            selectedServiceForms: selectedWorkOrderForms,
            onAdd: (formOrder) {
              setState(() => selectedWorkOrderForms.add(formOrder));
            },
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
            itemBuilder: (serviceForm) => ServiceFormCard(
              availablePositions: requiredStaff.map((s) => s.position).toList(),
              serviceForm: serviceForm,
              onUpdate: (updated) {
                final index = selectedWorkOrderForms
                    .indexWhere((f) => f.form.id == updated.form.id);
                if (index != -1) {
                  setState(() {
                    selectedWorkOrderForms[index] = updated;
                  });
                }
              },
              onRemove: (serviceForm) {
                setState(() {
                  selectedWorkOrderForms.removeWithCallback(
                    serviceForm,
                    (item, i) {
                      selectedWorkOrderForms[i] = item.copyWith(order: i + 1);
                    },
                  );
                });
              },
            ),
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
            selectedServiceForms: selectedReportForms,
            onAdd: (formOrder) {
              setState(() => selectedReportForms.add(formOrder));
            },
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
            itemBuilder: (serviceForm) => ServiceFormCard(
              availablePositions: requiredStaff.map((s) => s.position).toList(),
              serviceForm: serviceForm,
              onUpdate: (updated) {
                final index = selectedReportForms
                    .indexWhere((f) => f.form.id == updated.form.id);
                if (index != -1) {
                  setState(() {
                    selectedReportForms[index] = updated;
                  });
                }
              },
              onRemove: (serviceForm) {
                setState(() {
                  selectedReportForms.removeWithCallback(
                    serviceForm,
                    (item, i) {
                      selectedReportForms[i] = item.copyWith(order: i + 1);
                    },
                  );
                });
              },
            ),
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
