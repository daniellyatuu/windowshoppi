import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:windowshoppi/api.dart';

class RegistrationAPIClient {
  Future registerUser(data) async {
    final response = await http.post(
      REGISTER_USER,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    var _user = json.decode(response.body);
    print(response.statusCode);
    print(response.body);

    if (_user['username'] != null) {
      if (_user['username'][0] == 'user with this username already exists.') {
        return 'user_exists';
      }
    } else if (response.statusCode == 201) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();

      localStorage.setBool('isRegistered', true);
      localStorage.setString('token', _user['token']);
      return 'success';
    } else {
      throw Exception('Failed to register user.');
    }
  }
}
