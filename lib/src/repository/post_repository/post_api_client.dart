import 'package:flutter/foundation.dart';
import 'package:windowshoppi/api.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'dart:convert';

class PostAPIClient {
  final http.Client httpClient;
  PostAPIClient({@required this.httpClient}) : assert(httpClient != null);

  Future<List<Post>> fetchPosts(int startIndex, int limit) async {
    var _url = FETCH_POST_API + '?country=5&offset=$startIndex&limit=$limit';
    print(_url);
    final response = await this.httpClient.get(_url);
    print(response.body);

    if (response.statusCode == 200) {
      return compute(parsePosts, response.body);
    } else {
      throw Exception('Error getting posts info');
    }
  }
}

List<Post> parsePosts(String responseBody) {
  final parsed = jsonDecode(responseBody);

  final parsed1 = parsed['results'].cast<Map<String, dynamic>>();

  return parsed1.map<Post>((json) => Post.fromJson(json)).toList();
}
