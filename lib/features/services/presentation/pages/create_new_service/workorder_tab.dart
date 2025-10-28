part of 'create_new_service_page.dart';

// ignore_for_file: invalid_use_of_protected_member
extension WorkorderTab on CreateServicePageState {
  Widget _buildWorkOrdertab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          FormsSelectorWithList<ServiceFormEntity>(
            // selectedServiceForms: selectedWorkOrderForms,
            createEntity: (form, order) => ServiceFormEntity(
              order: order,
              fillableByRoles: [UserRole.managerCompany],
              fillableByPositions: [],
              viewableByRoles: [UserRole.managerCompany],
              viewableByPositions: [],
              form: form,
            ),
            selectedForms: selectedWorkOrderForms,
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
            itemBuilder: (serviceForm) => ServiceFormEditorCard(
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
}
