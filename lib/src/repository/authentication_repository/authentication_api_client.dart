import 'package:windowshoppi/src/model/model_files.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/api.dart';
import 'dart:convert';
import 'dart:io';

class AuthenticationAPIClient {
  Future getUser(token) async {
    var _url = Uri.http('$getRequestServerName', '$userDataUri');

    try {
      final response = await http.get(
        _url,
        headers: {HttpHeaders.authorizationHeader: "Token $token"},
      );

      if (response.statusCode == 200) {
        return compute(parseUser, response.body);
      } else {
        throw Exception('Error fetching data from server');
      }
    } on SocketException {
      return 'no_internet';
    }
  }
}

User parseUser(String responseData) {
  final parsed = jsonDecode(responseData);

  return User.fromJson(parsed);
}
