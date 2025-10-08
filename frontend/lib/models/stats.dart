class Stats {
  final int totalFuelCost;
  final int totalMaintenanceCost;
  final int totalSpending;

  Stats({
    required this.totalFuelCost,
    required this.totalMaintenanceCost,
    required this.totalSpending,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      totalFuelCost: json['totalFuelCost'] as int,
      totalMaintenanceCost: json['totalMaintenanceCost'] as int,
      totalSpending: json['totalSpending'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalFuelCost': totalFuelCost,
      'totalMaintenanceCost': totalMaintenanceCost,
      'totalSpending': totalSpending,
    };
  }
}
