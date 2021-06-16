import 'package:windowshoppi/src/model/model_files.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/api.dart';
import 'dart:convert';

class AccountInfoAPIClient {
  Future getAccountInfo(accountId) async {
    var _uri = followerFollowingPostNumberUri + '$accountId/';

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
      return compute(_parseAccountInfo, response.body);
    } else {
      throw Exception('internal server error.');
    }
  }
}

AccountInfo _parseAccountInfo(String responseData) {
  final parsed = jsonDecode(responseData);
  return AccountInfo.fromJson(parsed);
}
