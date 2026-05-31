import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/dashboard/presentation/bloc/service_request_stat/service_request_stats_cubit.dart';
import 'package:workorder_company_app/features/dashboard/presentation/bloc/service_request_stat/service_request_stats_state.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/format_value.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/shimmer_placeholder.dart';
import 'package:workorder_company_app/shared/widgets/smart_shimmer.dart';

class ServiceRequestHomeChart extends StatelessWidget {
  const ServiceRequestHomeChart({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<ServiceRequestStatsCubit, ServiceRequestStatsState>(
        builder: (context, state) {
      final stats = state.stats;
      final isLoading = state.status == ServiceRequestStatsStatus.loading;

      if (isLoading) {
        return SmartShimmer(
          key: const ValueKey('loading'),
          placeholders: [
            ShimmerPlaceholder(
                height: 120, width: double.infinity, borderRadius: 24),
          ],
        );
      }

      return ClickableCustomCard(
          padding: const EdgeInsets.all(8),
          onTap: () => context.push(AppRoutes.dashboard),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconBox(icon: AppIcon.dashboard),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Permintaan Layanan ${state.periodType.displayName}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleSmall),
                      const SizedBox(height: 4),
                      Text(
                        formatValue(stats?.totalCount ?? 0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]));
    });
  }
}
