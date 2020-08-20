import 'package:bloc/bloc.dart';

class CountProductsCubit extends Cubit<int> {
  CountProductsCubit() : super(0);

  void countProduct(number) => emit(number);
}
