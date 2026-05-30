import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_enums/form_enum.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/list/forms_list_bloc.dart';
import 'package:workorder_company_app/shared/widgets/app_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/enum_selector.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class FormFilterButton extends StatelessWidget {
  const FormFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormsListBloc, FormsListState>(
      buildWhen: (previous, current) => previous.filter != current.filter,
      builder: (context, state) {
        final activeCount = state.filter.activeFilterCount;
        final isActive = activeCount > 0;

        return IconButton(
          onPressed: () {
            showAppBottomSheet(
              context,
              header: Container(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Row(
                  children: [
                    IconBox.small(icon: AppIcon.filter),
                    const SizedBox(width: 8),
                    Text(
                      "Filter Formulir",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              content: BlocProvider.value(
                value: context.read<FormsListBloc>(),
                child: BlocBuilder<FormsListBloc, FormsListState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EnumSelector<FormType>(
                            title: "Tipe Formulir",
                            values: FormType.values,
                            selectedValues: state.filter.types ?? [],
                            labelBuilder: (type) => type.displayName,
                            onChanged: (selected) {
                              context.read<FormsListBloc>().add(
                                    SetFormFilter(
                                      state.filter.copyWith(
                                        types: List.of(selected),
                                      ),
                                    ),
                                  );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
          icon: Badge(
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.onPrimary,
            isLabelVisible: activeCount > 0,
            label: Text(activeCount.toString()),
            child: Icon(
              AppIcon.filter,
              color: isActive ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        );
      },
    );
  }
}
