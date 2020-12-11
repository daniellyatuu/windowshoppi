import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:windowshoppi/api.dart';
import 'package:windowshoppi/src/model/model_files.dart';

class UserPostAPIClient {
  Future userPost(int offset, int limit, int accountId) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    var _url = USER_POST + '$accountId/?limit=$limit&offset=$offset';

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    };

    final response = await http.get(
      _url,
      headers: headers,
    );

    var _post = json.decode(response.body);

    if (_post['detail'] == 'Invalid token.') {
      return 'invalid_token';
    }

    if (response.statusCode == 200) {
      return compute(_parsePost, response.body);
    } else {
      throw Exception('Error on server');
    }
  }
}

List<Post> _parsePost(String responseBody) {
  final parsed = jsonDecode(responseBody);

  final parsed1 = parsed['results'].cast<Map<String, dynamic>>();

  return parsed1.map<Post>((json) => Post.fromJson(json)).toList();
}
