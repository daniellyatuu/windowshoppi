import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/models/country.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/models/local_storage_keys.dart';
import 'package:windowshoppi/models/product.dart';
import 'package:windowshoppi/products/details/details.dart';
import 'package:windowshoppi/products/products.dart';
import 'package:windowshoppi/drawer/app_drawer.dart';
import 'package:windowshoppi/myappbar/select_country.dart';
import 'package:windowshoppi/routes/fade_transition.dart';
import 'package:windowshoppi/utilities/database_helper.dart';
import 'package:windowshoppi/product_category/product_category.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/widgets/loader.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper.instance;

  ScrollController _scrollController = ScrollController();

  var data = new List<Product>();
  String newUrl, nextUrl;
  bool removeListData, _isGettingServerData, firstLoading;
  bool _isInitialLoading = true;
  int activeCategory = 0;
  int allProducts = 0;
  int loggedInBussinessId = 0;

  @override
  void dispose() {
    // TODO: implement dispose
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
//      print(data.length);
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

  Future<void> refresh() async {
    await Future.delayed(Duration(milliseconds: 700));

    fetchProduct(ALL_PRODUCT_URL, removeListData = true, firstLoading = true,
        activeCategory);
  }

  Future<void> refreshOnChangeCountry() async {
    fetchProduct(ALL_PRODUCT_URL, removeListData = true, firstLoading = true,
        activeCategory);
  }

  Future<void> filterProductByCategory(id) async {
    setState(() {
      activeCategory = id;
    });
    fetchProduct(
        ALL_PRODUCT_URL, removeListData = true, firstLoading = true, id);
  }

//  void _getAllCountry() async {
//    final allRows = await dbHelper.queryAllRows();
//    allRows.forEach(
//      (row) => print(row),
//    );
//  }

  // get active bussiness id for loggedInUser

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'windowshoppi ',
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ProductCategory(
                onFetchingData: (categoryId) =>
                    filterProductByCategory(categoryId)),

//                  Products(products: data),
            _isInitialLoading
                ? Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: InitLoader(),
                    ),
                  )
                : _isGettingServerData == false && data.length == 0
                    ? Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  fetchProduct(
                                      ALL_PRODUCT_URL,
                                      removeListData = true,
                                      firstLoading = true,
                                      activeCategory);
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
                        ),
                      )
                    : Expanded(
                        child: Container(
                          child: StaggeredGridView.countBuilder(
                              physics: BouncingScrollPhysics(),
                              controller: _scrollController,
                              crossAxisCount: 2,
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 1,
                              itemCount: data == null
                                  ? 0
                                  : allProducts - data.length > 0
                                      ? data.length + 3
                                      : data.length,
                              itemBuilder: (context, index) {
                                if (index < data.length) {
                                  return Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(6.0)),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            FadeRoute(
                                              widget: Details(
                                                  loggedInBussinessId:
                                                      loggedInBussinessId,
                                                  singlePost: data[index]),
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: <Widget>[
                                            CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: data[index]
                                                  .productPhoto[0]
                                                  .filename,
                                              progressIndicatorBuilder: (context,
                                                      url, downloadProgress) =>
                                                  CupertinoActivityIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                            if (data[index]
                                                    .productPhoto
                                                    .toList()
                                                    .length !=
                                                1)
                                              Positioned(
                                                top: 6.0,
                                                right: 6.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  ),
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    '${data[index].productPhoto.toList().length - 1}+',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10.0),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else if (allProducts - data.length > 0) {
                                  return Loader1();
                                } else {
                                  return null;
                                }
                              },
                              staggeredTileBuilder: (index) {
                                return StaggeredTile.count(
                                    1, index.isEven ? 1.0 : 1.3);
                              }),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
