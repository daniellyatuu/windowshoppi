import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:windowshoppi/api.dart';
import 'package:windowshoppi/src/model/model_files.dart';

class DeletePostAPIClient {
  Future deletePost(id) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    var _url = UPDATE_POST + '$id/';

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    };

    var data = {
      'active': 0,
    };

    final response = await http.put(
      _url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      throw Exception('Error on server');
    }
  }
}
