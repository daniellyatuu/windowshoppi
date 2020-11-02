import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'dart:async';

class SearchKeywordBloc {
  final _keyword = BehaviorSubject<String>();

  // Get
  Stream<String> get searchedKeyword =>
      _keyword.stream.transform(validateKeyword);
  Stream<bool> get isFormValid =>
      Rx.combineLatest([searchedKeyword], (values) => true);

  // Set
  Function(String) get setKeyword => _keyword.sink.add;

  // Transformers
  final validateKeyword = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      sink.add(value);
    },
  );

  submitKeyword() {
    print('search for keyword: ${_keyword.value}');
  }

  void dispose() {
    _keyword.close();
  }
}
