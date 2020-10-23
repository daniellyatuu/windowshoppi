import 'package:flutter/foundation.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'dart:convert';

class PostsAPIClient {
  static const baseUrl = SEARCH_POST + '?category=0&country=5';
  final http.Client httpClient;
  PostsAPIClient({@required this.httpClient}) : assert(httpClient != null);

  Future<List<Post>> getPosts(String keyword) async {
    // print('step 3 : http call');

    final searchUrl = '$baseUrl&keyword=$keyword';
    print(searchUrl);
    final response = await this.httpClient.get(searchUrl);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return compute(parseProducts, response.body);
    } else {
      throw Exception('Error getting posts info');
    }
  }
}

List<Post> parseProducts(String responseBody) {
  final parsed = jsonDecode(responseBody);

  // print(responseBody);
  final parsed1 = parsed['results'].cast<Map<String, dynamic>>();
  //
  return parsed1.map<Post>((json) => Post.fromJson(json)).toList();
}
