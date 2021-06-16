import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/api.dart';
import 'dart:convert';
import 'dart:io';

class FollowingPostAPIClient {
  Future getFollowingPost(int offset, int limit, int accountId) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    var _fullUrl = followingPostUri + '$accountId/';

    var _url = Uri.http('$getRequestServerName', '$_fullUrl',
        {'limit': '$limit', 'offset': '$offset'});

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
        return compute(_parseFollowingPost, response.body);
      } else {
        throw Exception('Error on server');
      }
    } on SocketException {
      return 'no_internet';
    }
  }
}

List<Post> _parseFollowingPost(String responseBody) {
  final parsed = jsonDecode(responseBody);

  final parsed1 = parsed['results'].cast<Map<String, dynamic>>();

  return parsed1.map<Post>((json) => Post.fromJson(json)).toList();
}
