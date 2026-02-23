import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/forms_selector_container.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/add_service_cubit.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/enum_selector.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class ServiceRequestConfigTab extends StatelessWidget {
  const ServiceRequestConfigTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCard(
            child: EnumSelector(
                title: "Akses Persetujuan",
                isMultiSelect: false,
                values: ServiceRequestApprovalAccess.values,
                selectedValues: [
                  context.select((AddServiceCubit cubit) =>
                      cubit.state.serviceConfig.serviceRequestApprovalAccess)
                ],
                onChanged: (value) {
                  context
                      .read<AddServiceCubit>()
                      .updateServiceRequestApprovalAccess(value.firstOrNull ??
                          ServiceRequestApprovalAccess.manager);
                }),
          ),

          Text(
            "Formulir Pengajuan Layanan",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(
            height: 12,
          ),
          FormsSelectorContainer(
            selectedForms: [],
            onAdd: context.read<AddServiceCubit>().updateIntakeForm,
            buttonBuilder: (context, onPressed, isLoading) {
              final intakeForm = context.select(
                (AddServiceCubit cubit) => cubit.state.serviceConfig.intakeForm,
              );

              if (isLoading) {
                return const CircularProgressIndicator();
              }

              if (intakeForm != null) {
                return ClickableCustomCard(
                    onTap: onPressed,
                    child: Row(
                      children: [
                        IconBox(icon: Icons.assignment_turned_in_outlined),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Text(
                          intakeForm.title,
                          style: Theme.of(context).textTheme.titleSmall,
                        ))
                      ],
                    ));
              }

              return DashedButton(
                title: "Tambah Formulir",
                onTap: onPressed,
                borderColor: Theme.of(context).disabledColor,
                color: Theme.of(context).colorScheme.primary,
                icon: Icons.add,
                height: 120,
                borderRadius: 16,
                isLoading: isLoading,
              );
            },
          ),

          // if (context.select((AddServiceCubit cubit)))
          const SizedBox(
            height: 24,
          ),
          Text(
            "Formulir Review Layanan",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(
            height: 12,
          ),
           FormsSelectorContainer(
            selectedForms: [],
            onAdd: context.read<AddServiceCubit>().updateReviewForm,
            buttonBuilder: (context, onPressed, isLoading) {
              final reviewForm = context.select(
                (AddServiceCubit cubit) => cubit.state.serviceConfig.reviewForm,
              );

              if (isLoading) {
                return const CircularProgressIndicator();
              }

              if (reviewForm != null) {
                return ClickableCustomCard(
                    onTap: onPressed,
                    child: Row(
                      children: [
                        IconBox(icon: Icons.assignment_turned_in_outlined),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Text(
                          reviewForm.title,
                          style: Theme.of(context).textTheme.titleSmall,
                        ))
                      ],
                    ));
              }

              return DashedButton(
                title: "Tambah Formulir",
                onTap: onPressed,
                borderColor: Theme.of(context).disabledColor,
                color: Theme.of(context).colorScheme.primary,
                icon: Icons.add,
                height: 120,
                borderRadius: 16,
                isLoading: isLoading,
              );
            },
          ),
        ],
      ),
    );
  }
}
