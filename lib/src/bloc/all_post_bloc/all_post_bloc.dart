import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

class AllPostBloc extends Bloc<AllPostEvents, AllPostStates> {
  final AllPostRepository allPostRepository;
  AllPostBloc({@required this.allPostRepository}) : super(AllPostInitial());

  @override
  Stream<Transition<AllPostEvents, AllPostStates>> transformEvents(
    Stream<AllPostEvents> events,
    TransitionFunction<AllPostEvents, AllPostStates> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<AllPostStates> mapEventToState(AllPostEvents event) async* {
    int _limit = 21;
    final currentState = state;

    if (event is AllPostRefresh) {
      try {
        if (currentState is AllPostSuccess) {
          // get new posts
          final List<Post> _posts = await allPostRepository.userPost(0, _limit);

          // remove current posts
          currentState.posts.clear();

          yield AllPostSuccess(
            posts: _posts,
            hasReachedMax: _posts.length < _limit ? true : false,
          );
        }
      } catch (_) {
        yield AllPostFailure();
      }
    }

    if (event is AllPostRetry) {
      yield AllPostInitial();
      try {
        if (currentState is AllPostFailure) {
          // get new posts
          final List<Post> _posts = await allPostRepository.userPost(0, _limit);

          yield AllPostSuccess(
            posts: _posts,
            hasReachedMax: _posts.length < _limit ? true : false,
          );
        }
      } catch (_) {
        yield AllPostFailure();
      }
    }

    if (event is AllPostFetched && !_hasReachedMax(currentState)) {
      try {
        if (currentState is AllPostInitial) {
          final List<Post> _posts = await allPostRepository.userPost(0, _limit);

          yield AllPostSuccess(
            posts: _posts,
            hasReachedMax: _posts.length < _limit ? true : false,
          );
        }
      } catch (_) {
        yield AllPostFailure();
      }

      if (currentState is AllPostSuccess) {
        try {
          final List<Post> _posts = await allPostRepository.userPost(
              currentState.posts.length, _limit);

          yield AllPostSuccess(
            posts: currentState.posts + _posts,
            hasReachedMax: _posts.length < _limit ? true : false,
          );
        } catch (_) {
          yield AllPostInitial();
          yield AllPostSuccess(
            posts: currentState.posts,
            hasReachedMax: false,
            hasFailedToLoadMore: true,
          );
        }
      }
    }
  }

  bool _hasReachedMax(AllPostStates state) =>
      state is AllPostSuccess && state.hasReachedMax;
}
