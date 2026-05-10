import 'package:flutter/widgets.dart';

class DonutDataEntity {
  final double value;
  final String label;
  final Color color;

  DonutDataEntity({
    required this.value,
    required this.label,
    required this.color,
  });

  DonutDataEntity copyWith({
    double? value,
    String? label,
    Color? color,
  }) {
    return DonutDataEntity(
      value: value ?? this.value,
      label: label ?? this.label,
      color: color ?? this.color,
    );
  }
}
