import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_company_services.dart/public_company_services_cubit.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_company_services.dart/public_company_services_state.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/error_body.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/features/service_price/presentation/widgets/service_price_tag.dart';

class PublicServicesList extends StatelessWidget {
  const PublicServicesList({super.key});

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
    final price = service.price;

    return ClickableCustomCard(
        onTap: () {
          context.push(AppRoutes.serviceRequestCreate, extra: service);
        },
        child: Column(
          children: [
            Row(children: [
              Stack(
                children: [
                  IconBox(icon: AppIcon.service),
                  if (service.accessType == ServiceAccessType.memberOnly) ...[
                    const SizedBox(height: 8),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.center,
                            colors: [
                              Color(0xFFFFEB97),
                              Color.fromARGB(255, 150, 124, 10),
                            ],
                          ),
                        ),
                        child: Icon(
                          AppIcon.membership,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ]
                ],
              ),
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
                  if (service.description != null)
                    Text(
                      service.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ))
            ]),
            if (price != null) ...[
              const SizedBox(height: 8),
              ServicePriceTag(price: price)
            ]
          ],
        ));
  }
}
