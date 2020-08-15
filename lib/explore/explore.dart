import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/models/local_storage_keys.dart';
import 'package:windowshoppi/products/details/bottom_section.dart';
import 'package:windowshoppi/drawer/app_drawer.dart';
import 'package:windowshoppi/myappbar/select_country.dart';
import 'package:windowshoppi/utilities/database_helper.dart';
import 'package:windowshoppi/widgets/loader.dart';
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
  bool _isInitialLoading = true;
  int activeCategory = 0;
  int allProducts = 0;
  int activePhoto = 0;
  int loggedInBussinessId = 0;

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

      // get bussiness_id if user loggedIn
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var _businessId = localStorage.getInt(businessId);
      if (_businessId != null) {
        setState(() {
          loggedInBussinessId = _businessId;
        });
      }

      setState(() {
        Iterable list = productData['results'];
        allProducts = productData['count'];
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

    fetchProduct(ALL_PRODUCT_URL, removeListData = true, firstLoading = true,
        activeCategory);
  }

  Future<void> refreshOnChangeCountry() async {
    fetchProduct(ALL_PRODUCT_URL, removeListData = true, firstLoading = true,
        activeCategory);
  }

  _changeActivePhoto(value) async {
    setState(() {
      activePhoto = value;
    });
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
          SelectCountry(
            onCountryChanged: () => refreshOnChangeCountry(),
            countryIos2: (value) => null,
          ),
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
                        size: 40,
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
                ? InitLoader()
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
                                loggedInBussinessId: loggedInBussinessId,
                                bussinessId: data[index].bussiness,
                                profilePic: data[index].accountPic,
                                account: data[index].accountName,
                                location: data[index].businessLocation,
                              ),
                              PostSection(
                                postImage: data[index].productPhoto,
                                activeImage: (value) =>
                                    _changeActivePhoto(value),
                              ),
                              BottomSection(
                                  loggedInBussinessId: loggedInBussinessId,
                                  bussinessId: data[index].bussiness,
                                  postImage: data[index].productPhoto,
                                  activePhoto: activePhoto,
                                  callNo: data[index].callNumber,
                                  whatsapp: data[index].whatsappNumber),
                              PostDetails(caption: data[index].caption),
                            ],
                          ),
                        );
                      } else if (allProducts - data.length > 0) {
                        return Loader2();
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
