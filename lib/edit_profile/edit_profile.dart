import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/models/local_storage_keys.dart';
import 'package:windowshoppi/src/utilities/constants.dart';
import 'package:windowshoppi/widgets/loader.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  final Function(bool) isUpdated;
  EditProfile({Key key, @required this.isUpdated}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _updateFormKey = GlobalKey<FormState>();

  String _businessName,
      _callPhoneNumber,
      _whatsappPhoneNumber,
      _emailAddress,
      _accountBio;
  bool isLoading = true;

  bool _isSubmitting = false;

  String name = '',
      userPhoneNumber = '',
      userWhatsappNumber = '',
      userEmailAddress = '',
      businessBio = '';

  Widget _updateBusinessNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Business Name',
              prefixIcon: Icon(Icons.business),
              contentPadding: EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 10.0,
              ),
              border: OutlineInputBorder(),
              focusedBorder: kFocusedBorder,
              enabledBorder: kEnabledBorder,
            ),
            initialValue: name,
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

  Widget _buildCallPhoneNumberTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Call Phone Number',
              prefixIcon: Icon(Icons.phone),
              contentPadding: EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 10.0,
              ),
              border: OutlineInputBorder(),
              focusedBorder: kFocusedBorder,
              enabledBorder: kEnabledBorder,
            ),
            initialValue: userPhoneNumber,
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
            onSaved: (value) => _callPhoneNumber = value,
          ),
        ),
      ],
    );
  }

  Widget _buildWhatsappPhoneNumberTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Whatsapp Phone Number',
              prefixIcon: Icon(Icons.phone),
              contentPadding: EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 10.0,
              ),
              border: OutlineInputBorder(),
              focusedBorder: kFocusedBorder,
              enabledBorder: kEnabledBorder,
            ),
            initialValue: userWhatsappNumber,
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
            onSaved: (value) => _whatsappPhoneNumber = value,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email Address',
              prefixIcon: Icon(Icons.email),
              contentPadding: EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 10.0,
              ),
              border: OutlineInputBorder(),
              focusedBorder: kFocusedBorder,
              enabledBorder: kEnabledBorder,
            ),
            initialValue: userEmailAddress,
            validator: (value) {
//              String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
              Pattern pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = new RegExp(pattern);
              RegExp regex = new RegExp(pattern);
              // if (value.isEmpty) {
              //   return 'email is required';
              // } else if (!regExp.hasMatch(value)) {
              //   return 'please enter valid email';
              // }

              if (value.isNotEmpty) {
                if (!regExp.hasMatch(value)) {
                  return 'please enter valid email';
                }
              }
              return null;
            },
            onSaved: (value) => _emailAddress = value,
          ),
        ),
      ],
    );
  }

  Widget _buildBioTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            maxLines: null,
            scrollPadding: EdgeInsets.all(10.0),
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: 'Account Bio',
              prefixIcon: Icon(Icons.text_fields),
              contentPadding: EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 10.0,
              ),
              border: OutlineInputBorder(),
              focusedBorder: kFocusedBorder,
              enabledBorder: kEnabledBorder,
            ),
            initialValue: businessBio,
            onSaved: (value) => _accountBio = value,
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateBtn() {
    return Container(
      width: double.infinity,
      child: AbsorbPointer(
        absorbing: _isSubmitting ? true : false,
        child: RaisedButton(
          onPressed: () async {
            if (_updateFormKey.currentState.validate()) {
              _updateFormKey.currentState.save();

              var userInfo = {
                'name': _businessName,
                'call': _callPhoneNumber,
                'whatsapp': _whatsappPhoneNumber,
                'email': _emailAddress,
                'bio': _accountBio,
              };

              setState(() {
                _isSubmitting = true;
              });

              await _updateProfile(userInfo);
              setState(() {
                _isSubmitting = false;
              });
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
                  'UPDATE',
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

  void _getUserData() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var _businessName = localStorage.getString(businessName);
    var _bio = localStorage.getString(bio);
    var _whatsapp = localStorage.getString(whatsapp);
    var _callNumber = localStorage.getString(callNumber);
    var _userEmailAddress = localStorage.getString(userMail);

    setState(() {
      name = _businessName;
      userPhoneNumber = _callNumber;
      userWhatsappNumber = _whatsapp;
      businessBio = _bio;
      userEmailAddress = _userEmailAddress;
      isLoading = false;
    });
  }

  Future _updateProfile(userData) async {
//    print(userData);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString(userToken);

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    };

    final response = await http.post(
      UPDATE_PROFILE,
      headers: headers,
      body: jsonEncode(userData),
    );

    var res = json.decode(response.body);
    print(res);

    if (response.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      if (res['response'] == 'success') {
        localStorage.setString(businessName, res['name']);
        localStorage.setString(whatsapp, res['whatsapp']);
        localStorage.setString(callNumber, res['call']);
        localStorage.setString(userMail, res['email']);
        localStorage.setString(bio, res['bio']);

        widget.isUpdated(true);
        Navigator.of(context).pop(); // close page
      }
    } else {
      throw Exception('Failed to update user.');
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: isLoading
          ? InitLoader()
          : Builder(builder: (_) {
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Form(
                          key: _updateFormKey,
                          child: ListView(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40.0, vertical: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _updateBusinessNameTF(),
                                    SizedBox(
                                      height: 25.0,
                                    ),
                                    _buildCallPhoneNumberTF(),
                                    SizedBox(
                                      height: 25.0,
                                    ),
                                    _buildWhatsappPhoneNumberTF(),
                                    SizedBox(
                                      height: 25.0,
                                    ),
                                    _buildEmailTF(),
                                    SizedBox(
                                      height: 25.0,
                                    ),
                                    _buildBioTF(),
                                    SizedBox(
                                      height: 25.0,
                                    ),
                                    _buildUpdateBtn(),
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
