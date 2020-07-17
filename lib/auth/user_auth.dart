import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login.dart';
import 'register.dart';

class UserAuth extends StatefulWidget {
  @override
  _UserAuthState createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {
  Color primaryColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
            RegisterPage(),
            LoginPage(),
          ],
        ),
      ),
    );
  }
}
