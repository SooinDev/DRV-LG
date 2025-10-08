class MaintenanceRecord {
  final int? maintenanceRecordId;
  final int? vehicleId;
  final DateTime maintenanceDate;
  final int odoMeter;
  final String item;
  final int totalCost;
  final String? memo;
  final DateTime? createAt;
  final DateTime? updateAt;

  MaintenanceRecord({
    this.maintenanceRecordId,
    this.vehicleId,
    required this.maintenanceDate,
    required this.odoMeter,
    required this.item,
    required this.totalCost,
    this.memo,
    this.createAt,
    this.updateAt,
  });

  factory MaintenanceRecord.fromJson(Map<String, dynamic> json) {
    return MaintenanceRecord(
      maintenanceRecordId: json['maintenanceRecordId'] as int?,
      vehicleId: json['vehicleId'] as int?,
      maintenanceDate: DateTime.parse(json['maintenanceDate'] as String),
      odoMeter: json['odoMeter'] as int,
      item: json['item'] as String,
      totalCost: json['totalCost'] as int,
      memo: json['memo'] as String?,
      createAt: json['createAt'] != null
          ? DateTime.parse(json['createAt'] as String)
          : null,
      updateAt: json['updateAt'] != null
          ? DateTime.parse(json['updateAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (maintenanceRecordId != null) 'maintenanceRecordId': maintenanceRecordId,
      if (vehicleId != null) 'vehicleId': vehicleId,
      'maintenanceDate': maintenanceDate.toIso8601String(),
      'odoMeter': odoMeter,
      'item': item,
      'totalCost': totalCost,
      if (memo != null) 'memo': memo,
      if (createAt != null) 'createAt': createAt!.toIso8601String(),
      if (updateAt != null) 'updateAt': updateAt!.toIso8601String(),
    };
  }
}
