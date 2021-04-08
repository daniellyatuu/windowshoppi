import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/api.dart';
import 'dart:convert';

import 'package:windowshoppi/src/model/model_files.dart';

class UpdatePostAPIClient {
  Future updatePost(postId, data) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    var _uri = updatePostUri + '$postId/';
    var _url = Uri.parse(_uri);

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
      // get post data

      var _postUri = userSinglePostDataUri + "$postId/";
      var _postUrl = Uri.http('$getRequestServerName', '$_postUri');

      final getPostResponse = await http.get(
        _postUrl,
        headers: headers,
      );

      if (getPostResponse.statusCode == 200) {
        return compute(_parsePost, getPostResponse.body);
      } else {
        throw Exception('Error fetching data from server');
      }
    } else {
      throw Exception('Error on server');
    }
  }
}

Post _parsePost(String responseData) {
  final parsed = jsonDecode(responseData);

  return Post.fromJson(parsed);
}
