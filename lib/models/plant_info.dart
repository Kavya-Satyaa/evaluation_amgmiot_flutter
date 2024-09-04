import 'dart:convert';

List<PlantInfo> plantModelFromJson(String str) =>
    List<PlantInfo>.from(json.decode(str).map((x)=>PlantInfo.fromJson(x)));

class PlantInfo {
  // Constructor
  PlantInfo({
    required this.plantName,
    required this.oee,
  });

  // Properties
  final String plantName;
  final int oee;

  // Factory constructor for creating an instance from a map
  factory PlantInfo.fromJson(Map<String, dynamic> json) {
    return PlantInfo(
      plantName: json['plantName'] as String,
      oee: json['oee'] as int,
    );
  }

  // Method to convert an instance to a map
  Map<String, dynamic> toJson() {
    return {
      'plantName': plantName,
      'oee':oee,
    };
  }
}