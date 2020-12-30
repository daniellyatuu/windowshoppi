import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class ScrollToTopBloc extends Bloc<ScrollToTopEvents, ScrollToTopStates> {
  ScrollToTopBloc() : super(ScrollToTopInitial());

  // @override
  // Stream<Transition<ScrollToTopEvents, ScrollToTopStates>> transformEvents(
  //   Stream<ScrollToTopEvents> events,
  //   TransitionFunction<ScrollToTopEvents, ScrollToTopStates> transitionFn,
  // ) {
  //   return super.transformEvents(
  //     events.debounceTime(const Duration(milliseconds: 300)),
  //     transitionFn,
  //   );
  // }

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
