import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/company_type_entity.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/company_type_list/company_type_list_cubit.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/company_type_list/company_type_list_state.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class CompanyTypesPage extends StatelessWidget {
  const CompanyTypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CompanyTypeListCubit>()..fetchCompanyTypes(),
      child: BlocConsumer<CompanyTypeListCubit, CompanyTypeListState>(
          listener: (context, state) {
        if (state.status == CompanyTypeListStatus.error) {
          context.showError(
              state.errorMessage ?? 'Terjadi kesalahan saat memuat data');
        }
      }, builder: (context, state) {
        return ListPageScaffold<CompanyTypeEntity>(
            title: "Pilih tipe perusahaan anda",
            isLoading: state.isLoading,
            items: state.companyTypes ?? [],
            onRefresh: () async => unawaited(
                context.read<CompanyTypeListCubit>().fetchCompanyTypes()),
            itemBuilder: (item) => ClickableCustomCard(
                  margin: EdgeInsets.only(
                    left: AppSpacing.md,
                    right: AppSpacing.md,
                    bottom: AppSpacing.sm,
                  ),
                  key: Key(item.id),
                  onTap: () {
                    context.push(Endpoints.serviceTemplates.fillId(item.id));
                  },
                  child: Row(children: [
                    IconBox(icon: AppIcon.company),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                        child: Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ))
                  ]),
                ));
      }),
    );
  }
}
