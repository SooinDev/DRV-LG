enum AlertStatus {
  GOOD,
  WARN,
  DANGER,
}

class Alert {
  final String itemName;
  final AlertStatus status;
  final String message;
  final DateTime? lastReplacementDate;
  final int? lastReplacementKm;
  final int? nextRecommendedKm;

  Alert({
    required this.itemName,
    required this.status,
    required this.message,
    this.lastReplacementDate,
    this.lastReplacementKm,
    this.nextRecommendedKm,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      itemName: json['itemName'] as String,
      status: AlertStatus.values.firstWhere(
        (e) => e.name == json['status'],
      ),
      message: json['message'] as String,
      lastReplacementDate: json['lastReplacementDate'] != null
          ? (json['lastReplacementDate'] is int
              ? DateTime.fromMillisecondsSinceEpoch(json['lastReplacementDate'] as int)
              : DateTime.parse(json['lastReplacementDate'] as String))
          : null,
      lastReplacementKm: json['lastReplacementKm'] as int?,
      nextRecommendedKm: json['nextRecommendedKm'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'status': status.name,
      'message': message,
      if (lastReplacementDate != null)
        'lastReplacementDate': lastReplacementDate!.toIso8601String(),
      if (lastReplacementKm != null) 'lastReplacementKm': lastReplacementKm,
      if (nextRecommendedKm != null) 'nextRecommendedKm': nextRecommendedKm,
    };
  }
}
