import 'package:windowshoppi/src/model/model_files.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/api.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class CountryAPIClient {
  final http.Client httpClient;
  CountryAPIClient({@required this.httpClient}) : assert(httpClient != null);

  Future<List<Country>> getCountry() async {
    var _url = Uri.parse(ALL_COUNTRY_URI);

    final response = await this.httpClient.get(_url);

    if (response.statusCode == 200) {
      return compute(parseCountry, response.body);
    } else {
      throw Exception('Error fetching data from server');
    }
  }
}

List<Country> parseCountry(String responseData) {
  final parsed = jsonDecode(responseData);

  final parsed1 = parsed.cast<Map<String, dynamic>>();

  return parsed1.map<Country>((json) => Country.fromJson(json)).toList();
}
