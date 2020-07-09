import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'global.dart';

class Product {
  final int id;
  final String accountName, businessLocation, caption, datePosted, dateModified;
  final List<Images> productPhoto;

  Product({
    this.id,
    this.accountName,
    this.businessLocation,
    this.caption,
    this.datePosted,
    this.dateModified,
    this.productPhoto,
  });

  // this is static method
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        accountName: json['account_name'],
        businessLocation: json['business_location'],
        caption: json['caption'],
        datePosted: json['date_posted'],
        dateModified: json['date_modified'],
        productPhoto: (json['post_photos'] as List)
            .map((i) => Images.fromJson(i))
            .toList());
  }
}

class Images {
  final String filename;

  Images({this.filename});

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      filename: json['filename'],
    );
  }
}

Future<List<Product>> fetchProduct(http.Client client) async {
  final response = await client.get(ALL_PRODUCT_URL);

  print(response.statusCode);
  print('pass up here');
  if (response.statusCode == 200) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
//    print(mapResponse);
    if (mapResponse["count"] != "") {
      final products = mapResponse["results"].cast<Map<String, dynamic>>();
      final listOfProducts = await products.map<Product>((json) {
        return Product.fromJson(json);
      }).toList();
      return listOfProducts;
    } else {
      return [];
    }
  } else {
    throw Exception('fail to load data from internet');
  }
}
