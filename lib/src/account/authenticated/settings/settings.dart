import 'package:flutter/material.dart';
import 'package:windowshoppi/src/account/account_files.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          // ListTile(
          //   dense: true,
          //   leading: Icon(Icons.color_lens_outlined),
          //   title: Text('Theme'),
          // ),
          // Divider(),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordInit(),
                ),
              );
            },
            dense: true,
            leading: Icon(Icons.vpn_key_outlined),
            title: Text('Password'),
          ),
        ],
      ),
    );
  }
}
