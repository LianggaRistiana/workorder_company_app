import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/service_template_entity.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/generate_service/generate_service_cubit.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/service_template_list/service_template_list_cubit.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/service_template_list/service_template_list_state.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class ServiceTemplatesPage extends StatelessWidget {
  final String companyTypeId;

  const ServiceTemplatesPage({super.key, required this.companyTypeId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ServiceTemplateListCubit>()
            ..fetchServiceTemplates(
              companyTypeId,
            ),
        ),
        BlocProvider(create: (_) => sl<GenerateServiceCubit>()),
      ],
      child: BlocConsumer<ServiceTemplateListCubit, ServiceTemplateListState>(
          listener: (context, state) {
        if (state.status == ServiceTemplateListStatus.error) {
          context.showError(
              state.errorMessage ?? 'Terjadi kesalahan saat memuat data');
        }
      }, builder: (context, state) {
        final selectedList =
            context.watch<GenerateServiceCubit>().state.selectedDraft;

        return ListPageScaffold<ServiceTemplateEntity>(
            title: "Pilih layanan",
            header: Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.sm,
              ),
              child: InformationBlock.info(
                  "Klik dan tahan untuk melihat detail informasi"),
            ),
            isLoading: state.isLoading,
            items: state.serviceTemplates ?? [],
            onRefresh: () async => unawaited(
                context.read<ServiceTemplateListCubit>().fetchServiceTemplates(
                      companyTypeId,
                    )),
            itemBuilder: (item) {
              final isSelected =
                  selectedList.selectedServiceTemplate.contains(item);
              return ClickableCustomCard(
                borderColor:
                    isSelected ? Theme.of(context).colorScheme.primary : null,
                margin: EdgeInsets.only(
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                  bottom: AppSpacing.sm,
                ),
                key: Key(item.id),
                onTap: () {
                  isSelected
                      ? context
                          .read<GenerateServiceCubit>()
                          .removeSelectedTemplate(item)
                      : context
                          .read<GenerateServiceCubit>()
                          .addSelectedTemplate(item);
                },
                onLongPress: () {},
                child: Row(children: [
                  IconBox(
                    isDisabled: !isSelected,
                    icon: AppIcon.service,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ))
                ]),
              );
            });
      }),
    );
  }
}
