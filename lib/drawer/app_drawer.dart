import 'package:flutter/material.dart';

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
          DrawerList(
            title: 'About Us',
            drawerColor: _color,
            drawerIcon: Icons.dashboard,
          ),
          DrawerList(
            title: 'FAQ',
            drawerColor: _color,
            drawerIcon: Icons.question_answer,
          ),
//          DrawerList(
//            title: 'Favorite',
//            drawerColor: _color,
//            drawerIcon: Icons.favorite_border,
//          ),
//          DrawerList(
//            title: 'Invite Friend',
//            drawerColor: _color,
//            drawerIcon: Icons.group,
//          ),
//          DrawerList(
//            title: 'Become a Seller',
//            drawerColor: _color,
//            drawerIcon: Icons.add_box,
//          ),
//          Divider(),
          DrawerList(
            title: 'Settings',
            drawerColor: _color,
            drawerIcon: Icons.settings,
          ),
          DrawerList(
            title: 'Help',
            drawerColor: _color,
            drawerIcon: Icons.info_outline,
          ),
        ],
      ),
    );
  }
}

class DrawerList extends StatelessWidget {
  final String title;
  final Color drawerColor;
  final IconData drawerIcon;
  DrawerList({Key key, this.title, this.drawerColor, this.drawerIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: ListTile(
        title: Text(title),
        leading: Icon(
          drawerIcon,
          color: drawerColor,
        ),
      ),
    );
  }
}
