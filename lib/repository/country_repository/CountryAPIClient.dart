import 'package:flutter/foundation.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'dart:convert';

class CountryAPIClient {
  final http.Client httpClient;
  CountryAPIClient({@required this.httpClient}) : assert(httpClient != null);

  Future<List<Country>> getCountry() async {
    final response = await this.httpClient.get(ALL_COUNTRY_URL);

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
