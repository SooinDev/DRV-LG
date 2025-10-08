class FuelRecord {
  final int? recordId;
  final int? vehicleId;
  final DateTime fuelDate;
  final double fuelAmount;

  FuelRecord({
    this.recordId,
    this.vehicleId,
    required this.fuelDate,
    required this.fuelAmount,
  });

  factory FuelRecord.fromJson(Map<String, dynamic> json) {
    return FuelRecord(
      recordId: json['recordId'] as int?,
      vehicleId: json['vehicleId'] as int?,
      fuelDate: DateTime.parse(json['fuelDate'] as String),
      fuelAmount: (json['fuelAmount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (recordId != null) 'recordId': recordId,
      if (vehicleId != null) 'vehicleId': vehicleId,
      'fuelDate': fuelDate.toIso8601String(),
      'fuelAmount': fuelAmount,
    };
  }
}
