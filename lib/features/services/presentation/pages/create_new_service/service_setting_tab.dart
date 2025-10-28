part of 'create_new_service_page.dart';

// ignore_for_file: invalid_use_of_protected_member
extension ServiceSettingTab on CreateServicePageState {
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
            _buildIntakeServiceFormsSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildIntakeServiceFormsSelector() {
    return FormsSelectorWithList<OrderedFormEntity>(
      // selectedServiceForms: selectedWorkOrderForms,
      createEntity: (form, order) => OrderedFormEntity(
        order: order,
        form: form,
      ),
      selectedForms: selectedIntakeForms,
      onAdd: (formOrder) {
        setState(() => selectedIntakeForms.add(formOrder));
      },
      onRemove: (formOrder) {
        setState(() {
          selectedIntakeForms.removeWithCallback(
            formOrder,
            (item, i) {
              selectedIntakeForms[i] = item.copyWith(order: i + 1);
            },
          );
        });
      },
      onReorder: (oldIndex, newIndex) {
        setState(() {
          selectedIntakeForms.reorderWithCallback(
            oldIndex,
            newIndex,
            (item, i) {
              selectedIntakeForms[i] = item.copyWith(order: i + 1);
            },
          );
        });
      },
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
