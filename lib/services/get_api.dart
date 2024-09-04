import 'dart:developer';
import 'package:evaluation_amgmiot/models/efficiency_info.dart';
import 'package:http/http.dart';
import '../models/api_response.dart';
import '../utilities/global.dart';
import '../utilities/utilities.dart';

class ApiDataService {

  //Retrieving list of data from database using API
  dynamic getDataFromApi(
      dynamic dataList, String reqURL, dynamic jsonEntity) async {
    ApiResponse? apiRes;

    bool isOnline = await checkInternetConnection();
    if (isOnline) {
      Response response = Response("", 500);
      try {
        reqURL = apiLink + reqURL;
        var url = Uri.parse(reqURL);
        log("GetLink: $url");
        response = await get(url);
      } catch (e) {
        log(e.toString());
      }

      if (response.statusCode == 200) {
        var jsonData = response.body;
        apiRes = ApiResponse(opData: jsonEntity(jsonData), opCode: "1");
      } else {
        apiRes = ApiResponse(opCode: "2");
        log(apiRes.opData);
      }
    }

    if (apiRes != null) {
      if (apiRes.opCode == "1") {
        dataList = apiRes.opData;
      } else {
        errorMessage = "Something went wrong in API";
      }
    } else {
      errorMessage = "Something went wrong!\nPlease Try Again Later";
    }
    return dataList;
  }

  //Checking if requested URL data has successfully made changes in database
  Future<String> getStringDataFromApi(String reqURL) async {
    ApiResponse? apiRes;

    bool isOnline = await checkInternetConnection();
    if (isOnline) {
      Response response = Response("", 500);
      try {
        reqURL = apiLink + reqURL;
        var url = Uri.parse(reqURL);
        log("GetLink: $url");
        response = await get(url);
      } catch (e) {
        log(e.toString());
      }

      if (response.statusCode == 200) {
        var jsonData = response.body;
        apiRes = ApiResponse(opData: jsonData, opCode: "1");
      } else {
        apiRes = ApiResponse(opCode: "2");
        log(apiRes.opData);
      }
    }

    if (apiRes != null) {
      if (apiRes.opCode == "1") {
        return apiRes.opData;
      } else {
        errorMessage = "Something went wrong in API";
        return errorMessage;
      }
    } else {
      errorMessage = "Something went wrong!\nPlease Try Again Later";
      return errorMessage;
    }
  }

  //Retrieving single efficiency object from database
  dynamic getEfficiencyDetailFromApi(String reqURL) async {
    ApiResponse? apiRes;
    EfficiencyInfo data = EfficiencyInfo(
        plantName: " ",
        oee: 0,
        runningMachines: 0,
        totalMachines: 0,
        stoppedMachines: 0);

    bool isOnline = await checkInternetConnection();
    if (isOnline) {
      Response response = Response("", 500);
      try {
        reqURL = apiLink + reqURL;
        var url = Uri.parse(reqURL);
        log("GetLink: $url");
        response = await get(url);
      } catch (e) {
        log(e.toString());
      }

      if (response.statusCode == 200) {
        var jsonData = response.body;
        apiRes =
            ApiResponse(opData: efficiencyInfoFromJson(jsonData), opCode: "1");
      } else {
        apiRes = ApiResponse(opCode: "2");
        log(apiRes.opData);
      }
    }

    if (apiRes != null) {
      if (apiRes.opCode == "1") {
        data = apiRes.opData;
      } else {
        errorMessage = "Something went wrong in API";
      }
    } else {
      errorMessage = "Something went wrong!\nPlease Try Again Later";
    }
    return data;
  }
}
