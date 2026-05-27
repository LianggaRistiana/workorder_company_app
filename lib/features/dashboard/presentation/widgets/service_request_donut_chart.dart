import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/dashboard/domain/entitties/donut_data_entity.dart';
import 'package:workorder_company_app/features/dashboard/presentation/bloc/service_request_stat/service_request_stats_cubit.dart';
import 'package:workorder_company_app/features/dashboard/presentation/bloc/service_request_stat/service_request_stats_state.dart';
import 'package:workorder_company_app/features/dashboard/presentation/widgets/multi_donut_chart.dart';
import 'package:workorder_company_app/features/dashboard/presentation/widgets/toggleable_legend.dart';
import 'package:workorder_company_app/features/service_request/presentation/ui_mappers.dart/service_request_status_color_mapper.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/shimmer_placeholder.dart';
import 'package:workorder_company_app/shared/widgets/smart_shimmer.dart';

class ServiceRequestDonutChart extends StatefulWidget {
  const ServiceRequestDonutChart({super.key});

  @override
  State<ServiceRequestDonutChart> createState() =>
      _ServiceRequestDonutChartState();
}

class _ServiceRequestDonutChartState extends State<ServiceRequestDonutChart> {
  List<DonutDataEntity> data = [];

  @override
  void initState() {
    super.initState();
    sl<ServiceRequestStatsCubit>().fetch();
  }

  void _onPeriodChanged(
    PeriodType? periodType,
  ) {
    if (periodType == null) return;
    setState(() {
      sl<ServiceRequestStatsCubit>().fetch(periodType: periodType);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<ServiceRequestStatsCubit, ServiceRequestStatsState>(
        builder: (context, state) {
      final stats = state.stats;
      final isLoading = state.status == ServiceRequestStatsStatus.loading;

      if (stats != null) {
        data = [
          ...ServiceRequestStatus.values.map(
            (e) {
              return DonutDataEntity(
                  label: e.displayName,
                  value: stats.countByStatus(e),
                  color: e.color);
            },
          )
        ];
      } else {
        data = [
          ...ServiceRequestStatus.values.map(
            (e) {
              return DonutDataEntity(
                  label: e.displayName, value: 0, color: e.color);
            },
          )
        ];
      }

      return CustomCard(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconBox.small(icon: AppIcon.serviceRequestInbox),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Permintaan Layanan",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<PeriodType>(
                  value: state.periodType,
                  borderRadius: BorderRadius.circular(12),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: PeriodType.values.map((period) {
                    return DropdownMenuItem(
                      value: period,
                      child: Text(period.displayName,
                          style: Theme.of(context).textTheme.titleSmall),
                    );
                  }).toList(),
                  onChanged: _onPeriodChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (stats != null && !isLoading) ...[
            MultiDonutChart(
              data: data,
            ),
          ] else if (isLoading) ...[
            SmartShimmer(
              key: const ValueKey('loading'),
              placeholders: [
                ShimmerPlaceholder(
                    height: 220, width: double.infinity, borderRadius: 24),
              ],
            )
          ] else ...[
            const SizedBox(height: AppSpacing.md),
            InformationBlock.error("Terjadi Kesalahan Saat Mengambil Data")
          ],
          ToggleableLegend(data: data)
        ],
      ));
    });
  }
}
