import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/models/product.dart';
import 'package:windowshoppi/utilities/database_helper.dart';

Future<List<Product>> fetchProduct(url, activeCategory, firstLoading) async {
  String newUrl;
  print('start get data from server');
  if (firstLoading) {
    var country = await _activeCountry();

    newUrl = url +
        '?category=' +
        activeCategory.toString() +
        '&country=' +
        country['id'].toString();
  } else {
    newUrl = url;
  }

  final response = await http.get(newUrl);

  final result = jsonDecode(response.body);
  var countResult = result['count'];
  var nextUrl = result['next'];

  SharedPreferences localStorage = await SharedPreferences.getInstance();

  /// remove countResult and nextUrl from sharedPreferences
  localStorage.remove('countResult');
  localStorage.remove('nextUrl');

  /// save countResult and nextUrl from sharedPreferences
  localStorage.setInt('countResult', countResult);
  localStorage.setString('nextUrl', nextUrl);

  return compute(parseProducts, response.body);
}

List<Product> parseProducts(String responseBody) {
  final parsed = jsonDecode(responseBody);
  print(parsed);

  final parsed1 = parsed['results'].cast<Map<String, dynamic>>();

  return parsed1.map<Product>((json) => Product.fromJson(json)).toList();
}

_activeCountry() async {
  final dbHelper = DatabaseHelper.instance;

  var activeCountryData = await dbHelper.getActiveCountryFromUserTable();
  if (activeCountryData == null) {
    var _country = await _fetchCountry();
    return _country;
  } else {
    return activeCountryData;
  }
}

Future _fetchCountry() async {
  final response = await http.get(ALL_COUNTRY_URL);

  if (response.statusCode == 200) {
    var countryData = json.decode(response.body);
    return countryData[0];
  } else {
    throw Exception('failed to load data from internet');
  }
}
