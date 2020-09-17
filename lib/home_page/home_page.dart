import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/Provider.dart';
import 'package:windowshoppi/managers/NavigationManager.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/models/local_storage_keys.dart';
import 'package:windowshoppi/models/product.dart';
import 'package:windowshoppi/products/details/details.dart';
import 'package:windowshoppi/drawer/app_drawer.dart';
import 'package:windowshoppi/myappbar/select_country.dart';
import 'package:windowshoppi/routes/fade_transition.dart';
import 'package:windowshoppi/services/CountProductsCubit.dart';
import 'package:windowshoppi/services/ProductNextUrlCubit.dart';
import 'package:windowshoppi/product_category/product_category.dart';
import 'package:windowshoppi/widgets/loader.dart';
import 'package:windowshoppi/services/product_service.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductNextUrl>(
          create: (BuildContext context) => ProductNextUrl(),
        ),
        BlocProvider<CountProductsCubit>(
          create: (BuildContext context) => CountProductsCubit(),
        ),
      ],
      child: ProductList(),
    );
  }
}

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = ScrollController();

  var data = new List<Product>();
  String nextUrl = '';
  int allProducts;
  bool removeListData, _isGettingServerData, firstLoading;
  bool _isInitialLoading = true;
  int activeCategory = 0;

  int loggedInBussinessId = 0;

  Future _getProduct(url, removeListData, category, firstLoading) async {
    setState(() {
      _isInitialLoading = firstLoading ? true : false;
      _isGettingServerData = true;
    });

    var res = await fetchProduct(context, url, category, firstLoading);

    /// add new data to list
    if (removeListData) {
      data = res;
    } else {
      data = data + res;
    }

    setState(() {
      _isInitialLoading = false;
      _isGettingServerData = false;
    });
  }

  _isUserLoggedIn() async {
    // get bussiness_id if user loggedIn
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var _businessId = localStorage.getInt(businessId);
    if (_businessId != null) {
      setState(() {
        loggedInBussinessId = _businessId;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getProduct(ALL_PRODUCT_URL, removeListData = true, activeCategory,
        firstLoading = true);
    _isUserLoggedIn();

    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (nextUrl != 'null' && _isGettingServerData == false) {
            _getProduct(nextUrl, removeListData = false, activeCategory,
                firstLoading = false);
          }
        }
      },
    );
  }

  Future<void> refresh() async {
    await Future.delayed(Duration(milliseconds: 700));

    _getProduct(ALL_PRODUCT_URL, removeListData = true, activeCategory,
        firstLoading = true);
  }

  Future<void> refreshOnChangeCountry() async {
    _getProduct(ALL_PRODUCT_URL, removeListData = true, activeCategory,
        firstLoading = true);
  }

  Future<void> filterProductByCategory(id) async {
    setState(() {
      activeCategory = id;
    });
    _getProduct(ALL_PRODUCT_URL, removeListData = true, activeCategory,
        firstLoading = true);
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

  // void _scrollOnTop() {
  //   if (_scrollController.hasClients) {
  //     _scrollController.animateTo(0,
  //         duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  //   }
  // }

  void _scrollOnTop(manager) async {
    if (_scrollController.hasClients) {
      await _scrollController.animateTo(0,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      manager.changePage('');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    NavigationManager manager = Provider.of(context).fetch(NavigationManager);
    manager.index$.listen((index) {
      if (index == 'homeTop') {
        _scrollOnTop(manager);
      }
    });

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'windowshoppi ',
          // style: TextStyle(fontFamily: 'Itim'),
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
            BlocBuilder<ProductNextUrl, String>(
              builder: (context, state) {
                if (state != 'no_more_product') {
                  nextUrl = state;
                } else {
                  nextUrl = 'null';
                }

                return Visibility(
                  visible: false,
                  child: Center(
                    child: Text(''),
                  ),
                );
              },
            ),
            BlocBuilder<CountProductsCubit, int>(
              builder: (context, state) {
                allProducts = state;
                return Visibility(
                  visible: false,
                  child: Center(child: Text('')),
                );
              },
            ),

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
                                  _getProduct(
                                      ALL_PRODUCT_URL,
                                      removeListData = true,
                                      activeCategory,
                                      firstLoading = true);
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
                                        onTap: () async {
                                          var res = await Navigator.push(
                                            context,
                                            FadeRoute(
                                              widget: Details(
                                                  loggedInBussinessId:
                                                      loggedInBussinessId,
                                                  singlePost: data[index]),
                                            ),
                                          );
                                          if (res == 'deleted') {
                                            setState(() {
                                              allProducts = allProducts - 1;
                                              data.remove(data[index]);
                                            });
                                            _notification(
                                                'post deleted successfully',
                                                Colors.black,
                                                Colors.red);
                                          } else if (res == 'updated') {
                                            refresh();
                                          }
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
