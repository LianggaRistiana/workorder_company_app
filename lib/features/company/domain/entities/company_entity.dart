class CompanyEntity {
  final String id;
  final String name;
  final String address;
  final String description;
  final bool isActive;
  

  CompanyEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.isActive,
  });

  CompanyEntity copyWith({
    String? id,
    String? name,
    String? address,
    String? description,
    bool? isActive,
  }) {
    return CompanyEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }
}