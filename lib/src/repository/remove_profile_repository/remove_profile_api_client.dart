import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/api.dart';
import 'dart:convert';
import 'dart:io';

class RemoveProfileAPIClient {
  Future removeProfile(accountId, contactId) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    var _url = REMOVE_PROFILE_PICTURE + '$accountId/$contactId/';

    try {
      final response = await http.put(
        _url,
        headers: {HttpHeaders.authorizationHeader: "Token $token"},
      );

      if (response.statusCode == 200) {
        return compute(_parseUser, response.body);
      } else {
        throw Exception('Error fetching data from server');
      }
    } on SocketException {
      return 'no_internet';
    } on Error catch (e) {
      print(e);
    }
  }
}

User _parseUser(String responseData) {
  final parsed = jsonDecode(responseData);

  return User.fromJson(parsed);
}
