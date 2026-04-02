import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_company_services.dart/public_company_services_cubit.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_company_services.dart/public_company_services_state.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/error_body.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

class PublicServices extends StatelessWidget {
  const PublicServices({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PublicCompanyServicesCubit, PublicCompanyServicesState>(
      listener: (context, state) {
        if (state.status == PublicCompanyServicesStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi kesalahan");
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case PublicCompanyServicesStatus.initial:
            return const SizedBox.shrink();
          case PublicCompanyServicesStatus.loading:
            return Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xl),
              child: const Center(
                  child: AppLoading(
                message: "Memuat daftar layanan",
              )),
            );
          case PublicCompanyServicesStatus.error:
            return ErrorBody(
              errorMessage: state.errorMessage ?? "Terjadi kesalahan",
            );
          case PublicCompanyServicesStatus.loaded:
            final items = state.services;
            return CustomList(
              items: items,
              emptyWidget: InformationBlock.empty(
                  "Perusahaan belum memiliki layanan yang tersedia"),
              itemBuilder: (item, index) {
                return PublicServicesItem(
                  service: item,
                );
              },
            );
        }
      },
    );
  }
}

class PublicServicesItem extends StatelessWidget {
  final ServiceSummaryEntity service;

  const PublicServicesItem({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return ClickableCustomCard(
        onTap: () {},
        child: Row(children: [
          IconBox(icon: AppIcon.service),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                service.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ))
        ]));
  }
}
