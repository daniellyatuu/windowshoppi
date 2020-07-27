import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:windowshoppi/models/country.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/models/product.dart';
import 'package:windowshoppi/products/products.dart';
import 'package:windowshoppi/drawer/app_drawer.dart';
import 'package:windowshoppi/myappbar/select_country.dart';
import 'package:windowshoppi/utilities/database_helper.dart';
import 'package:windowshoppi/product_category/product_category.dart';
import 'package:http/http.dart' as http;

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
  bool _isInitialLoading = true,
      _isLoadingMoreData = true,
      _isFilterByCategory = false,
      _isFilterByCategoryLoading = false;
  int activeCategory = 0;

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

          if (nextUrl == null) {
            setState(() {
              print('remove load more indicator');
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

    print(newUrl);

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
      print(data.length);
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

  Future<void> filterProductByCategory(id) async {
    setState(() {
      _isLoadingMoreData = true;
      activeCategory = id;
    });
    fetchProduct(
        ALL_PRODUCT_URL, removeListData = true, firstLoading = true, id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'windowshoppi ',
          style: TextStyle(fontFamily: 'Itim'),
        ),
        actions: <Widget>[
          SelectCountry(onCountryChanged: () => refreshOnChangeCountry()),
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
                ? Center(
                    child: CircularProgressIndicator(strokeWidth: 2.0),
                  )
                : _isGettingServerData == false && data.length == 0
                    ? Center(
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
                                  : _isLoadingMoreData
                                      ? data.length + 1
                                      : data.length,
                              itemBuilder: (context, index) {
                                if (index < data.length) {
                                  return InkWell(
                                    onTap: () {
//                  Navigator.push(
//                    context,
//                    FadeRoute(
//                      widget: Details(imageUrl: imageList[imageUrl]),
//                    ),
//                  );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6.0)),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: data[index]
                                              .productPhoto[0]
                                              .filename,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              CupertinoActivityIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
//
                                      ),
                                    ),
                                  );
                                } else if (_isLoadingMoreData &&
                                    data.length >= 15) {
                                  return CupertinoActivityIndicator();
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
