import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/api.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class UserAPIClient {
  final http.Client httpClient;
  UserAPIClient({@required this.httpClient}) : assert(httpClient != null);

  Future<User> getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    final response = await this.httpClient.get(
      USER_DATA,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );
    // print(response.statusCode);
    // print(response.body);
    // return null;

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      return User.fromJson(responseJson);
    } else {
      throw Exception('Error fetching data from server');
    }
  }
}

// User parseUser(String responseData) {
//   final parsed = jsonDecode(responseData);
//
//   final parsed1 = parsed.cast<Map<String, dynamic>>();
//
//   return parsed1.map<User>((json) => User.fromJson(json)).toList();
// }
