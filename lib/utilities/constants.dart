import 'package:flutter/material.dart';

final kHintTextStyle = TextStyle(
  color: Colors.white54,
);

final kLabelStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.teal[700],
  borderRadius: BorderRadius.circular(8.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

//final tFBoxDecorationStyle = InputDecoration(
//  prefixIcon: Icon(Icons.business),
//  contentPadding: EdgeInsets.symmetric(
//    vertical: 0.0,
//    horizontal: 10.0,
//  ),
//  border: OutlineInputBorder(
//    borderSide: BorderSide(
//      color: Colors.white,
//    ),
//  ),
//  focusedBorder: OutlineInputBorder(
//    borderRadius: BorderRadius.circular(10.0),
//    borderSide: BorderSide(
//      color: Colors.blue,
//    ),
//  ),
//  enabledBorder: OutlineInputBorder(
//    borderRadius: BorderRadius.circular(10.0),
//    borderSide: BorderSide(
//      color: Colors.green,
//    ),
//  ),
//);
