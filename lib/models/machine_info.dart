import 'dart:convert';

List<MachineInfo> machineModelFromJson(String str) =>
    List<MachineInfo>.from(json.decode(str).map((x)=>MachineInfo.fromJson(x)));

class MachineInfo {
  // Constructor
  MachineInfo({
    required this.machineNo,
    required this.plantID,
    required this.isBookmarked,
    required this.machineModel,
    required this.machineDescription,
    required this.status,
    required this.oee
  });

  // Properties
  final String machineNo;
  final String plantID;
  final bool isBookmarked;
  final String machineModel;
  final String machineDescription;
  final String status;
  final int oee;

  // Factory constructor for creating an instance from a map
  factory MachineInfo.fromJson(Map<String, dynamic> json) {
    return MachineInfo(
        machineNo: json['machineName'] as String,
        plantID: json['plant'] as String,
        isBookmarked: json['isBookmarked'] as bool,
        machineModel: json['machineModelName'] as String,
        machineDescription: json['machineDescription'] as String,
        status: json['status'] as String,
        oee: json['oee'] as int
    );
  }

  // Method to convert an instance to a map
  Map<String, dynamic> toJson() {
    return {
      'machineName': machineNo,
      'plant':plantID,
      'isBookmarked': isBookmarked,
      'machineModelName':machineModel,
      'machineDescription':machineDescription,
      'status':status,
      'oee':oee
    };
  }
}