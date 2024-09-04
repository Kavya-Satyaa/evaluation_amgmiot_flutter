import 'dart:developer';
import 'package:evaluation_amgmiot/models/issue_details.dart';
import 'package:http/http.dart';
import '../utilities/global.dart';

//Sending Machine class object to be inserted in database
Future<String> sendMachineFilesToApi(
    String endpoint, String plant, String machine
    ) async {
  String urlLink = "$apiLink$endpoint?plant=$plant&machine=$machine";
  var url = Uri.parse(urlLink);
  log("postLink: $url");
  final request = MultipartRequest(
    'POST',
    url,
  );
  request.headers.addAll({
    'Content-Type':
        'multipart/form-data',
  });

  log("Sending request");
  final response = await request.send();

  if (response.statusCode == 200) {
    log('Updated Bookmark');
  } else {
    log('Failed to update Bookmark: ${response.statusCode}');
  }
  return response.statusCode.toString();
}

//Sending Issue class object to be inserted in database
Future<String> sendIssueDetailsToApi(
  String endpoint,
  IssueDetails issue,
) async {
  String urlLink = apiLink + endpoint;
  var url = Uri.parse(urlLink);
  log("postLink: $url");
  final request = MultipartRequest(
    'POST',
    url,
  );
  request.headers.addAll({
    'Content-Type': 'multipart/form-data',
  });

  request.fields['TicketID'] = issue.issueID;
  request.fields['MachineName'] = issue.machineID;
  request.fields['Status'] = issue.status;

  log("Sending request");
  final response = await request.send();

  if (response.statusCode == 200) {
    log('Issue ticket raised successfully');
  } else {
    log('Failed to raise issue ticket: ${response.statusCode}');
  }

  return response.statusCode.toString();
}
