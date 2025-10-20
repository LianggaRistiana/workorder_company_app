class FieldDataEntity {
  final String order;
  final dynamic value;

  const FieldDataEntity({
    required this.order,
    required this.value,
  });

  FieldDataEntity copyWith({
    String? order,
    dynamic value,
  }) {
    return FieldDataEntity(
      order: order ?? this.order,
      value: value ?? this.value,
    );
  }
}
