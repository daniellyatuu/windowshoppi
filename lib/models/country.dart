import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:windowshoppi/utilities/database_helper.dart';

import 'global.dart';

class Country {
  int id;
  final String countryName;

  Country({
    this.id,
    this.countryName,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      countryName: json['name'],
    );
  }
}

final dbHelper = DatabaseHelper.instance;

Future countCountry() async {
  int x = await dbHelper.countCountry();
  return x;
}

Future fetchCountry() async {
  /// check if country data available on local
  final allRows = await dbHelper.queryAllRows();
//  print(allRows.length);
  if (allRows.length == 0) {
    final response = await http.get(ALL_COUNTRY_URL);
    if (response.statusCode == 200) {
      var countryData = json.decode(response.body);
      _insert(countryData);
    } else {
      throw Exception('failed to load data from internet');
    }
  } else {
    return allRows;
  }
//  allRows.forEach(
//    (row) => print(row),
//  );
}

void _insert(data) async {
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.insertCountryData(data);
}
