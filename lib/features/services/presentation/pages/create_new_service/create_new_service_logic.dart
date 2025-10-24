part of 'create_new_service_page.dart';

extension CreateNewServiceLogic on CreateServicePageState {
  void _onNext(BuildContext context) {
    final currentIndex = _tabController.index;
    bool isValid = false;

    switch (currentIndex) {
      case 0:
        final formValid = _serviceKey.currentState?.validate() ?? false;

        if (requiredStaff.isEmpty || !_validateRequiredStaff()) {
          isValid = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Posisi Belum diisi')),
          );
        } else {
          isValid = formValid;
        }
        break;
      case 1:
        if (selectedWorkOrderForms.isNotEmpty) {
          isValid = true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Form Workorder Belum diisi')),
          );
        }
        break;
    }

    if (isValid && currentIndex < _tabController.length - 1) {
      _tabController.animateTo(currentIndex + 1);
    }
  }

  void _onPrevious() {
    if (_tabController.index > 0) {
      _tabController.animateTo(_tabController.index - 1);
    }
  }

  bool _validateRequiredStaff() {
    for (final staff in requiredStaff) {
      if (staff.minimumStaff > staff.maximumStaff) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Minimum staff can\'t be greater than maximum for ${staff.position.name}'),
          ),
        );
        return false;
      }
    }
    return true;
  }

  void _onSubmit() {
    if (selectedReportForms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form Laporan Belum diisi')),
      );
      return;
    }

    final service = ServiceEntity(
      id: '',
      title: _titleController.text,
      description: _descController.text,
      requiredStaff: requiredStaff,
      clientIntakeForms : selectedIntakeForms,
      workOrderForms: selectedWorkOrderForms,
      reportForms: selectedReportForms,
      accessType: accessType,
      isActive: isActive,
    );

    _servicesBloc.add(CreateServiceRequested(service));
  }
}
