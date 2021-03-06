import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  NavigationBloc() : super(CurrentIndex());

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    if (event is ChangeIndex) {
      yield CurrentIndex(index: event.index);
    }
  }
}
