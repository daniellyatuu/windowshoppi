import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  NavigationBloc() : super(AppCurrentIndex());

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    if (event is ChangeIndex) {
      yield AppCurrentIndex(index: event.index);
    }
  }
}
