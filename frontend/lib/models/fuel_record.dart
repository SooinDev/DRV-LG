class FuelRecord {
  final int? recordId;
  final int? vehicleId;
  final DateTime fuelDate;
  final int odoMeter;
  final int pricePerLiter;
  final double liters;
  final int totalPrice;
  final String? memo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FuelRecord({
    this.recordId,
    this.vehicleId,
    required this.fuelDate,
    required this.odoMeter,
    required this.pricePerLiter,
    required this.liters,
    required this.totalPrice,
    this.memo,
    this.createdAt,
    this.updatedAt,
  });

  factory FuelRecord.fromJson(Map<String, dynamic> json) {
    return FuelRecord(
      recordId: json['recordId'] as int?,
      vehicleId: json['vehicleId'] as int?,
      fuelDate: json['fuelDate'] is int
          ? DateTime.fromMillisecondsSinceEpoch(json['fuelDate'] as int)
          : DateTime.parse(json['fuelDate'] as String),
      odoMeter: json['odoMeter'] as int,
      pricePerLiter: json['pricePerLiter'] as int,
      liters: (json['liters'] as num).toDouble(),
      totalPrice: json['totalPrice'] as int,
      memo: json['memo'] as String?,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is int
              ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
              : DateTime.parse(json['createdAt'] as String))
          : null,
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] is int
              ? DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int)
              : DateTime.parse(json['updatedAt'] as String))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (recordId != null) 'recordId': recordId,
      if (vehicleId != null) 'vehicleId': vehicleId,
      'fuelDate': fuelDate.toIso8601String(),
      'odoMeter': odoMeter,
      'pricePerLiter': pricePerLiter,
      'liters': liters,
      'totalPrice': totalPrice,
      if (memo != null) 'memo': memo,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}
