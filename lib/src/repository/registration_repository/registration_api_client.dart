import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:windowshoppi/api.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'dart:io';

class RegistrationAPIClient {
  Future registerUser(data) async {
    var _url = Uri.parse(registerUserUri);

    try {
      final response = await http.post(
        _url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      var _user = json.decode(response.body);

      if (_user['username'] != null) {
        if (_user['username'][0] == 'user with this username already exists.') {
          return 'user_exists';
        }
      }

      if (response.statusCode == 201) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();

        localStorage.setBool('isRegistered', true);
        localStorage.setString('token', _user['token']);

        return compute(_parseUser, response.body);
      } else {
        throw Exception('Failed to register user.');
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
