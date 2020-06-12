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
  String _countryIOS2 = 'tz';
  String _countryLanguage = 'en';

  final _registerFormKey = GlobalKey<FormState>();

  // Initially password is obscure
  bool _obscureText = true;

  Widget _buildBusinessNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Bussiness Name',
          style: kLabelStyle,
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            decoration: tFBoxDecorationStyle,
          ),
        ),
      ],
    );
  }

//  Widget _buildBusinessNameTF() {
//    return Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: <Widget>[
//        Text(
//          'Bussiness Name',
//          style: kLabelStyle,
//        ),
//        SizedBox(
//          height: 8.0,
//        ),
//        Container(
//          alignment: Alignment.centerLeft,
//          decoration: kBoxDecorationStyle,
//          height: 50.0,
//          child: TextFormField(
//            style: TextStyle(color: Colors.white),
//            decoration: InputDecoration(
//              border: InputBorder.none,
//              contentPadding: EdgeInsets.only(top: 14.0),
//              prefixIcon: Icon(
//                Icons.business,
//                color: Colors.white,
//              ),
//              hintText: 'bussiness name',
//              hintStyle: kHintTextStyle,
//            ),
//            validator: (value) {
//              if (value.isEmpty) {
//                return 'bussiness name is required';
//              }
//              return null;
//            },
//          ),
//        ),
//      ],
//    );
//  }

  Widget _buildPhoneNumberTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Phone Number',
          style: kLabelStyle,
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            style: TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.phone,
                color: Colors.white,
              ),
              hintText: 'phone number',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
          style: kLabelStyle,
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person_outline,
                color: Colors.white,
              ),
              hintText: 'username',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF(String title, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: kLabelStyle,
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            obscureText: _obscureText,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Colors.white,
              ),
              suffixIcon: IconButton(
                onPressed: _toggle,
                icon: _obscureText
                    ? Icon(
                        Icons.visibility_off,
                        color: Colors.grey,
                      )
                    : Icon(
                        Icons.visibility,
                        color: Colors.white,
                      ),
              ),
              suffixStyle: TextStyle(color: Colors.white),
              hintText: placeholder,
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  // Toggles the password show status
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
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 2,
              child: ListView(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Select Country',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(
                        {"flag": "tz.png", "name": "Tanzania", "iso2": "tz"},
                      );
                    },
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('images/flags/tz.png'),
                        ),
                        title: Text('Tanzania'),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(
                        {"flag": "kenya.png", "name": 'Kenya', "iso2": "ke"},
                      );
                    },
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('images/flags/kenya.png'),
                        ),
                        title: Text('Kenya'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        print(_selectedCountry['name']);
        setState(() {
          _activeFlag = _selectedCountry['flag'];
          _activeCountry = _selectedCountry['name'];

          // clear business location field
          _activeLocation = 'search location';

          // change search location coverage
          _countryIOS2 = _selectedCountry['iso2'];
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Select Country',
            style: kLabelStyle,
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
//            height: 50.0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 40.0,
                    child: Image.asset('images/flags/${_activeFlag}'),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: Text(
                      '$_activeCountry',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
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
          Text(
            'Bussiness Location',
            style: kLabelStyle,
          ),
          SizedBox(
            height: 8.0,
          ),
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
                  Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: Text(
                      _activeLocation,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
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
      print(p.description);
      setState(() {
        _activeLocation = p.description;
      });
//      scaffold.showSnackBar(
//        SnackBar(content: Text("${p.description} - $lat/$lng")),
//      );
    }
  }
  // LOCATION .END

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
                    print('send data to http');
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
      appBar: AppBar(
        title: Text('Register Bussiness Account'),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.teal[600],
                      Colors.teal[400],
                      Colors.teal[200],
                    ],
                  ),
                ),
              ),
              Center(
                child: Form(
                  key: _registerFormKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _buildBusinessNameTF(),
                            SizedBox(
                              height: 15.0,
                            ),
                            _buildPhoneNumberTF(),
                            SizedBox(
                              height: 15.0,
                            ),
                            _buildUsernameTF(),
                            SizedBox(
                              height: 15.0,
                            ),
                            _buildPasswordTF('Password', 'Enter password'),
                            SizedBox(
                              height: 15.0,
                            ),
                            _buildSelectCountryDropDownF(),
                            SizedBox(
                              height: 15.0,
                            ),
                            _buildLocationFT(),
                            SizedBox(
                              height: 15.0,
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
