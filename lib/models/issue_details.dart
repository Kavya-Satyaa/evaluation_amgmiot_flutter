import 'dart:convert';

List<IssueDetails> issueModelFromJson(String str) =>
    List<IssueDetails>.from(json.decode(str).map((x)=>IssueDetails.fromJson(x)));
class IssueDetails
{
  IssueDetails({required this.issueID , required this.machineID, required this.status});

  final String issueID;
  final String machineID;
  final String status;

  factory IssueDetails.fromJson(Map<String, dynamic> json) {
    return IssueDetails(
      issueID: json['ticketID'] as String,
      status: json['status'] as String,
      machineID: json['machineName'] as String,
    );
  }

  // Method to convert an instance to a map
  Map<String, dynamic> toJson() {
    return {
      'machineName': machineID,
      'ticketID':issueID,
      'status':status
    };
  }

}