import 'package:workorder_company_app/core/constants/app_enums.dart';

class DashboardParams {
  final PeriodType periodType;

  const DashboardParams({
    required this.periodType,
  });

  factory DashboardParams.initial() {
    return const DashboardParams(periodType: PeriodType.currentDay);
  }
}
