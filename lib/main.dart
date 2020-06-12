import 'package:flutter/material.dart';
import 'package:windowshoppi/splash_screen/splash_screen.dart';
import 'package:windowshoppi/navigation_page.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/entry': (context) => AppNavigation(),
      },
    );
  }
}
