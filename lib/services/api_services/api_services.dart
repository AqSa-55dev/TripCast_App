import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;

class ApiServices {

  getMethod( String completeUrl)async {
    http.Response response = await http.get(
        Uri.parse(
            completeUrl,
        )
    );
    return response.body;
  }


  postMethod( String completeUrl, Map<String, dynamic> apiBody)async {
    http.Response response = await http.post(
        Uri.parse(
          completeUrl,
        ),
      body: jsonEncode(apiBody),
      headers: {
          "Content-Type": "application/json"
      }
    );
    return returnResponse(response);
  }
}

// returning response based on status code
returnResponse(http.Response response){
  switch (response.statusCode) {
    case 200:
      return response.body;
    case 201:
      return response.body;
    case 400:
      throw Exception('Bad Request: ${response.body}');
    case 401:
      throw Exception('Unauthorized');
    case 403:
      throw Exception('Unauthorized');
    case 404:
      throw Exception("Not Found");

    case 409:
      var res=jsonDecode(response.body);
      Get.snackbar("Error", res['error']["message"]);
      throw Exception(res['error']["message"]);

    case 500:
      throw Exception('Internal Server Error');

    default:
      throw Exception(
        'Error occurred: ${response.statusCode}: ${response.body}',
      );
  }
}
