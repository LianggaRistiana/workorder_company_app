import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/feature/quick_config_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/role_permission_helper.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/service_template_entity.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/generate_service/generate_service_cubit.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/generate_service/generate_service_state.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/service_template_list/service_template_list_cubit.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/service_template_list/service_template_list_state.dart';
import 'package:workorder_company_app/features/template_config/presentation/listener/service_template_listener.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';
import 'package:workorder_company_app/shared/widgets/loading_state_inline.dart';

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
      child: ServiceTemplateListener(
        child: BlocBuilder<ServiceTemplateListCubit, ServiceTemplateListState>(
            builder: (context, state) {
          final selectedList =
              context.watch<GenerateServiceCubit>().state.selectedDraft;

          return ListPageScaffold<ServiceTemplateEntity>(
              title: "Pilih layanan",
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton:
                  BlocBuilder<GenerateServiceCubit, GenerateServiceState>(
                      builder: (context, state) {
                bool isLoading = state.isLoading;
                return AnimatedSwitcher(
                  duration: Duration(
                    milliseconds: 200,
                  ),
                  child: state.selectedDraft.selectedServiceTemplate.isNotEmpty
                      ? isLoading
                          ? LoadingStateInline()
                          : FloatingActionButton.extended(
                              icon: Icon(AppIcon.add),
                              label: Text("Buat Layanan"),
                              onPressed: () => context
                                  .read<GenerateServiceCubit>()
                                  .generateServices(),
                            )
                      : SizedBox.shrink(),
                );
              }).require(roleCan(
                QuickConfigPermission.create,
              )),
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
              onRefresh: () async => unawaited(context
                  .read<ServiceTemplateListCubit>()
                  .fetchServiceTemplates(
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
                  onLongPress: () {
                    context
                        .push(AppRoutes.templateServicePreview.fillId(item.id));
                  },
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
      ),
    );
  }
}
