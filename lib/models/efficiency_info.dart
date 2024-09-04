import 'dart:convert';

List<EfficiencyInfo> plantEfficiencyFromJson(String str) =>
    List<EfficiencyInfo>.from(json.decode(str).map((x)=>EfficiencyInfo.fromJson(x)));

EfficiencyInfo efficiencyInfoFromJson(String str) =>
    EfficiencyInfo.fromJson(json.decode(str));

class EfficiencyInfo {
  // Constructor
  EfficiencyInfo({
    required this.plantName,
    required this.oee,
    required this.runningMachines,
    required this.totalMachines,
    required this.stoppedMachines,
  });

  // Properties
  final String plantName;
  final int oee;
  final int runningMachines;
  final int totalMachines;
  final int stoppedMachines;

  // Factory constructor for creating an instance from a map
  factory EfficiencyInfo.fromJson(Map<String, dynamic> json) {
    return EfficiencyInfo(
      plantName: json['plantid'] as String,
      oee: json['oee'] as int,
      runningMachines: json['runningMachines'] as int,
      totalMachines: json['totalMachines'] as int,
      stoppedMachines: json['stoppedMachines'] as int,
    );
  }

  // Method to convert an instance to a map
  Map<String, dynamic> toJson() {
    return {
      'plantName': plantName,
      'oee':oee,
      'runningMachines':runningMachines,
      'totalMachines':totalMachines,
      'stoppedMachines':stoppedMachines
    };
  }
}