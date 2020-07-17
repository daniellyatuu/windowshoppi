import 'package:flutter/cupertino.dart';
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

  // validate username
  bool _isUsernameLoading = false;
  bool _isUsernameGood = false;

  // for country
  String _activeCountry = "Tanzania";
  String _countryIOS2 = 'tz';
  String _countryLanguage = 'en';
  List<Map> _country = [
    {
      "id": 1,
      "name": "Tanzania",
      "image": "images/flags/tz.png",
      "ios2": "tz",
      "language": "en",
    },
    {
      "id": 2,
      "name": "Kenya",
      "image": "images/flags/kenya.png",
      "ios2": "ke",
      "language": "en",
    },
  ];

  // for location
  String _activeLocation = 'enter location';
  bool isLocationSelected = false;
  bool _showLocationError = false;
  String latitude, longitude;

  // for category
  String _activeCategory;
  int _activeCategoryId;
  bool isCategorySelected = false;
  List<Map> _category = [
    {
      "id": 1,
      "name": "Store",
    },
    {
      "id": 2,
      "name": "Hotel",
    },
    {
      "id": 3,
      "name": "Game Center",
    },
    {
      "id": 4,
      "name": "Restaurant",
    },
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
//                borderSide: BorderSide(
//                  color: Colors.teal[900],
//                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
//                borderSide: BorderSide(
//                  color: Colors.teal[400],
//                ),
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

//              if (value.isEmpty) {
//                return 'phone number is required';
//              } else if (regExp.hasMatch(value) || value == 'daniel') {
//                return 'good';
//              }
//              return 'please enter valid phone number';
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
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'username',
              prefixIcon: Icon(Icons.person_outline),
              suffixIcon: _isUsernameLoading
                  ? CupertinoActivityIndicator()
                  : _isUsernameGood
                      ? Icon(
                          Icons.check,
                          color: Colors.teal,
                          size: 20,
                        )
                      : null,
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
            onChanged: (value) {
              setState(() {
                _isUsernameLoading = true;
              });
              Timer(Duration(seconds: 1), () {
                print(value);
                setState(() {
                  _isUsernameLoading = false;
                });

                if (value.length > 5) {
                  setState(() {
                    _isUsernameGood = true;
                  });
                } else if (value.length == 0) {
                  _isUsernameLoading = false;
                  _isUsernameGood = false;
                } else {
                  setState(() {
                    _isUsernameGood = false;
                  });
                }
              });
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
    return Container(
      decoration: kBoxDecorationStyle,
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          isDense: true,
          hint: Text('select country'),
          value: _activeCountry,
          onChanged: (String newValue) {
            setState(() {
              _activeCountry = newValue;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'country is required';
            }
            return null;
          },
          onSaved: (value) => _activeCountry = value,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          items: _country.map(
            (Map map) {
              return DropdownMenuItem<String>(
                onTap: () {
                  setState(() {
                    // clear business location field
                    _activeLocation = 'search location';

                    // change search location coverage
                    _countryIOS2 = map["ios2"];
                  });
                },
                value: map["name"].toString(),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 40.0,
                      child: Image.asset('${map["image"]}'),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      child: Text(map["name"]),
                    ),
                  ],
                ),
              );
            },
          ).toList(),
        ),
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
          Visibility(
            visible: _showLocationError,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
              child: Text(
                'location is required',
                style: TextStyle(color: Colors.red[400]),
              ),
            ),
          )
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
        _showLocationError = false;
      });
//      scaffold.showSnackBar(
//        SnackBar(content: Text("${p.description} - $lat/$lng")),
//      );
    }
  }
  // LOCATION .END

  Widget _buildSelectCategoryDropDownF() {
    return Container(
      decoration: kBoxDecorationStyle,
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          isDense: true,
          hint: Text('select business category'),
          value: _activeCategory,
          onChanged: (String newValue) {
            setState(() {
              _activeCategory = newValue;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'business category is required';
            }
            return null;
          },
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          items: _category.map(
            (Map map) {
              return DropdownMenuItem<String>(
                onTap: () {
                  setState(() {
                    _activeCategoryId = map["id"];
                  });
                },
                value: map["name"].toString(),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.category,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      child: Text(map["name"]),
                    ),
                  ],
                ),
              );
            },
          ).toList(),
        ),
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
                  if (_registerFormKey.currentState.validate()) {
                    _registerFormKey.currentState.save();

                    if (isLocationSelected) {
                      print('send data to http');
                      print(_businessName);
                      print(_phoneNumber);
                      print(_userName);
                      print(_passWord);
                      print(_activeCountry);
                      print(_activeCategory);
                      print(_activeCategoryId);
                      print(_activeLocation);
                      print(latitude);
                      print(longitude);
                    } else {
                      setState(() {
                        _showLocationError = true;
                      });
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
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        child: Text(
                          'create your business account',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 20.0),
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
