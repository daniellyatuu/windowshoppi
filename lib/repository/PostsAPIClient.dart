import 'package:flutter/foundation.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:windowshoppi/repository/LocalAPIClient.dart';

class PostsAPIClient {
  static const baseUrl = SEARCH_POST + '?category=0';
  final http.Client httpClient;
  PostsAPIClient({@required this.httpClient}) : assert(httpClient != null);

  Future<List<Post>> getPosts(String keyword) async {
    // get active country
    var country = await activeCountry();

    final searchUrl =
        '$baseUrl&country=${country['id'].toString()}&keyword=$keyword';
    final response = await this.httpClient.get(searchUrl);
    print(response.statusCode);
    // print(response.body);
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
