import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/products/details/bottom_section.dart';
import 'package:windowshoppi/drawer/app_drawer.dart';
import 'package:windowshoppi/horizontal_list/horizontal_list.dart';
import 'package:windowshoppi/myappbar/select_country.dart';
import 'top_section.dart';
import 'post_section.dart';
import 'post_details.dart';
import 'package:windowshoppi/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_pro/carousel_pro.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  ScrollController _scrollController = ScrollController();
  List data;
  String nextUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchProduct(http.Client(), ALL_PRODUCT_URL);

    _scrollController.addListener(() {
//      print(_scrollController.position.pixels);
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (nextUrl != null) {
          this.fetchProduct(http.Client(), nextUrl);
        }

//        print(nextUrl);
      }
    });
  }

  Future<List<Product>> fetchProduct(http.Client client, url) async {
//  final response = await client.get(ALL_PRODUCT_URL);
    final response = await client.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);

      nextUrl = mapResponse['next'];
      if (mapResponse["count"] != "") {
        final products = mapResponse["results"].cast<Map<String, dynamic>>();
        final listOfProducts = await products.map<Product>((json) {
          return Product.fromJson(json);
        }).toList();
//        return listOfProducts;

        setState(() {
          data = listOfProducts;
        });
      } else {
        return [];
      }
    } else {
      throw Exception('failed to load data from internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('http get'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Container(
              height: 200,
              color: Colors.blue,
              child: Text(data[index].caption),
            ),
          );
        },
      ),
    );
  }
}

//class Explore extends StatefulWidget {
//  @override
//  _ExploreState createState() => _ExploreState();
//}
//
//class _ExploreState extends State<Explore> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(
//          'windowshoppi',
//          style: TextStyle(fontFamily: 'Itim'),
//        ),
//        actions: <Widget>[
//          SelectCountry(),
//        ],
//      ),
//      drawer: AppDrawer(),
//      body: FutureBuilder(
//        future: fetchProduct(http.Client(), ALL_PRODUCT_URL),
//        builder: (context, snapshot) {
//          if (snapshot.hasError) {
//            print(snapshot.error);
////            Center(
////              child: Text('display error'),
////            );
//          }
//          return snapshot.hasData
//              ? SinglePost(product: snapshot.data)
//              : Center(child: CircularProgressIndicator(strokeWidth: 3.0));
//        },
//      ),
//    );
//  }
//}
//
//class SinglePost extends StatefulWidget {
//  final List<Product> product;
//
//  SinglePost({Key key, this.product}) : super(key: key);
//
//  @override
//  _SinglePostState createState() => _SinglePostState();
//}
//
//class _SinglePostState extends State<SinglePost> {
//  ScrollController _scrollController = ScrollController();
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    print('check scrolling in here');
//    print(widget.product);
//
//    _scrollController.addListener(() {
////      print(_scrollController.position.pixels);
//      if (_scrollController.position.pixels ==
//          _scrollController.position.maxScrollExtent) {
//        loadMorePost(nextLink);
//        setState(() {});
//
////        print(nextLink);
//      }
//    });
//  }
//
//  @override
//  void dispose() {
//    // TODO: implement dispose
//    _scrollController.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return ListView.builder(
//        controller: _scrollController,
//        itemCount: widget.product.length,
//        itemBuilder: (context, index) {
//          return Card(
//            child: Column(
//              mainAxisAlignment: MainAxisAlignment.start,
//              mainAxisSize: MainAxisSize.min,
//              crossAxisAlignment: CrossAxisAlignment.stretch,
//              children: <Widget>[
//                TopSection(
//                  account: widget.product[index].accountName,
//                  location: widget.product[index].businessLocation,
//                ),
////                PostSection(postImage: product[index].productPhoto),
//                PostSection(postData: widget.product[index]),
//                BottomSection(
//                    callNo: widget.product[index].callNumber,
//                    whatsapp: widget.product[index].whatsappNumber),
//                PostDetails(caption: widget.product[index].caption),
//              ],
//            ),
//          );
//        });
//  }
//}
//
////Column(
////children: <Widget>[
////AppCategory(),
////Expanded(
////child: ListView.builder(
////itemCount: imageList.length,
////itemBuilder: (context, index) {
////return SinglePost(imgUrl: imageList[index]);
////},
////),
////),
////],
////),
//
///// This is the stateless widget that the main application instantiates.
//class MyStatelessWidget extends StatelessWidget {
//  MyStatelessWidget({Key key}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return DecoratedBox(
//      decoration: BoxDecoration(
//        color: Colors.white,
//        border: Border.all(),
//        borderRadius: BorderRadius.circular(20),
//      ),
//      child: Image.network(
//        'https://example.com/image.jpg',
//        loadingBuilder: (BuildContext context, Widget child,
//            ImageChunkEvent loadingProgress) {
//          if (loadingProgress == null) return child;
//          return Center(
//            child: CircularProgressIndicator(
//              value: loadingProgress.expectedTotalBytes != null
//                  ? loadingProgress.cumulativeBytesLoaded /
//                      loadingProgress.expectedTotalBytes
//                  : null,
//            ),
//          );
//        },
//      ),
//    );
//  }
//}
