import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/models/category_model.dart';
import 'package:windowshoppi/models/local_storage_keys.dart';
import 'package:windowshoppi/models/product.dart';
import 'package:windowshoppi/myappbar/select_country.dart';
import 'package:windowshoppi/location/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:async';
import 'package:windowshoppi/models/global.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/products/details/details.dart';
import 'package:windowshoppi/routes/fade_transition.dart';
import 'dart:convert';
import 'package:windowshoppi/utilities/database_helper.dart';
import 'package:windowshoppi/widgets/loader.dart';
import 'category_product.dart';

const kGoogleApiKey = "AIzaSyAQSCSiJMsoMca0n65p0vPv5Em8Uk8FjLQ";

// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

final searchScaffoldKey = GlobalKey<ScaffoldState>();

class _SearchState extends State<Search> {
  final dbHelper = DatabaseHelper.instance;

  final _searchField = TextEditingController();

  bool removeListData, _isGettingServerData, firstLoading;
  bool _isInitialLoading = true,
      _searchOnProgress = false,
      _isLoadingMoreData = true;
  String newUrl, nextUrl;
  int loggedInBussinessId = 0;
  var categories = new List<Category>();

  int allProducts = 0;

  // for search .start
  // ################
  // ################

  String searchNewUrl, searchNextUrl;
  bool searchRemoveList, _searchGettingServerData, searchFirstLoading;
  bool _isTypingOnSearchField = false;
  bool _searchIsInitialLoading = false, _searchIsLoadingMoreData = true;
  var products = new List<Product>();

  // ################
  // ################
  // for search .end

  ScrollController _scrollController = ScrollController();
  ScrollController _productScrollController = ScrollController();

  dispose() {
    super.dispose();
    _scrollController.dispose();
    _productScrollController.dispose();
    _searchField.dispose();
  }

  // for country
  String _countryIOS2;
  String _countryLanguage = 'en';

  // for location
  String _activeLocation = 'filter by location';
  bool isLocationSelected = false;
  String latitude, longitude;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    print('search');

    fetchAllCategory(ALL_CATEGORY, removeListData = true, firstLoading = true);

    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (nextUrl != null && _isGettingServerData == false) {
            fetchAllCategory(
                nextUrl, removeListData = false, firstLoading = false);
          }

          if (nextUrl == null) {
            setState(() {
              _isLoadingMoreData = false;
            });
          }
        }
      },
    );

    // product scroll
    _productScrollController.addListener(
      () {
        if (_productScrollController.position.pixels ==
            _productScrollController.position.maxScrollExtent) {
//
          if (searchNextUrl != null && _searchGettingServerData == false) {
            searchPost('next_request', searchNextUrl, searchRemoveList = false,
                searchFirstLoading = false);
          }
        }
      },
    );
  }

  Future fetchAllCategory(url, removeListData, firstLoading) async {
    setState(() {
      _isInitialLoading = firstLoading ? true : false;
      _isGettingServerData = true;
    });

    newUrl = url;

    final response = await http.get(newUrl);
//    print(response.statusCode);
//
    if (response.statusCode == 200) {
      var categoryData = json.decode(response.body);
      nextUrl = categoryData['next'];

      setState(() {
        Iterable list = categoryData['results'];

        if (removeListData) {
          categories = list.map((model) => Category.fromJson(model)).toList();
        } else {
          categories
              .addAll(list.map((model) => Category.fromJson(model)).toList());
        }
      });
//      print(categories);
    } else {
      throw Exception('failed to load data from internet');
    }

    setState(() {
      _isInitialLoading = false;
      _isGettingServerData = false;
    });
  }

  Future searchPost(keyword, url, searchRemoveList, searchFirstLoading) async {
    keyword = keyword.trim(); // remove white space from keyword
    if (keyword != '') {
      setState(() {
        _searchOnProgress = true;
        _searchIsInitialLoading = searchFirstLoading ? true : false;
        _searchGettingServerData = true;
      });

      if (keyword == 'next_request') {
        searchNewUrl = url;
      } else {
        var country = await _activeCountry();

        searchNewUrl = url +
            '?country=' +
            country['id'].toString() +
            '&keyword=' +
            keyword.toString();
      }

      final response = await http.get(searchNewUrl);

      if (response.statusCode == 200) {
        var productData = json.decode(response.body);
        searchNextUrl = productData['next'];
        allProducts = productData['count'];

        // get bussiness_id if user loggedIn
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        var _businessId = localStorage.getInt(businessId);
        if (_businessId != null) {
          setState(() {
            loggedInBussinessId = _businessId;
          });
        }

        Iterable productList = productData['results'];

        setState(() {
          if (searchRemoveList) {
            products =
                productList.map((model) => Product.fromJson(model)).toList();
          } else {
            products.addAll(
                productList.map((model) => Product.fromJson(model)).toList());
          }
        });
      } else {
        throw Exception('failed to load data from internet');
      }
    } else {
      setState(() {
        _searchOnProgress = false;
        _searchIsInitialLoading = false;
        _searchGettingServerData = false;
      });
    }

    setState(() {
      _searchIsInitialLoading = false;
      _searchGettingServerData = false;
    });
  }

  _activeCountry() async {
    var activeCountryData = await dbHelper.getActiveCountryFromUserTable();
    return activeCountryData;
  }

  Future<void> setActiveIos2(value) async {
    setState(() {
      _countryIOS2 = value;
    });
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
              onTap: _searchLocation,
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
                    Expanded(
                      child: isLocationSelected
                          ? Text(_activeLocation)
                          : Text(
                              _activeLocation,
                              style: TextStyle(color: Colors.grey),
                            ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.black54),
                  ],
                ),
              ),
            ),
          ),
          isLocationSelected
              ? IconButton(
                  onPressed: _clearLocation,
                  icon: Icon(Icons.clear),
                )
              : Text('')
        ],
      ),
    );
  }

  _clearSearchAndLocation() {
    setState(() {
      _searchOnProgress = false;
      isLocationSelected = false;
      _activeLocation = 'filter by location';
      _searchField.clear();
    });
  }

  _clearLocation() {
    setState(() {
      isLocationSelected = false;
      _activeLocation = 'filter by location';
    });
  }

  // LOCATION .START
  void onError(PlacesAutocompleteResponse response) {
    searchScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<void> _searchLocation() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: Mode.overlay,
//      mode: _mode,
      language: _countryLanguage,
      components: [Component(Component.country, _countryIOS2)],
    );

    displayPrediction(p, searchScaffoldKey.currentState);
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      setState(() {
        _activeLocation = p.description;
        latitude = lat.toString();
        longitude = lng.toString();
        isLocationSelected = true;
      });
//      scaffold.showSnackBar(
//        SnackBar(content: Text("${p.description} - $lat/$lng")),
//      );
    }
  }

  // LOCATION .END

  Widget _popularText() {
    return _isInitialLoading == false
        ? Container(
            padding: EdgeInsets.only(top: 10, left: 8.0, bottom: 10.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Popular on windowshoppi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          )
        : Text('');
  }

  Widget _allCategory() {
    return _isInitialLoading
        ? Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Center(
              child: SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2.0),
              ),
            ),
          )
        : _buildCategories();
  }

  Widget _buildCategories() {
    return Expanded(
      child: ListView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 5.0,
              children: categories
                  .map(
                    (item) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          FadeRoute(
                            widget: CategoryProduct(categoryData: item),
                          ),
                        );
                      },
                      child: Chip(
                        label: Text(item.title),
                      ),
                    ),
                  )
                  .toList()
                  .cast<Widget>(),
            ),
          ),
          if (_isLoadingMoreData && categories.length >= 40)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 18.0,
                    width: 18.0,
                    child: CircularProgressIndicator(strokeWidth: 1.0),
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
            ),
        ],
      ),
    );
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
            onCountryChanged: () => _clearSearchAndLocation(),
            countryIos2: (value) => setActiveIos2(value),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _searchField,
            onChanged: (keyword) => searchPost(keyword, SEARCH_POST,
                searchRemoveList = true, searchFirstLoading = true),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'search',
            ),
          ),
//          _locationFT(),
          if (_searchOnProgress == false)
            _popularText(),
          _searchOnProgress
              ? _searchIsInitialLoading
                  ? Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Center(
                        child: SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.0),
                        ),
                      ),
                    )
                  : products.length == 0 && _searchOnProgress == true
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(
                              'No Post',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Expanded(
                          child: Container(
                            child: StaggeredGridView.countBuilder(
                                physics: BouncingScrollPhysics(),
                                controller: _productScrollController,
                                crossAxisCount: 2,
                                crossAxisSpacing: 1,
                                mainAxisSpacing: 1,
                                itemCount: products == null
                                    ? 0
                                    : allProducts - products.length > 0
                                        ? products.length + 3
                                        : products.length,
                                itemBuilder: (context, index) {
                                  if (index < products.length) {
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
                                                    singlePost:
                                                        products[index]),
                                              ),
                                            );
                                          },
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: <Widget>[
                                              CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: products[index]
                                                    .productPhoto[0]
                                                    .filename,
                                                progressIndicatorBuilder: (context,
                                                        url,
                                                        downloadProgress) =>
                                                    CupertinoActivityIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                              if (products[index]
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
                                                    padding:
                                                        EdgeInsets.all(5.0),
                                                    child: Text(
                                                      '${products[index].productPhoto.toList().length - 1}+',
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
                                  } else if (allProducts - products.length >
                                      0) {
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
                        )
              : _allCategory(),
        ],
      ),
    );
  }
}
