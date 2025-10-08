class MaintenanceRecord {
  final int? maintenanceRecordId;
  final int? vehicleId;
  final DateTime maintenanceDate;
  final int odometer;
  final String item;
  final int totalCost;
  final String? memo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MaintenanceRecord({
    this.maintenanceRecordId,
    this.vehicleId,
    required this.maintenanceDate,
    required this.odometer,
    required this.item,
    required this.totalCost,
    this.memo,
    this.createdAt,
    this.updatedAt,
  });

  factory MaintenanceRecord.fromJson(Map<String, dynamic> json) {
    return MaintenanceRecord(
      maintenanceRecordId: json['maintenanceRecordId'] as int?,
      vehicleId: json['vehicleId'] as int?,
      maintenanceDate: DateTime.parse(json['maintenanceDate'] as String),
      odometer: json['odometer'] as int,
      item: json['item'] as String,
      totalCost: json['totalCost'] as int,
      memo: json['memo'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (maintenanceRecordId != null) 'maintenanceRecordId': maintenanceRecordId,
      if (vehicleId != null) 'vehicleId': vehicleId,
      'maintenanceDate': maintenanceDate.toIso8601String(),
      'odometer': odometer,
      'item': item,
      'totalCost': totalCost,
      if (memo != null) 'memo': memo,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}
