import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:windowshoppi/api.dart';
import 'package:windowshoppi/src/model/model_files.dart';

class WhatsappNumberAPIClient {
  Future saveNumber(id, data) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    var _url = UPDATE_WHATSAPP_NUMBER + '$id/';

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    };

    final response = await http.put(
      _url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return compute(_parseUser, response.body);
    } else {
      throw Exception('Failed to update whatsapp number.');
    }
  }
}

User _parseUser(String responseData) {
  final parsed = jsonDecode(responseData);

  return User.fromJson(parsed);
}
