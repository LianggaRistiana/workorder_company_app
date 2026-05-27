import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums/service_enum.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/service_price/domain/entities/service_price_entity.dart';
import 'package:workorder_company_app/features/service_price/presentation/bloc/service_price_cubit.dart';
import 'package:workorder_company_app/features/service_price/presentation/bloc/service_price_state.dart';
import 'package:workorder_company_app/features/service_price/presentation/helper/service_price_editor_dialog.dart';
import 'package:workorder_company_app/features/service_price/presentation/widgets/service_price_tag.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/app_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class ServicePriceListPage extends StatelessWidget {
  const ServicePriceListPage({super.key});

  void _showAction(BuildContext context, {required ServicePriceEntity item}) {
    showAppBottomSheet(
      context,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconBox.small(
                    isDisabled: !item.service.isActive, icon: AppIcon.service),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(
                  item.service.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ))
              ],
            ),
            const SizedBox(height: 12),
            ServicePriceTag(price: item.price),
            const Divider(
              thickness: 0.4,
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  context.pop();
                  context.push(
                    AppRoutes.servicesDetail.fillId(item.service.id),
                  );
                },
                icon: const Icon(Icons.info_outline),
                label: const Text('Lihat detail layanan'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {
                  context.pop();
                  context.read<ServicePriceCubit>().deleteServicePrice(item.id);
                },
                icon: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                label: Text(
                  'Hapus',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => sl<ServicePriceCubit>()..getServicePrices(),
        child: BlocConsumer<ServicePriceCubit, ServicePriceState>(
            listener: (context, state) {
          if (state.isActionSuccess &&
              state.status == ServicePriceStatus.success) {
            context.showSuccess("Berhasil melakukan aksi");
          } else if (state.actionErrorMessage != null) {
            context.showError(state.actionErrorMessage ?? "Terjadi kesalahan");
          } else if (state.errorMessage != null) {
            context.showError(state.errorMessage ?? "Terjadi kesalahan");
          }
        }, builder: (context, state) {
          final isLoading =
              state.status == ServicePriceStatus.loading || state.isAction;
          final items = state.servicePrices;

          return ListPageScaffold(
            title: "Harga Layanan",
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final result = await context.push<ServiceSummaryEntity>(
                    AppRoutes.services,
                    extra: ServiceListNextAction.selectService);

                if (!context.mounted) return;
                if (result != null) {
                  servicePriceEditorDialog(context, result, null,
                      (price, service) {
                    context
                        .read<ServicePriceCubit>()
                        .addServicePrice(service, price);
                  });
                }
              },
              child: const Icon(Icons.add),
            ),
            isLoading: isLoading,
            items: items,
            onRefresh: () async =>
                unawaited(context.read<ServicePriceCubit>().getServicePrices()),
            itemBuilder: (item) {
              final service = item.service;

              return ClickableCustomCard(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                onLongPress: () => _showAction(
                  context,
                  item: item,
                ),
                onTap: () {
                  servicePriceEditorDialog(context, service, item.price,
                      (price, service) {
                    context
                        .read<ServicePriceCubit>()
                        .updateServicePrice(item.id, service, price);
                  });
                },
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconBox.small(
                            isDisabled: !service.isActive,
                            icon: AppIcon.service),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Text(
                          service.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ))
                      ],
                    ),
                    const SizedBox(height: 8),
                    ServicePriceTag(price: item.price)
                  ],
                ),
              );
            },
          );
        }));
  }
}
