import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScrollToTopBloc extends Bloc<ScrollToTopEvents, ScrollToTopStates> {
  ScrollToTopBloc() : super(ScrollToTopInitial());

  @override
  Stream<ScrollToTopStates> mapEventToState(ScrollToTopEvents event) async* {
    yield ScrollToTopInitial();
    if (event is ScrollToTop) {
      if (event.index == 0) {
        yield IndexZeroScrollToTop();
      } else if (event.index == 1) {
        yield IndexOneScrollToTop();
      } else if (event.index == 3) {
        yield IndexThreeScrollToTop();
      }
    }
  }
}
