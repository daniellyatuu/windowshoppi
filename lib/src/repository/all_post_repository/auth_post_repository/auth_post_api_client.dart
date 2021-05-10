import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/api.dart';
import 'dart:convert';
import 'dart:io';

class AuthPostAPIClient {
  Future authPost(int offset, int limit, int accountId) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var postCount = localStorage.getInt('postCount') ?? 0;
    var token = localStorage.getString('token');

    var _fullUrl = authAllPostUri + '$accountId/';

    var _url = Uri.http('$getRequestServerName', '$_fullUrl',
        {'limit': '$limit', 'offset': '$offset', 'post_count': '$postCount'});

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Token $token",
    };

    try {
      final response = await http.get(
        _url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        // save new post count
        var authPostData = jsonDecode(response.body);
        localStorage.setInt('postCount', authPostData['count']);

        return compute(_parseAuthPost, response.body);
      } else {
        throw Exception('Error on server');
      }
    } on SocketException {
      return 'no_internet';
    }
  }
}

List<Post> _parseAuthPost(String responseBody) {
  final parsed = jsonDecode(responseBody);

  final parsed1 = parsed['results'].cast<Map<String, dynamic>>();

  return parsed1.map<Post>((json) => Post.fromJson(json)).toList();
}
