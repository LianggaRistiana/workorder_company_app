import 'package:workorder_company_app/shared/utils/string_case_utils.dart';

enum PeriodType {
  currentDay,
  currentWeek,
  currentMonth,
  currentYear,
}

extension PeriodTypeExtension on PeriodType {
  String get displayName {
    return switch (this) {
      PeriodType.currentDay => 'Hari ini',
      PeriodType.currentWeek => 'Minggu ini',
      PeriodType.currentMonth => 'Bulan ini',
      PeriodType.currentYear => 'Tahun ini',
    };
  }

  String get toJsonString => name.toSnakeCase();
}
