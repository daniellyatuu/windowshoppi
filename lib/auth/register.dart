import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:windowshoppi/location/flutter_google_places.dart';
import 'package:windowshoppi/utilities/constants.dart';
import 'dart:async';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyAQSCSiJMsoMca0n65p0vPv5Em8Uk8FjLQ";

// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _RegisterPageState extends State<RegisterPage> {
  bool isSubmitted = false;

  String _activeCountry = 'Tanzania';
  String _activeFlag = 'tz.png';
  String _activeLocation = 'search location';
  bool isLocationSelected = false;
  String latitude, longitude;
  String _countryIOS2 = 'tz';
  String _countryLanguage = 'en';

  String dropdownValue = 'One';

  String _activeCategory = 'select category';
  bool isCategorySelected = false;

  List<String> categories = [
    'Store',
    'Restaurant',
    'Hotel',
    'Game Center',
    'Internet Cafe',
    'Movie Point',
  ];

  final _registerFormKey = GlobalKey<FormState>();

  // form data
  String _businessName, _phoneNumber, _userName, _passWord;

  // Initially password is obscure
  bool _obscureText = true;

  Widget _buildBusinessNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
//        Text(
//          'Business Name',
//          style: kLabelStyle,
//        ),
//        SizedBox(
//          height: 8.0,
//        ),
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Business name',
              prefixIcon: Icon(Icons.business),
              contentPadding: EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 10.0,
              ),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide: BorderSide(
                  color: Colors.teal[900],
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.teal[400],
                ),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'business name is required';
              }
              return null;
            },
            onSaved: (value) => _businessName = value,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'phone number',
              prefixIcon: Icon(Icons.phone),
              contentPadding: EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 10.0,
              ),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide: BorderSide(
                  color: Colors.teal[900],
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.teal[400],
                ),
              ),
            ),
            validator: (value) {
              String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
              RegExp regExp = new RegExp(pattern);
              if (value.isEmpty) {
                return 'phone number is required';
              } else if (!regExp.hasMatch(value)) {
                return 'Please enter valid phone number';
              }
              return null;
            },
            onSaved: (value) => _phoneNumber = value,
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
//        Text(
//          'Username',
//          style: kLabelStyle,
//        ),
//        SizedBox(
//          height: 8.0,
//        ),
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'username',
              prefixIcon: Icon(Icons.person_outline),
              contentPadding: EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 10.0,
              ),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide: BorderSide(
                  color: Colors.teal[900],
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.teal[400],
                ),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'username is required';
              } else if (value.length < 5) {
                return 'username must be greater than 5 character long';
              }
              return null;
            },
            onSaved: (value) => _userName = value,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: 'password',
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: _toggle,
                icon: _obscureText
                    ? Icon(
                        Icons.visibility_off,
                        color: Colors.grey,
                      )
                    : Icon(
                        Icons.visibility,
                        color: Colors.grey[700],
                      ),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 10.0,
              ),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide: BorderSide(
                  color: Colors.teal[900],
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.teal[400],
                ),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'password is required';
              } else if (value.length < 4) {
                return 'password must be greater than 4 character long';
              }
              return null;
            },
            onSaved: (value) => _passWord = value,
          ),
        ),
      ],
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget _buildSelectCountryDropDownF() {
    return GestureDetector(
      onTap: () async {
        var _selectedCountry = await showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 2,
              child: ListView(
                children: <Widget>[
                  Container(
                    color: Colors.teal,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    alignment: Alignment.center,
                    child: Text(
                      'Select Country',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(
                        {"flag": "tz.png", "name": "Tanzania", "iso2": "tz"},
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('images/flags/tz.png'),
                      ),
                      title: Text('Tanzania'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(
                        {"flag": "kenya.png", "name": 'Kenya', "iso2": "ke"},
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('images/flags/kenya.png'),
                      ),
                      title: Text('Kenya'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        if (_selectedCountry != null) {
          print(_selectedCountry['name']);
          setState(
            () {
              _activeFlag = _selectedCountry['flag'];
              _activeCountry = _selectedCountry['name'];

              // clear business location field
              _activeLocation = 'search location';

              // change search location coverage
              _countryIOS2 = _selectedCountry['iso2'];
            },
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 40.0,
                    child: Image.asset('images/flags/$_activeFlag'),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: Text(
                      '$_activeCountry',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationFT() {
    return GestureDetector(
      onTap: _searchLocation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
//            height: 50.0,

            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
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
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // LOCATION .START
  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
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

    displayPrediction(p, homeScaffoldKey.currentState);
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

  Widget _buildSelectCategoryDropDownF() {
    return GestureDetector(
      onTap: () async {
        var _selectedCategory = await showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 2,
              child: ListView(
                children: <Widget>[
                  Container(
                    color: Colors.teal,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    alignment: Alignment.center,
                    child: Text(
                      'Select Business Category',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  if (categories.length != 0)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(categories[index]);
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(categories[index][0].toUpperCase()),
                            ),
                            title: Text(categories[index]),
                          ),
                        );
                      },
                    ),
                  if (categories.length == 0)
                    Container(
                      padding: EdgeInsets.all(30.0),
                      alignment: Alignment.center,
                      child: Text(
                        'no registered category',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
        if (_selectedCategory != null) {
          print(_selectedCategory);
          setState(() {
            _activeCategory = _selectedCategory;
            isCategorySelected = true;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.category, color: Colors.grey),
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: isCategorySelected
                        ? Text(_activeCategory)
                        : Text(
                            _activeCategory,
                            style: TextStyle(color: Colors.grey),
                          ),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
              child: RaisedButton(
                onPressed: () {},
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    color: Colors.teal,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
              child: RaisedButton(
                onPressed: () {
//                  setState(() {
//                    isSubmitted = !isSubmitted;
//                  });
                  if (_registerFormKey.currentState.validate()) {
                    _registerFormKey.currentState.save();

                    if (_activeCountry != null) {
                      if (isLocationSelected) {
                        if (isCategorySelected) {
                          print('send data to http');
                          print(_businessName);
                          print(_phoneNumber);
                          print(_userName);
                          print(_passWord);
                          print(_activeCountry);
                          print(_activeLocation);
                          print(latitude);
                          print(longitude);
                        } else {
                          print('category is required');
                        }
                      } else {
                        print('business location is required');
                      }
                    } else {
                      print('country is required');
                    }
                  }
                },
                color: Colors.white,
                child: isSubmitted
                    ? Center(
                        child: SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                          ),
                        ),
                      )
                    : Text(
                        'REGISTER',
                        style: TextStyle(
                          color: Colors.teal,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Center(
                child: Form(
                  key: _registerFormKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _buildBusinessNameTF(),
                            SizedBox(
                              height: 25.0,
                            ),
                            _buildPhoneNumberTF(),
                            SizedBox(
                              height: 25.0,
                            ),
                            _buildUsernameTF(),
                            SizedBox(
                              height: 25.0,
                            ),
                            _buildPasswordTF(),
                            SizedBox(
                              height: 25.0,
                            ),
                            _buildSelectCountryDropDownF(),
                            SizedBox(
                              height: 25.0,
                            ),
                            _buildLocationFT(),
                            SizedBox(
                              height: 25.0,
                            ),
                            _buildSelectCategoryDropDownF(),
                            SizedBox(
                              height: 25.0,
                            ),
                            _buildRegisterBtn(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
