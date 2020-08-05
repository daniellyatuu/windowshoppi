import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'register.dart';
import 'package:windowshoppi/account/my_account.dart';
import 'package:windowshoppi/models/local_storage_keys.dart';

class UserAuth extends StatefulWidget {
  @override
  _UserAuthState createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {
  Color primaryColor = Colors.red;
  bool _isLoggedIn, _isRegistered;
  bool isLoading = true, _isLoggedOut = false;

  Widget _loginRegisterPage() {
    return DefaultTabController(
      initialIndex: _isRegistered ? 1 : 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: TabBar(
            onTap: (index) {
              setState(() {
                switch (index) {
                  case 0:
                    primaryColor = Colors.red;
                    break;
                  case 1:
                    primaryColor = Colors.red[600];
                    break;
                }
              });
            },
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.person_add),
                text: 'register',
              ),
              Tab(
                icon: FaIcon(FontAwesomeIcons.signInAlt),
                text: 'login',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            RegisterPage(isLoginStatus: (value) => _changeStatus(value)),
            LoginPage(
                isLoginStatus: (value) => _changeStatus(value),
                isLoggedOut: _isLoggedOut),
          ],
        ),
      ),
    );
  }

  _changeStatus(value) async {
    setState(() {
      _isLoggedIn = value;
      _isRegistered = true;
    });
  }

  void _checkUserLogin() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString(userToken);
    if (token != '' && token != null) {
      setState(() {
        _isLoggedIn = true;
      });
    } else {
      setState(() {
        _isLoggedIn = false;
      });

      //check if already registered
      var isRegister = localStorage.getBool('isRegistered');
      if (isRegister == true && isRegister != null) {
        setState(() {
          _isRegistered = true;
        });
      } else {
        _isRegistered = false;
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkUserLogin();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                'windowshoppi',
                style: TextStyle(fontFamily: 'Itim'),
              ),
            ),
            body: Center(
              child: SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2.0),
              ),
            ),
          )
        : _isLoggedIn
            ? MyAccount(
                isLoginStatus: (value) => _changeStatus(value),
                userLogoutSuccessFully: (value) {
                  setState(() {
                    _isLoggedOut = true;
                  });
                },
              )
            : _loginRegisterPage();
  }
}
