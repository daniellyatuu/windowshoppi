import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/models/product.dart';
import 'package:windowshoppi/services/ProductNextUrlCubit.dart';
import 'package:windowshoppi/services/CountProductsCubit.dart';
import 'package:windowshoppi/src/utilities/database_helper.dart';

Future<List<Product>> fetchProduct(
    context, url, activeCategory, firstLoading) async {
  String newUrl;

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
  print(newUrl);
  final response = await http.get(newUrl);

  final result = jsonDecode(response.body);
  var countResult = result['count'];
  var nextUrl = result['next'];

  if (nextUrl != null) {
    BlocProvider.of<ProductNextUrl>(context).nextUrl(nextUrl);
  } else {
    BlocProvider.of<ProductNextUrl>(context).nextUrl('no_more_product');
  }

  BlocProvider.of<CountProductsCubit>(context).countProduct(countResult);

  return compute(parseProducts, response.body);
}

List<Product> parseProducts(String responseBody) {
  final parsed = jsonDecode(responseBody);

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
