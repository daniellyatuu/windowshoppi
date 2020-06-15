import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login.dart';
import 'register.dart';

class UserAuth extends StatefulWidget {
  @override
  _UserAuthState createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {
  Color primaryColor = Colors.teal[700];

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
                    primaryColor = Colors.teal[700];
                    break;
                  case 1:
                    primaryColor = Colors.teal[800];
                    break;
                }
              });
            },
            tabs: <Widget>[
              Tab(
                icon: FaIcon(FontAwesomeIcons.signInAlt),
                text: 'login',
              ),
              Tab(
                icon: Icon(Icons.person_add),
                text: 'register',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            LoginPage(),
            RegisterPage(),
          ],
        ),
      ),
    );
  }
}
