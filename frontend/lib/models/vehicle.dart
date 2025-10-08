class Vehicle {
  final int? vehicleId;
  final int? userId;
  final String number;
  final String maker;
  final String model;
  final int year;
  final String? nickName;
  final int initOdo;
  final int? currentOdometer;
  final DateTime? registerDate;
  final DateTime? updateDate;

  Vehicle({
    this.vehicleId,
    this.userId,
    required this.number,
    required this.maker,
    required this.model,
    required this.year,
    this.nickName,
    required this.initOdo,
    this.currentOdometer,
    this.registerDate,
    this.updateDate,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleId: json['vehicleId'] as int?,
      userId: json['userId'] as int?,
      number: json['number'] as String,
      maker: json['maker'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      nickName: json['nickName'] as String?,
      initOdo: json['initOdo'] as int,
      currentOdometer: json['currentOdometer'] as int?,
      registerDate: json['registerDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['registerDate'] as int)
          : null,
      updateDate: json['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['updateDate'] as int)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (vehicleId != null) 'vehicleId': vehicleId,
      if (userId != null) 'userId': userId,
      'number': number,
      'maker': maker,
      'model': model,
      'year': year,
      if (nickName != null) 'nickName': nickName,
      'initOdo': initOdo,
      if (currentOdometer != null) 'currentOdometer': currentOdometer,
      if (registerDate != null) 'registerDate': registerDate!.toIso8601String(),
      if (updateDate != null) 'updateDate': updateDate!.toIso8601String(),
    };
  }
}
