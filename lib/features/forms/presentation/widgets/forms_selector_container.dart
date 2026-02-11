import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/forms_bloc.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/forms_selector.dart';

class FormsSelectorContainer extends StatelessWidget {
  const FormsSelectorContainer({
    super.key,
    required this.selectedForms,
    required this.onAdd,
    required this.buttonBuilder,
  });

  final List<FormEntity> selectedForms;
  final void Function(FormEntity) onAdd;

  final Widget Function(
    BuildContext context,
    VoidCallback onPressed,
    bool isLoading,
  ) buttonBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormsBloc, FormsState>(
      builder: (context, state) {
        final isLoading = state is FormsLoading;
        final availableForms =
            state is FormsLoaded ? state.forms : <FormEntity>[];

        return FormsSelector(
          selectedForms: selectedForms,
          availableForms: availableForms,
          isLoading: isLoading,
          onAdd: onAdd,
          buttonBuilder: buttonBuilder,
        );
      },
    );
  }
}
