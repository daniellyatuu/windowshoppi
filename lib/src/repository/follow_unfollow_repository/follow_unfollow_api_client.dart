import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/api.dart';
import 'dart:convert';
import 'dart:io';

class FollowUnfollowAPIClient {
  Future followUnfollow(followData) async {
    print('here please');
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    var _url = Uri.parse(followUnfollowAccountUri);

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
        return json.decode(response.body);
      } else {
        throw Exception('Error From Server');
      }
    } on SocketException {
      return 'no_internet';
    }
  }
}
