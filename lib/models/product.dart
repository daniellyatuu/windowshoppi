import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'global.dart';
import 'package:flutter/material.dart';

class Product {
  final int id;
  final String accountName,
      callNumber,
      whatsappNumber,
      businessLocation,
      caption;
  final List<Images> productPhoto;

  Product({
    this.id,
    this.accountName,
    this.callNumber,
    this.whatsappNumber,
    this.businessLocation,
    this.caption,
    this.productPhoto,
  });

  // this is static method
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      accountName: json['account_name'],
      callNumber: json['call_number'],
      whatsappNumber:
          json['whatsapp_number'] != null ? json['whatsapp_number'] : null,
      businessLocation: json['business_location'],
      caption: json['caption'],
      productPhoto:
          (json['post_photos'] as List).map((i) => Images.fromJson(i)).toList(),
    );
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

String nextLink = '';
Future<List<Product>> fetchProduct(http.Client client, url) async {
//  final response = await client.get(ALL_PRODUCT_URL);
  final response = await client.get(url);

  print(response.statusCode);
  print('pass up here');
  if (response.statusCode == 200) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
//    print(mapResponse);
//    print(mapResponse);
    nextLink = mapResponse['next'];
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

void loadMorePost(nextUrl) {
  print('down here');
  print(nextUrl);
  if (nextUrl != null) {
    fetchProduct(http.Client(), nextUrl);
  }
}
