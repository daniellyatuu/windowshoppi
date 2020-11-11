import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/models/local_storage_keys.dart';
import 'package:windowshoppi/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'dart:convert';

class RegistrationAPIClient {
  // final http.Client httpClient;
  // RegistrationAPIClient({@required this.httpClient})
  //     : assert(httpClient != null);

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

//   Future _createUser(userData) async {
// //    await Future.delayed(Duration(milliseconds: 300));
//     final response = await http.post(
//       REGISTER_USER,
//       headers: {
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(userData),
//     );
//
//     var _user = json.decode(response.body);
//     print(_user);
//
//     if (_user['username'] != null) {
//       if (_user['username'][0] == 'user with this username already exists.') {
//         setState(() {
//           _isUserExists = true;
//         });
//       }
//     } else if (response.statusCode == 201) {
//       SharedPreferences localStorage = await SharedPreferences.getInstance();
//       if (_user['response'] == 'success') {
//         localStorage.setBool(isRegistered, true);
//         localStorage.setString(userToken, _user['token']);
//         localStorage.setString(username, _user['user_name']);
//         localStorage.setInt(businessId, _user['business_id']);
//         localStorage.setString(businessName, _user['business_name']);
//         localStorage.setString(businessLocation, _user['business_location']);
//         localStorage.setString(bio, _user['bio']);
//         localStorage.setString(whatsapp, _user['whatsapp']);
//         localStorage.setString(callNumber, _user['call']);
//         localStorage.setString(profileImage, _user['profile_image']);
//         localStorage.setString(userMail, _user['email']);
//         widget.isLoginStatus(true);
//       }
//     } else {
//       setState(() {
//         _isSubmitting = false;
//       });
//       throw Exception('Failed to register user.');
//     }
//   }
}
