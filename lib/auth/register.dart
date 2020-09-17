import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:windowshoppi/location/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:windowshoppi/models/category_model.dart';
import 'package:windowshoppi/models/country.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/models/local_storage_keys.dart';
import 'package:windowshoppi/utilities/constants.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/utilities/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

const kGoogleApiKey = "AIzaSyAQSCSiJMsoMca0n65p0vPv5Em8Uk8FjLQ";

// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class RegisterPage extends StatefulWidget {
  final Function(bool) isLoginStatus;
  RegisterPage({@required this.isLoginStatus});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _RegisterPageState extends State<RegisterPage> {
  final dbHelper = DatabaseHelper.instance;

  var country = new List<Country>();

  bool _isSubmitting = false;

  // validate username
  bool _isUsernameLoading = false;
  bool _isUsernameGood = false;
  bool _isUserExists = false;

  // for country
  bool _countryIsLoading = true;
//  String _activeCountry = "Tanzania";
//  String _countryIOS2 = 'tz';
//  String _countryLanguage = 'en';

  String _activeCountry;
  String _activeCountryId;
  String _countryIOS2;
  String _countryLanguage;

  // for location
  String _activeLocation = 'enter location';
  bool isLocationSelected = false;
  bool _showLocationError = false;
  String latitude, longitude;

  // for category
  var categories = new List<Category>();
  bool _categoryIsLoading = false;
  String _activeCategoryId;

  final _registerFormKey = GlobalKey<FormState>();

  // form data
  String _businessName, _phoneNumber, _userName, _passWord;

  // Initially password is obscure
  bool _obscureText = true;

  Widget _buildBusinessNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
              focusedBorder: kFocusedBorder,
              enabledBorder: kEnabledBorder,
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
              focusedBorder: kFocusedBorder,
              enabledBorder: kEnabledBorder,
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
              focusedBorder: kFocusedBorder,
              enabledBorder: kEnabledBorder,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'username is required';
              } else if (value.length < 5) {
                return 'username must be greater than 5 character long';
              } else {
                var data = value.trim();
                if (data.contains(' ')) {
                  return 'space between username is not required';
                }
              }
              return null;
            },
            onChanged: (value) async {
              setState(() {
                _isUsernameLoading = true;
                _isUserExists = false;
              });
              // check validation .start
              var data = value.trim();
              if (data.length >= 5 && !data.contains(' ')) {
                var usernameData = {
                  'username': data,
                };
                var res = await _checkUsername(usernameData);

                if (res['user_exists'] == true) {
                  _isUsernameGood = false;
                  _isUserExists = true;
                } else {
                  _isUserExists = false;
                  _isUsernameGood = true;
                }
              } else if (value.length == 0) {
                _isUsernameGood = false;
                _isUserExists = false;
              } else {
                _isUsernameGood = false;
              }

              setState(() {
                _isUsernameLoading = false;
              });

//              if (value.length > 5) {
//                setState(() {
//                  _isUsernameGood = true;
//                });
//              } else if (value.length == 0) {
//                _isUsernameLoading = false;
//                _isUsernameGood = false;
//              } else {
//                setState(() {
//                  _isUsernameGood = false;
//                });
//              }
            },
            onSaved: (value) => _userName = value,
          ),
        ),
        Visibility(
          visible: _isUserExists ? true : false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Text(
              'username already exists',
              style: TextStyle(color: Colors.red[400], fontSize: 12.0),
            ),
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
              focusedBorder: kFocusedBorder,
              enabledBorder: kEnabledBorder,
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
          value: _activeCountryId,
          onChanged: (String newValue) {
            setState(() {
              _activeCountryId = newValue;
            });
            FocusScope.of(context).requestFocus(FocusNode());
          },
          validator: (value) {
            if (value == null) {
              return 'country is required';
            }
            return null;
          },
          onSaved: (value) => _activeCountryId = value,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          items: country.map(
            (Country map) {
              return DropdownMenuItem<String>(
                onTap: () {
                  setState(() {
                    // clear location field
                    _activeLocation = 'search location';
                    isLocationSelected = false;

                    // update active country
                    _activeCountry = map.countryName;
                    _countryIOS2 = map.ios2;
                    _countryLanguage = map.language;
                  });
                },
                value: map.id.toString(),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 40.0,
                      child: Image.network('${SERVER_NAME + map.flag}'),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      child: Text(map.countryName),
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
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        _searchLocation();
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
          Visibility(
            visible: _showLocationError,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
              child: Text(
                'location is required',
                style: TextStyle(color: Colors.red[400], fontSize: 12.0),
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
          hint: Text('select category'),
          onChanged: (String newValue) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          validator: (value) {
            if (value == null) {
              return 'category is required';
            }
            return null;
          },
          onSaved: (value) => _activeCategoryId = value,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          items: categories.map(
            (Category map) {
              return DropdownMenuItem<String>(
                value: map.id.toString(),
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
                      child: Text(map.title),
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
      width: double.infinity,
      child: AbsorbPointer(
        absorbing: _isSubmitting ? true : false,
        child: RaisedButton(
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());

            if (_registerFormKey.currentState.validate()) {
              _registerFormKey.currentState.save();

              if (isLocationSelected) {
                // default group id = 3
                // 3 = stand for vendor
                var userInfo = {
                  'username': _userName,
                  'password': _passWord,
                  'group': 3,
                  'name': _businessName,
                  'category': _activeCategoryId,
                  'country': _activeCountryId,
                  'location_name': _activeLocation,
                  'lattitude': latitude,
                  'longitude': longitude,
                  'call': _phoneNumber,
                };

                setState(() {
                  _isSubmitting = true;
                });

                await _createUser(userInfo);

                setState(() {
                  _isSubmitting = false;
                });
              } else {
                setState(() {
                  _showLocationError = true;
                });
              }
            }
          },
          color: _isSubmitting ? Colors.grey[200] : Colors.white,
          child: _isSubmitting
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(strokeWidth: 1.0),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'please wait...',
                      style: TextStyle(
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
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
    );
  }

  Future _checkUsername(username) async {
    final response = await http.post(
      VALIDATE_USERNAME,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(username),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to validate username.');
    }
  }

  Future _createUser(userData) async {
//    await Future.delayed(Duration(milliseconds: 300));
    final response = await http.post(
      REGISTER_USER,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );

    var _user = json.decode(response.body);
    print(_user);

    if (_user['username'] != null) {
      if (_user['username'][0] == 'user with this username already exists.') {
        setState(() {
          _isUserExists = true;
        });
      }
    } else if (response.statusCode == 201) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      if (_user['response'] == 'success') {
        localStorage.setBool(isRegistered, true);
        localStorage.setString(userToken, _user['token']);
        localStorage.setInt(businessId, _user['business_id']);
        localStorage.setString(businessName, _user['business_name']);
        localStorage.setString(businessLocation, _user['business_location']);
        localStorage.setString(bio, _user['bio']);
        localStorage.setString(whatsapp, _user['whatsapp']);
        localStorage.setString(callNumber, _user['call']);
        localStorage.setString(profileImage, _user['profile_image']);
        localStorage.setString(userMail, _user['email']);
        widget.isLoginStatus(true);
      }
    } else {
      setState(() {
        _isSubmitting = false;
      });
      throw Exception('Failed to register user.');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // get countries
    _fetchCountry();

    //get categories
    _fetchCategory();
  }

  Future _fetchCountry() async {
    setState(() {
      _countryIsLoading = true;
    });

    /// check if country data available on local
    final allRows = await dbHelper.queryAllRows();
//    print(allRows);
    if (allRows.length == 0) {
//      print('step 3: get countries from server');
      final response = await http.get(ALL_COUNTRY_URL);
      if (response.statusCode == 200) {
        var countryData = json.decode(response.body);

        // save data locally
        await _insert(countryData);
        _getActiveCountry();

        setState(() {
          Iterable list = countryData;
          country = list.map((model) => Country.fromJson(model)).toList();
        });
      } else {
        throw Exception('failed to load data from internet');
      }
    } else {
//      print('step 3: insert countries from local db to variable list');
      setState(() {
        Iterable list = allRows;
        country = list.map((model) => Country.fromJson(model)).toList();
      });
      _getActiveCountry();
    }

//    print(country);
    setState(() {
      _countryIsLoading = false;
    });
  }

  _insert(data) async {
//    print('step 4: save all country data from server');
    var savedId = await dbHelper.insertCountryData(data);
//    print('step 6: receive saved ids');

//    print('step 7: save first id to user table');
    await _insertUser(savedId[0]);
  }

  _insertUser(data) async {
    // user data
    Map<String, dynamic> row = {
      DatabaseHelper.table_1ColumnName: 'username',
      DatabaseHelper.table_1ColumnCountryId: data
    };
//    print('step 8: pass userdata to db');
    await dbHelper.insertUserData(row);
  }

  void _getActiveCountry() async {
//    print('step 4: get active country');

    var activeCountryData = await dbHelper.getActiveCountryFromUserTable();
//    print('step 8: receive active country ##LAST STEP##');

    setState(() {
      if (activeCountryData != null) {
        _activeCountry = activeCountryData['name'];
        _activeCountryId = activeCountryData['id'].toString();
        _countryIOS2 = activeCountryData['ios2'];
        _countryLanguage = activeCountryData['language'];
      }
    });
  }

  Future _fetchCategory() async {
    setState(() {
      _categoryIsLoading = true;
    });

    final response = await http.get(ALL_CATEGORY);
//    print(response.statusCode);

    if (response.statusCode == 200) {
      var categoryData = json.decode(response.body);

      setState(() {
        Iterable _list = categoryData['results'];

        categories = _list.map((model) => Category.fromJson(model)).toList();
      });
    } else {
      throw Exception('failed to load data from internet');
    }

    setState(() {
      _categoryIsLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      body: Builder(builder: (_) {
        if (_countryIsLoading || _categoryIsLoading) {
          return Center(
            child: SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(strokeWidth: 2.0),
            ),
          );
        }
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Form(
                    key: _registerFormKey,
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                          child: Text(
                            'Create a business account',
                            style: TextStyle(fontSize: 21),
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
        );
      }),
    );
  }
}
