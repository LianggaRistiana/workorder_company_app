part of 'create_new_service_page.dart';

// ignore_for_file: invalid_use_of_protected_member

extension ReportTab on CreateServicePageState {
  Widget _buildReportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // 🔹 Selector untuk Report
          FormsSelectorWithList<ServiceFormEntity>(
            // selectedServiceForms: selectedReportForms,
            selectedForms: selectedReportForms,
            createEntity: (form, order) => ServiceFormEntity(
              order: order,
              fillableByRoles: [UserRole.managerCompany],
              fillableByPositions: [],
              viewableByRoles: [UserRole.managerCompany],
              viewableByPositions: [],
              form: form,
            ),
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
            itemBuilder: (serviceForm) => ServiceFormEditorCard(
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
}