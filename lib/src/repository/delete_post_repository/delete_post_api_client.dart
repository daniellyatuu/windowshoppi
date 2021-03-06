import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/api.dart';
import 'dart:convert';
import 'dart:io';

class DeletePostAPIClient {
  Future deletePost(id) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    var _uri = updatePostUri + '$id/';
    var _url = Uri.parse(_uri);

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    };

    var data = {
      'active': 0,
    };

    try {
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
    } on SocketException {
      return 'no_internet';
    }
  }
}
