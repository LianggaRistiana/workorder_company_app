import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/dashboard/domain/entitties/donut_data_entity.dart';
import 'package:workorder_company_app/features/dashboard/presentation/bloc/company_stat/company_stat_cubit.dart';
import 'package:workorder_company_app/features/dashboard/presentation/bloc/company_stat/company_stat_state.dart';
import 'package:workorder_company_app/features/dashboard/presentation/widgets/multi_level_donut_chart.dart';
import 'package:workorder_company_app/features/dashboard/presentation/widgets/toggleable_legend.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/shimmer_placeholder.dart';
import 'package:workorder_company_app/shared/widgets/smart_shimmer.dart';

class CompanyDonutChart extends StatefulWidget {
  const CompanyDonutChart({super.key});

  @override
  State<CompanyDonutChart> createState() => _CompanyDonutChartState();
}

class _CompanyDonutChartState extends State<CompanyDonutChart> {
  List<List<DonutDataEntity>> levels = [];
  List<DonutDataEntity> data = [];

  @override
  void initState() {
    super.initState();
    sl<CompanyStatCubit>().getCompanyStats();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final inActiveColor = theme.colorScheme.primaryContainer;

    return BlocBuilder<CompanyStatCubit, CompanyStatState>(
        builder: (context, state) {
      final stats = state.stats;
      final isLoading = state.status == CompanyStatStatus.loading;

      if (stats != null) {
        levels = [
          [
            DonutDataEntity(
              value: stats.employeesStat.managersCount.toDouble(),
              label: "Manager",
              color: Colors.purpleAccent,
            ),
            DonutDataEntity(
              value: stats.employeesStat.staffsCount.toDouble(),
              label: "Pegawai",
              color: inActiveColor,
            ),
          ],
          [
            DonutDataEntity(
              value: stats.employeesStat.staffsCount.toDouble(),
              label: "Pegawai",
              color: Colors.deepPurpleAccent,
            ),
            DonutDataEntity(
              value: stats.employeesStat.managersCount.toDouble(),
              label: "Manager",
              color: inActiveColor,
            ),
          ],
          [
            DonutDataEntity(
              value: stats.servicesStat.active.toDouble(),
              label: "Aktif",
              color: Colors.blueAccent.shade700,
            ),
            DonutDataEntity(
              value: stats.servicesStat.inActive.toDouble(),
              label: "Tidak Aktif",
              color: inActiveColor,
            ),
          ],
        ];
      } else {
        levels = [];
      }

      if (stats != null) {
        data = [
          DonutDataEntity(
            value: stats.employeesStat.managersCount.toDouble(),
            label: "Manager",
            color: Colors.purpleAccent,
          ),
          DonutDataEntity(
            value: stats.employeesStat.staffsCount.toDouble(),
            label: "Pegawai",
            color: Colors.deepPurpleAccent,
          ),
          DonutDataEntity(
            value: stats.servicesStat.active.toDouble(),
            label: "Layanan Aktif",
            color: Colors.blueAccent.shade700,
          ),
          DonutDataEntity(
            value: stats.formsStat.active.toDouble(),
            label: "Formulir",
            color: Colors.blueAccent.shade100,
          ),
        ];
      } else {
        data = [];
      }

      return CustomCard(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconBox.small(icon: AppIcon.company),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Statistik Perusahaan",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (stats != null && !isLoading) ...[
            MultiLevelDonutChart(
              levels: levels,
              animationValue: 1,
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
