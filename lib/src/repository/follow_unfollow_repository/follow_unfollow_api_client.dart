import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/api.dart';
import 'dart:convert';
import 'dart:io';

class FollowUnfollowAPIClient {
  Future followUnfollow(followData) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    var _url = Uri.parse(followAccount);

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    };

    try {
      final response = await http.post(
        _url,
        headers: headers,
        body: jsonEncode(followData),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 201) {
        var _result = json.decode(response.body);
        if (_result == true) {
          return _result;
        }
      } else if (response.statusCode == 200) {
        return 'already_followed';
      } else {
        throw Exception('Error From Server');
      }
    } on SocketException {
      return 'no_internet';
    }
  }
}
