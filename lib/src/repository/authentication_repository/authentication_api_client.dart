import 'package:windowshoppi/src/model/model_files.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/api.dart';
import 'dart:convert';
import 'dart:io';

class AuthenticationAPIClient {
  Future<User> getUser(token) async {
    final response = await http.get(
      USER_DATA,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    if (response.statusCode == 200) {
      return compute(parseUser, response.body);
    } else {
      throw Exception('Error fetching data from server');
    }
  }
}

User parseUser(String responseData) {
  final parsed = jsonDecode(responseData);

  return User.fromJson(parsed);
}
