import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/models/local_storage_keys.dart';
import 'package:windowshoppi/utilities/constants.dart';
import 'package:windowshoppi/routes/fade_transition.dart';
import 'discover_account.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  final Function(bool) isLoginStatus;
  final bool isLoggedOut;
  LoginPage({@required this.isLoginStatus, this.isLoggedOut});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLogin = false;

  // Initially password is obscure
  bool _obscureText = true;

  // form data
  String _userName, _passWord;

  Widget _buildWindowshoppiTitle() {
    return Column(
      children: <Widget>[
        Text(
          'windowshoppi',
          style: TextStyle(fontSize: 28, fontFamily: 'Itim'),
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
              focusedBorder: kFocusedBorder,
              enabledBorder: kEnabledBorder,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'password is required';
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

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            FadeRoute(
              widget: DiscoverAccount(),
            ),
          );
        },
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      width: double.infinity,
      child: AbsorbPointer(
        absorbing: _isLogin ? true : false,
        child: RaisedButton(
          onPressed: () async {
            if (_loginFormKey.currentState.validate()) {
              _loginFormKey.currentState.save();
//              setState(() {
////                _isNotificationVisible = false;
//                _isLogoutVisible = false;
//              });
              var loginInfo = {
                'username': _userName,
                'password': _passWord,
              };

              setState(() {
                _isLogin = true;
              });

              await _loginUser(loginInfo);

              setState(() {
                _isLogin = false;
              });
            }
          },
          color: _isLogin ? Colors.grey[200] : Colors.white,
          child: _isLogin
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
                  'LOGIN',
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

  Widget _buildSignWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Text(
          'Sign with',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30.0,
        width: 30.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black87,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(() => print('login with facebook'),
              AssetImage('images/logo/facebook.jpg')),
          _buildSocialBtn(() => print('login with google'),
              AssetImage('images/logo/google.jpg')),
        ],
      ),
    );
  }

//  Widget _buildNotificationWidget() {
//    return Visibility(
//      visible: _isNotificationVisible ? true : false,
//      child: Padding(
//        padding: const EdgeInsets.only(bottom: 15.0),
//        child: Container(
//          decoration: BoxDecoration(
//            color: Colors.red[400],
//            borderRadius: BorderRadius.circular(5.0),
//          ),
//          width: MediaQuery.of(context).size.width,
//          child: ListTile(
//            contentPadding: EdgeInsets.only(left: 10.0),
//            dense: true,
//            title: Text('wrong username or password'),
//            trailing: IconButton(
//              onPressed: () {
//                setState(() {
//                  _isNotificationVisible = false;
//                });
//              },
//              icon: Icon(Icons.clear),
//            ),
//          ),
//        ),
//      ),
//    );
//  }

//  Widget _buildLogoutAlertWidget() {
//    return Visibility(
//      visible: _isLogoutVisible ? true : false,
//      child: Padding(
//        padding: const EdgeInsets.only(bottom: 15.0),
//        child: Container(
//          decoration: BoxDecoration(
//            color: Colors.teal,
//            borderRadius: BorderRadius.circular(5.0),
//          ),
//          width: MediaQuery.of(context).size.width,
//          child: ListTile(
//            contentPadding: EdgeInsets.only(left: 10.0),
//            dense: true,
//            leading: Icon(Icons.check, color: Colors.white),
//            title: Text('logout successfully',
//                style: TextStyle(color: Colors.white)),
//            trailing: IconButton(
//              onPressed: () {
//                setState(() {
//                  _isLogoutVisible = false;
//                });
//              },
//              icon: Icon(Icons.clear),
//            ),
//          ),
//        ),
//      ),
//    );
//  }

  Future _loginUser(loginInfo) async {
    await Future.delayed(Duration(milliseconds: 300));
    final response = await http.post(
      LOGIN_USER,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(loginInfo),
    );

    var _user = json.decode(response.body);

    if (_user['non_field_errors'] != null) {
      if (_user['non_field_errors'][0] == 'invalid_account') {
//        setState(() {
//          _isNotificationVisible = true;
//        });
//        dismissNotification();
        _notification('wrong username or password', Colors.black, Colors.red);
      }
      return null;
    }

    if (response.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setBool(isRegistered, true);
      localStorage.setString(userToken, _user['token']);
      localStorage.setString(businessId, _user['business_id']);
      localStorage.setString(businessName, _user['business_name']);
      localStorage.setString(businessLocation, _user['business_location']);
      localStorage.setString(bio, _user['bio']);
      localStorage.setString(whatsapp, _user['whatsapp']);
      localStorage.setString(callNumber, _user['call']);
      localStorage.setString(profileImage, _user['profile_image']);
      localStorage.setString(userMail, _user['email']);
      widget.isLoginStatus(true);
      return _user;
    } else {
//      throw Exception('Failed to login user.');
      return 'failed to login user';
    }
  }

//  void dismissNotification() {
//    if (_isNotificationVisible) {
//      Future.delayed(const Duration(seconds: 8), () {
//        if (this.mounted) {
//          setState(() {
//            _isNotificationVisible = false;
//          });
//        }
//      });
//    }
//  }

//  void dismissLogoutNotification() {
//    if (_isLogoutVisible) {
//      Future.delayed(const Duration(seconds: 2), () {
//        if (this.mounted) {
//          setState(() {
//            _isLogoutVisible = false;
//          });
//        }
//      });
//    }
//  }

//  void _notification(String txt, Color color) {
//    final snackBar = SnackBar(
//      content: Text(txt),
//      backgroundColor: color,
//      action: SnackBarAction(
//        label: 'Hide',
//        onPressed: () {
//          Scaffold.of(context).hideCurrentSnackBar();
//        },
//      ),
//    );
//    Scaffold.of(context).showSnackBar(snackBar);
//  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isLoggedOut == true) {
//      _isLogoutVisible = widget.isLoggedOut;
//      dismissLogoutNotification();
      _notification('logout successfully', Colors.teal, Colors.black);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Center(
                child: Form(
                  key: _loginFormKey,
                  child: ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _buildWindowshoppiTitle(),
                            SizedBox(
                              height: 25.0,
                            ),
//                            _buildLogoutAlertWidget(),
//                            _buildNotificationWidget(),
                            _buildUsernameTF(),
                            SizedBox(
                              height: 25.0,
                            ),
                            _buildPasswordTF(),
                            _buildForgotPasswordBtn(),
//                          _buildRememberMeCheckbox(),
                            _buildLoginBtn(),
//                          _buildSignWithText(),
//                          _buildSocialBtnRow(),
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
