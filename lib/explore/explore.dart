import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/products/details/bottom_section.dart';
import 'package:windowshoppi/drawer/app_drawer.dart';
import 'package:windowshoppi/horizontal_list/horizontal_list.dart';
import 'package:windowshoppi/myappbar/select_country.dart';
import 'package:windowshoppi/utilities/database_helper.dart';
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
  final dbHelper = DatabaseHelper.instance;
  ScrollController _scrollController = ScrollController();
  var data = new List<Product>();
  String nextUrl;
  bool firstLoading,
      _isInitialLoading = false,
      isLoadMore,
      _isLoadingMoreData = true,
      clearCachedData,
      _isGettingServerData;

  dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProduct(ALL_PRODUCT_URL, clearCachedData = true, firstLoading = true);

    _scrollController.addListener(
      () {
//      print(_scrollController.position.pixels);
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (nextUrl != null && _isGettingServerData == false) {
//            print('load more');
            this.fetchProduct(
                nextUrl, clearCachedData = false, firstLoading = false);
          }

          if (nextUrl == null) {
            setState(() {
              _isLoadingMoreData = false;
            });
          }
        }
      },
    );
  }

  Future fetchProduct(url, clearCachedData, firstLoading) async {
    var country = await _activeCountry();

    setState(() {
      _isGettingServerData = true;
      if (firstLoading) {
        _isInitialLoading = true;
      }
    });
    var newUrl = url + country['id'].toString();
    final response = await http.get(newUrl);
//    print(response.statusCode);
    if (response.statusCode == 200) {
      var productData = json.decode(response.body);
      nextUrl = productData['next'];
      setState(() {
        Iterable list = productData['results'];
//        print(clearCachedData);
        if (clearCachedData) {
          data = list.map((model) => Product.fromJson(model)).toList();
        } else {
          data.addAll(list.map((model) => Product.fromJson(model)).toList());
        }
      });
//      print(data);
    } else {
      throw Exception('failed to load data from internet');
    }

    setState(() {
      _isGettingServerData = false;
      if (firstLoading) {
        _isInitialLoading = false;
      }
    });
  }

  _activeCountry() async {
    var activeCountryData = await dbHelper.getActiveCountryFromUserTable();
    return activeCountryData;
  }

  Future<void> refresh() {
    setState(() {
      _isLoadingMoreData = true;
    });
    return fetchProduct(
        ALL_PRODUCT_URL, clearCachedData = true, firstLoading = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'windowshoppi',
          style: TextStyle(fontFamily: 'Itim'),
        ),
        actions: <Widget>[
          SelectCountry(onCountryChanged: () => refresh()),
        ],
      ),
      drawer: AppDrawer(),
      body: Builder(
        builder: (_) {
          if (_isInitialLoading) {
            return Center(
              child: CircularProgressIndicator(strokeWidth: 2.0),
            );
          }

          return RefreshIndicator(
            onRefresh: refresh,
            child: data.length == 0
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            fetchProduct(ALL_PRODUCT_URL,
                                clearCachedData = true, firstLoading = true);
                          },
                          child: Icon(
                            Icons.refresh,
                            size: 45,
                            color: Colors.grey[500],
                          ),
                        ),
                        Text(
                          'No post',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: data == null ? 0 : data.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < data.length) {
                        return Card(
                          margin: EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              TopSection(
                                account: data[index].accountName,
                                location: data[index].businessLocation,
                              ),
                              PostSection(postImage: data[index].productPhoto),
                              BottomSection(
                                  callNo: data[index].callNumber,
                                  whatsapp: data[index].whatsappNumber),
                              PostDetails(caption: data[index].caption),
                            ],
                          ),
                        );
                      } else if (_isLoadingMoreData && data.length > 15) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 18.0,
                                width: 18.0,
                                child:
                                    CircularProgressIndicator(strokeWidth: 1.0),
                              ),
                              Text(
                                '  please wait..',
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Center(
                            child: data.length > 15
                                ? Text(
                                    'no more data',
                                    style: TextStyle(color: Colors.teal),
                                  )
                                : Text(''),
                          ),
                        );
                      }
                    },
                  ),
          );
        },
      ),
    );
  }
}
