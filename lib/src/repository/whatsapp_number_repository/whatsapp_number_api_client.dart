import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:windowshoppi/api.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'dart:io';

class WhatsappNumberAPIClient {
  Future saveNumber(id, data) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    var _uri = updateWhatsappNumberUri + '$id/';
    var _url = Uri.parse(_uri);

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    };

    try {
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
    } on SocketException {
      return 'no_internet';
    }
  }
}

User _parseUser(String responseData) {
  final parsed = jsonDecode(responseData);

  return User.fromJson(parsed);
}
