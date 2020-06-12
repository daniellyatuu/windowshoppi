import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyAppBar extends AppBar {
//  static BuildContext get context => null;

  MyAppBar({BuildContext context, Key key, Widget title, Color appBarColor})
      : super(
          backgroundColor: appBarColor,
          key: key,
          title: title,
          elevation: 0,
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ChangeCountry(),
                  ),
                );
              },
              child: Row(
                children: <Widget>[
                  Icon(Icons.location_on),
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text('Tanzania'),
                  ),
                ],
              ),
            ),
          ],
        );
}

class ChangeCountry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('change country'),
      ),
    );
  }
}
