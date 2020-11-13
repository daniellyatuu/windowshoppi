import 'package:flutter/material.dart';

final kHintTextStyle = TextStyle(
  color: Colors.white54,
);

final kLabelStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

final kBoxDecorationStyle = BoxDecoration(
  borderRadius: BorderRadius.circular(8.0),
  border: Border.all(color: Colors.grey),
);

final kFocusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(14.0),
  borderSide: BorderSide(
    color: Colors.black,
  ),
);

final kEnabledBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0),
  borderSide: BorderSide(
    color: Colors.grey,
  ),
);
