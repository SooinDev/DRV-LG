class Vehicle {
  final int? vehicleId;
  final int? userId;
  final String number;
  final String maker;
  final String model;
  final int year;
  final String? nickName;
  final int initOdo;
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
      registerDate: json['registerDate'] != null
          ? DateTime.parse(json['registerDate'] as String)
          : null,
      updateDate: json['updateDate'] != null
          ? DateTime.parse(json['updateDate'] as String)
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
      if (registerDate != null) 'registerDate': registerDate!.toIso8601String(),
      if (updateDate != null) 'updateDate': updateDate!.toIso8601String(),
    };
  }
}
