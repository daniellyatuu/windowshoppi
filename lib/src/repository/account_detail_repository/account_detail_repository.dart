import 'package:windowshoppi/src/model/model_files.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/api.dart';
import 'dart:convert';

class AccountDetailAPIClient {
  Future getAccountDetail(accountId) async {
    var _uri = accountInfoUri + '$accountId/';
    var _url = Uri.http('$getRequestServerName', '$_uri');

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(
      _url,
      headers: headers,
    );

    if (response.statusCode == 404) {
      return response.statusCode;
    }

    if (response.statusCode == 200) {
      return compute(_parseAccount, response.body);
    } else {
      throw Exception('internal server error.');
    }
  }
}

Account _parseAccount(String responseData) {
  final parsed = jsonDecode(responseData);
  return Account.fromJson(parsed);
}
