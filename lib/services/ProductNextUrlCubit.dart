import 'package:bloc/bloc.dart';

class ProductNextUrl extends Cubit<String> {
  ProductNextUrl() : super('');

  void nextUrl(url) => emit(url);
}
