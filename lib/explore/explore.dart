import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/products/details/bottom_section.dart';
import 'package:windowshoppi/drawer/app_drawer.dart';
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
  String newUrl, nextUrl;
  bool removeListData, _isGettingServerData, firstLoading;
  bool _isInitialLoading = true, _isLoadingMoreData = true;
  int activeCategory = 0;

  dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProduct(ALL_PRODUCT_URL, removeListData = true, firstLoading = true,
        activeCategory);

    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (nextUrl != null && _isGettingServerData == false) {
            fetchProduct(nextUrl, removeListData = false, firstLoading = false,
                activeCategory);
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

  Future fetchProduct(url, removeListData, firstLoading, activeCategory) async {
    setState(() {
      _isInitialLoading = firstLoading ? true : false;
      _isGettingServerData = true;
    });

    if (_isInitialLoading) {
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
//    print(response.statusCode);

    if (response.statusCode == 200) {
      var productData = json.decode(response.body);
      nextUrl = productData['next'];

      setState(() {
        Iterable list = productData['results'];
        if (removeListData) {
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
      _isInitialLoading = false;
      _isGettingServerData = false;
    });
  }

  _activeCountry() async {
    var activeCountryData = await dbHelper.getActiveCountryFromUserTable();
    return activeCountryData;
  }

  Future<void> refresh() async {
    await Future.delayed(Duration(milliseconds: 700));

    setState(() {
      _isLoadingMoreData = true;
    });
    fetchProduct(ALL_PRODUCT_URL, removeListData = true, firstLoading = true,
        activeCategory);
  }

  Future<void> refreshOnChangeCountry() async {
    setState(() {
      _isLoadingMoreData = true;
    });
    fetchProduct(ALL_PRODUCT_URL, removeListData = true, firstLoading = true,
        activeCategory);
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
          SelectCountry(onCountryChanged: () => refreshOnChangeCountry()),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: _isGettingServerData == false && data.length == 0
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        fetchProduct(ALL_PRODUCT_URL, removeListData = true,
                            firstLoading = true, activeCategory);
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
            : _isInitialLoading
                ? Center(
                    child: CircularProgressIndicator(strokeWidth: 2.0),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
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
                      } else if (_isLoadingMoreData && data.length >= 15) {
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
      ),
    );
  }
}
