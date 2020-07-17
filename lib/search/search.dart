import 'package:flutter/material.dart';
import 'package:windowshoppi/models/category_model.dart';
import 'package:windowshoppi/myappbar/select_country.dart';
import 'package:windowshoppi/location/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:async';

const kGoogleApiKey = "AIzaSyAQSCSiJMsoMca0n65p0vPv5Em8Uk8FjLQ";

// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

final searchScaffoldKey = GlobalKey<ScaffoldState>();

class _SearchState extends State<Search> {
  // for country
  String _activeCountry = "Tanzania";
  String _countryIOS2 = 'tz';
  String _countryLanguage = 'en';

  // for location
  String _activeLocation = 'filter by location';
  bool isLocationSelected = false;
  String latitude, longitude;

  final _categories = [
    CategoryList(
      id: '1',
      title: 'all',
    ),
    CategoryList(
      id: '2',
      title: 'Stores',
    ),
    CategoryList(
      id: '3',
      title: 'Restaurants',
    ),
    CategoryList(
      id: '4',
      title: 'Hotels',
    ),
    CategoryList(
      id: '5',
      title: 'NightLife',
    ),
    CategoryList(
      id: '6',
      title: 'Game Center',
    ),
    CategoryList(
      id: '7',
      title: 'Lodge',
    ),
  ];

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

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Popular on windowshoppi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Wrap(
            spacing: 10.0,
            children: _categories
                .map(
                  (item) => Chip(
                    label: Text(item.title),
                  ),
                )
                .toList()
                .cast<Widget>(),
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
          SelectCountry(),
        ],
      ),
      body: ListView(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'search',
            ),
          ),
          _locationFT(),
          _buildCategories(),
        ],
      ),
    );
  }
}
