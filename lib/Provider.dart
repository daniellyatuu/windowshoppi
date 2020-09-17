import 'package:flutter/material.dart';
import 'package:windowshoppi/Overseer.dart';

class Provider extends InheritedWidget {
  final Overseer data;
  Provider({Key key, Widget child, this.data}) : super(key: key, child: child);

  static Overseer of(BuildContext context) {
    // ignore: deprecated_member_use
    return (context.inheritFromWidgetOfExactType(Provider) as Provider).data;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}
