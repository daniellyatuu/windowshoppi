import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:windowshoppi/api.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'dart:io';

class VendorProfileUpdateAPIClient {
  Future vendorUpdateProfile(accountId, contactId, data) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    var _uri = updateVendorProfileUri + '$accountId/$contactId/';
    var _url = Uri.parse(_uri);

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    };

    try {
      final response = await http.put(
        _url,
        headers: headers,
        body: jsonEncode(data),
      );

      var _user = json.decode(response.body);

      if (_user['username'] != null) {
        if (_user['username'][0] == 'user with this username already exists.') {
          return 'user_exists';
        }
      }

      if (response.statusCode == 200) {
        return compute(_parseUser, response.body);
      } else {
        throw Exception('Failed to update user data.');
      }
    } on SocketException {
      return 'no_internet';
    }
  }
}

User _parseUser(String responseData) {
  final parsed = jsonDecode(responseData);

  return User.fromJson(parsed);
}
