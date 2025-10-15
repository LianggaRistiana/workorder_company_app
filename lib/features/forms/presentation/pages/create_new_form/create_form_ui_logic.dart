part of 'create_new_form_page.dart';
// ignore_for_file: invalid_use_of_protected_member
extension CreateFormUiLogic on CreateNewFormPageState {
  void _addField() {
    setState(() {
      _fields.add(EditableField(order: _fields.length + 1));
    });
  }

  void _removeField(int index) {
    setState(() {
      _fields.removeAt(index);
      for (int i = 0; i < _fields.length; i++) {
        _fields[i].order = i + 1;
      }
    });
  }

  void _addOption(int fieldIndex) {
    setState(() {
      _fields[fieldIndex].options.add(
            OptionEntity(
              key: '${DateTime.now().millisecondsSinceEpoch}',
              value: '',
            ),
          );
    });
  }

  void _onNext(BuildContext context) {
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
    if (_tabController.index > 0) {
      _tabController.animateTo(_tabController.index - 1);
    }
  }

  void _removeOption(int fieldIndex, int optionIndex) {
    setState(() => _fields[fieldIndex].options.removeAt(optionIndex));
  }

  void _submitForm() {
    if (_fields.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi Pertanyaan')),
      );
      return;
    }

    if (!(_fieldKey.currentState?.validate() ?? false)) {
      return;
    }

    final form = FormEntity(
      id: '',
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      formType: _formType,
      fields: _fields.map((e) => e.toEntity()).toList(),
    );

    // Tambahkan aksi Bloc di sini
    _formsBloc.add(CreateFormRequested(form));
  }
}
