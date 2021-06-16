import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/api.dart';
import 'dart:convert';
import 'dart:io';

class AccountListAPIClient {
  Future getAccounts(int offset, int limit, int loggedInAccountId) async {
    var _uri = '';

    if (loggedInAccountId == null) {
      _uri = accountListUri + '/0/';
    } else {
      _uri = accountListUri + '/$loggedInAccountId/';
    }

    var _url = Uri.http('$getRequestServerName', '$_uri');

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    try {
      final response = await http.get(
        _url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        return compute(_parseAccountList, response.body);
      } else {
        throw Exception('Error on server');
      }
    } on SocketException {
      return 'no_internet';
    }
  }
}

List<AccountListModel> _parseAccountList(String responseBody) {
  final parsed = jsonDecode(responseBody);

  final parsed1 = parsed['results'].cast<Map<String, dynamic>>();

  return parsed1
      .map<AccountListModel>((json) => AccountListModel.fromJson(json))
      .toList();
}
