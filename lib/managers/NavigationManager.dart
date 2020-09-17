import 'package:rxdart/rxdart.dart';
import 'dart:async';

class NavigationManager {
  BehaviorSubject<String> _currentIndex = BehaviorSubject<String>.seeded('');

  Stream<String> get index$ => _currentIndex.stream;

  void changePage(String i) => _currentIndex.add(i);
}
