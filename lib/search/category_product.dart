import 'dart:convert';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:windowshoppi/models/category_model.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/models/product.dart';
import 'package:windowshoppi/utilities/database_helper.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/routes/fade_transition.dart';
import 'package:windowshoppi/products/details/details.dart';
import 'package:windowshoppi/widgets/loader.dart';

class CategoryProduct extends StatefulWidget {
  final Category categoryData;
  CategoryProduct({this.categoryData});

  @override
  _CategoryProductState createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  final dbHelper = DatabaseHelper.instance;

  ScrollController _scrollController = ScrollController();
  var data = new List<Product>();
  String newUrl, nextUrl;
  bool removeListData, _isGettingServerData, firstLoading;
  bool _isInitialLoading = true;
  int allProducts = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProduct(SEARCH_POST, removeListData = true, firstLoading = true,
        widget.categoryData.id);

    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (nextUrl != null && _isGettingServerData == false) {
            fetchProduct(nextUrl, removeListData = false, firstLoading = false,
                widget.categoryData.id);
          }
        }
      },
    );
  }

  dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future fetchProduct(url, removeListData, firstLoading, categoryId) async {
    setState(() {
      _isInitialLoading = firstLoading ? true : false;
      _isGettingServerData = true;
    });

    if (_isInitialLoading) {
      var country = await _activeCountry();
      newUrl =
          url + categoryId.toString() + '/?country=' + country['id'].toString();
    } else {
      newUrl = url;
    }

//    print(newUrl);

    final response = await http.get(newUrl);
//    print(response.statusCode);

    if (response.statusCode == 200) {
      var productData = json.decode(response.body);
      nextUrl = productData['next'];

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
//      print(nextUrl);
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

    fetchProduct(SEARCH_POST, removeListData = true, firstLoading = true,
        widget.categoryData.id);
  }

  Widget _locationFT() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
//              onTap: _searchLocation,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.location_on, color: Colors.grey),
                    SizedBox(
                      width: 15.0,
                    ),
//                    Expanded(
//                      child: isLocationSelected
//                          ? Text(_activeLocation)
//                          : Text(
//                        _activeLocation,
//                        style: TextStyle(color: Colors.grey),
//                      ),
//                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.black54),
                  ],
                ),
              ),
            ),
          ),
//          isLocationSelected
//              ? IconButton(
//            onPressed: _clearLocation,
//            icon: Icon(Icons.clear),
//          )
//              : Text('')
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryData.title),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
//          _locationFT(),
            _isInitialLoading
                ? Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.0),
                        ),
                      ),
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
                                      SEARCH_POST,
                                      removeListData = true,
                                      firstLoading = true,
                                      widget.categoryData.id);
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
                                                  singlePost: data[index]),
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: <Widget>[
                                            ExtendedImage.network(
                                              data[index]
                                                  .productPhoto[0]
                                                  .filename,
                                              cache: true,
                                              loadStateChanged:
                                                  (ExtendedImageState state) {
                                                switch (state
                                                    .extendedImageLoadState) {
                                                  case LoadState.loading:
                                                    return CupertinoActivityIndicator();
                                                    break;

                                                  ///if you don't want override completed widget
                                                  ///please return null or state.completedWidget
                                                  //return null;
                                                  //return state.completedWidget;
                                                  case LoadState.completed:
                                                    return ExtendedRawImage(
                                                      fit: BoxFit.cover,
                                                      image: state
                                                          .extendedImageInfo
                                                          ?.image,
                                                    );
                                                    break;
                                                  case LoadState.failed:
                                                    // _controller.reset();
                                                    return GestureDetector(
                                                      child: Center(
                                                        child:
                                                            Icon(Icons.refresh),
                                                      ),
                                                      onTap: () {
                                                        state.reLoadImage();
                                                      },
                                                    );
                                                    break;
                                                }
                                                return null;
                                              },
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
//
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
