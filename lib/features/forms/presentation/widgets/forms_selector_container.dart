import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_enums/form_enum.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/list/forms_list_bloc.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/forms_selector.dart';

class FormsSelectorContainer extends StatelessWidget {
  const FormsSelectorContainer({
    super.key,
    required this.selectedForms,
    required this.onAdd,
    required this.buttonBuilder,
    this.formTypeScoped,
  });

  final List<FormEntity> selectedForms;
  final FormType? formTypeScoped;
  // TODO [FUTURE IMPROVEMENT]: add form params type here
  final void Function(FormEntity) onAdd;

  final Widget Function(
    BuildContext context,
    VoidCallback onPressed,
    bool isLoading,
  ) buttonBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormsListBloc, FormsListState>(
      builder: (context, state) {
        final isLoading = state.status == FormsListStatus.loading;
        final availableForms = state.forms;

        final validFormList = formTypeScoped != null
            ? availableForms
                .where((form) => form.formType == formTypeScoped)
                .toList()
            : availableForms;

        return FormsSelector(
          selectedForms: selectedForms,
          availableForms: validFormList,
          isLoading: isLoading,
          onAdd: onAdd,
          buttonBuilder: buttonBuilder,
        );
      },
    );
  }
}
