import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:windowshoppi/api.dart';
import 'package:windowshoppi/src/model/model_files.dart';

class SearchPostAPIClient {
  Future searchPost(String postKeyword, int offset, int limit) async {
    var _url = SEARCH_ACCOUNT_POST +
        '?keyword=$postKeyword&limit=$limit&offset=$offset';

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(
      _url,
      headers: headers,
    );

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
