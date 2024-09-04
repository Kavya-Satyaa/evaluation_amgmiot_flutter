import 'dart:convert';

List<EmployeeInfo> employeeModelFromJson(String str) =>
    List<EmployeeInfo>.from(json.decode(str).map((x)=>EmployeeInfo.fromJson(x)));

class EmployeeInfo
{
  EmployeeInfo({required this.username, required this.password});

  final String username;
  final String password;


  factory EmployeeInfo.fromJson(Map<String, dynamic> json) {
    return EmployeeInfo(
      username: json['username'] as String,
      password: json['password'] as String,
    );
  }

  // Method to convert an instance to a map
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}