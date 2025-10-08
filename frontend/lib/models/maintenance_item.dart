class MaintenanceItem {
  final int? itemId;
  final String itemName;
  final int? recommendedKm;
  final int? recommendedMonths;
  final String? description;

  MaintenanceItem({
    this.itemId,
    required this.itemName,
    this.recommendedKm,
    this.recommendedMonths,
    this.description,
  });

  factory MaintenanceItem.fromJson(Map<String, dynamic> json) {
    return MaintenanceItem(
      itemId: json['itemId'] as int?,
      itemName: json['itemName'] as String,
      recommendedKm: json['recommendedKm'] as int?,
      recommendedMonths: json['recommendedMonths'] as int?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (itemId != null) 'itemId': itemId,
      'itemName': itemName,
      if (recommendedKm != null) 'recommendedKm': recommendedKm,
      if (recommendedMonths != null) 'recommendedMonths': recommendedMonths,
      if (description != null) 'description': description,
    };
  }
}
