import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:windowshoppi/api.dart';
import 'package:windowshoppi/src/model/model_files.dart';

class ChangePasswordAPIClient {
  Future changePassword(data) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    };

    final response = await http.put(
      CHANGE_PASSWORD,
      headers: headers,
      body: jsonEncode(data),
    );

    print(response.statusCode);
    print(response.body);

    var _result = json.decode(response.body);
    print(_result);

    if (_result['current_password'] != null) {
      if (_result['current_password'][0] == 'Wrong password.') {
        return 'invalid_current_password';
      }
    }

    if (response.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();

      localStorage.setString('token', _result['token']);
      return 'success';
    } else {
      throw Exception('Failed to change password.');
    }
  }
}
