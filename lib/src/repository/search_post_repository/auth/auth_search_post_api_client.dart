import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/api.dart';
import 'dart:convert';

class AuthSearchPostAPIClient {
  Future authSearchPost(
      String postKeyword, accountId, int offset, int limit) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    var _fullUrl = authSearchAccountPostUri + '$accountId/';

    var _url = Uri.http('$getRequestServerName', '$_fullUrl',
        {'keyword': '$postKeyword', 'limit': '$limit', 'offset': '$offset'});

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    };

    final response = await http.get(
      _url,
      headers: headers,
    );

    print(response.statusCode);
    print(response.body);

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
