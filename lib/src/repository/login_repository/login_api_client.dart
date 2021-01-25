import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:windowshoppi/api.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'dart:io';

class LoginAPIClient {
  Future userLogin(data) async {
    try {
      final response = await http.post(
        USER_LOGIN,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      var _user = json.decode(response.body);

      if (_user['non_field_errors'] != null) {
        return 'invalid_account';
      } else if (_user['result'] == 'access_to_vendor_only') {
        return 'access_to_vendor_only';
      } else if (response.statusCode == 200) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();

        localStorage.setBool('isRegistered', true);
        localStorage.setString('token', _user['token']);

        return compute(_parseUser, response.body);
      } else {
        throw Exception('Error on server');
      }
    } on SocketException {
      return 'no_internet';
    }
  }
}

User _parseUser(String responseData) {
  final parsed = jsonDecode(responseData);

  return User.fromJson(parsed);
}
