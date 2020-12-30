import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/Provider.dart';
import 'package:windowshoppi/managers/NavigationManager.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/models/local_storage_keys.dart';
import 'package:windowshoppi/products/details/bottom_section.dart';
import 'package:windowshoppi/drawer/app_drawer.dart';
import 'package:windowshoppi/myappbar/select_country.dart';
import 'package:windowshoppi/src/utilities/database_helper.dart';
import 'package:windowshoppi/widgets/loader.dart';
import 'top_section.dart';
import 'post_section.dart';
import 'post_details.dart';
import 'package:windowshoppi/models/product.dart';
import 'package:http/http.dart' as http;

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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

  // String newCaption;
  //   // bool edited = false;
  //   // int editedId = 0;

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
    print('get data');
    print(newUrl);

    final response = await http.get(newUrl);

    print(response.statusCode);

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

  _removePost(value) async {
    setState(() {
      allProducts = allProducts - 1;
      data.remove(value);
    });
    _notification('post deleted successfully', Colors.black, Colors.red);
  }

  void _notification(String txt, Color bgColor, Color btnColor) {
    final snackBar = SnackBar(
      content: Text(txt),
      backgroundColor: bgColor,
      action: SnackBarAction(
        label: 'Hide',
        textColor: btnColor,
        onPressed: () {
          Scaffold.of(context).hideCurrentSnackBar();
        },
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldKey.currentState.showSnackBar(snackBar);
    });
  }

  // _updateCaption(value) async {
  //   if (value != null) {
  //     setState(() {
  //       editedId = value['id'];
  //       edited = true;
  //       newCaption = value['caption'];
  //     });
  //     _notification('post updated successfully', Colors.black, Colors.red);
  //   }
  // }

  void _scrollOnTop(manager) async {
    if (_scrollController.hasClients) {
      await _scrollController.animateTo(0,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      manager.changePage('');
    }
  }

  dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    NavigationManager manager = Provider.of(context).fetch(NavigationManager);
    manager.index$.listen((index) {
      if (index == 'exploreTop') {
        _scrollOnTop(manager);
      }
    });

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('windowshoppi'),
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
                : ListView.separated(
                    physics: BouncingScrollPhysics(),
                    controller: _scrollController,
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: data == null ? 0 : data.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < data.length) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            TopSection(
                              post: data[index],
                              loggedInBussinessId: loggedInBussinessId,
                              onDeletePost: (value) => _removePost(data[index]),
                              isDataUpdated: (value) =>
                                  value ? refresh() : null,
                            ),
                            PostSection(
                              postImage: data[index].productPhoto,
                              activeImage: (value) => _changeActivePhoto(value),
                            ),
                            BottomSection(
                                loggedInBussinessId: loggedInBussinessId,
                                bussinessId: data[index].bussiness,
                                postImage: data[index].productPhoto,
                                activePhoto: activePhoto,
                                callNo: data[index].callNumber,
                                whatsapp: data[index].whatsappNumber),
                            PostDetails(
                                username: data[index].username,
                                caption: data[index].caption),
                          ],
                        );
                      } else if (allProducts - data.length > 0) {
                        return Loader2();
                      } else {
                        return null;
                        // return Padding(
                        //   padding: EdgeInsets.symmetric(vertical: 10.0),
                        //   child: Center(
                        //     child: data.length > 15
                        //         ? Text(
                        //             'no more data',
                        //             style: TextStyle(color: Colors.teal),
                        //           )
                        //         : Text(''),
                        //   ),
                        // );
                      }
                    },
                  ),
      ),
    );
  }
}
