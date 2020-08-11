import 'package:flutter/material.dart';
import 'package:windowshoppi/routes/fade_transition.dart';
import 'package:windowshoppi/contact_us.dart/contact_us.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Color _color = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                FadeRoute(
                  widget: ContactUs(),
                ),
              );
              ;
            },
            title: Text('Contact Us'),
            leading: Icon(
              Icons.contacts,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
