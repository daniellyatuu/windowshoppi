import 'package:fluttertoast/fluttertoast.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter/material.dart';
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
      if (currentState is AllPostFailure || currentState is AllPostNoInternet)
        yield AllPostInitial();

      try {
        // get new posts
        final _posts = await allPostRepository.userPost(0, _limit);

        if (_posts == 'no_internet') {
          // SHOW ALERT ON UI WITHOUT REMOVE currentState
          _toastNotification('No internet connection', Colors.red,
              Toast.LENGTH_SHORT, ToastGravity.BOTTOM);

          if (currentState is! AllPostSuccess) {
            yield AllPostNoInternet();
          }
        } else if (_posts is List<Post>) {
          yield AllPostSuccess(
            posts: _posts,
            hasReachedMax: _posts.length < _limit ? true : false,
          );
        }
      } catch (_) {
        // SHOW ALERT ON UI WITHOUT REMOVE currentState
        _toastNotification('Failed to fetch posts.Try again', Colors.red,
            Toast.LENGTH_SHORT, ToastGravity.BOTTOM);

        if (currentState is! AllPostSuccess) {
          yield AllPostFailure();
        }
      }
    }

    // if (event is AllPostRetry) {
    //   yield AllPostInitial();
    //   try {
    //     if (currentState is AllPostFailure) {
    //       // get new posts
    //       final List<Post> _posts = await allPostRepository.userPost(0, _limit);
    //
    //       yield AllPostSuccess(
    //         posts: _posts,
    //         hasReachedMax: _posts.length < _limit ? true : false,
    //       );
    //     }
    //   } catch (_) {
    //     yield AllPostFailure();
    //   }
    // }

    if (event is AllPostInsert) {
      yield AllPostInitial();
      if (currentState is AllPostSuccess) {
        currentState.posts.insert(0, event.post);
        yield AllPostSuccess(
          posts: currentState.posts,
          hasReachedMax: currentState.posts.length < _limit ? true : false,
        );
      }
    }

    if (event is PostRemove) {
      yield AllPostInitial();
      if (currentState is AllPostSuccess) {
        currentState.posts.remove(event.post);
        yield AllPostSuccess(
          posts: currentState.posts,
          hasReachedMax: currentState.posts.length < _limit ? true : false,
        );
      }
    }

    if (event is AllPostFetched && !_hasReachedMax(currentState)) {
      if (currentState is AllPostInitial) {
        try {
          final _posts = await allPostRepository.userPost(0, _limit);

          if (_posts == 'no_internet') {
            yield AllPostNoInternet();
          } else if (_posts is List<Post>) {
            yield AllPostSuccess(
              posts: _posts,
              hasReachedMax: _posts.length < _limit ? true : false,
            );
          }
        } catch (_) {
          yield AllPostFailure();
        }
      }

      if (currentState is AllPostSuccess) {
        try {
          final _posts = await allPostRepository.userPost(
              currentState.posts.length, _limit);

          if (_posts == 'no_internet') {
            _toastNotification('No internet connection', Colors.red,
                Toast.LENGTH_SHORT, ToastGravity.BOTTOM);
            if (event.from != 'explore') yield AllPostInitial();
            yield AllPostSuccess(
              posts: currentState.posts,
              hasReachedMax: currentState.posts.length < _limit ? true : false,
              hasFailedToLoadMore: true,
            );
          } else if (_posts is List<Post>) {
            yield AllPostSuccess(
              posts: currentState.posts + _posts,
              hasReachedMax: _posts.length < _limit ? true : false,
            );
          }
        } catch (_) {
          _toastNotification('Failed to fetch posts.Try again', Colors.red,
              Toast.LENGTH_SHORT, ToastGravity.BOTTOM);
          if (event.from != 'explore') yield AllPostInitial();
          yield AllPostSuccess(
            posts: currentState.posts,
            hasReachedMax: currentState.posts.length < _limit ? true : false,
            hasFailedToLoadMore: true,
          );
        }
      }
    }
  }

  bool _hasReachedMax(AllPostStates state) =>
      state is AllPostSuccess && state.hasReachedMax;
}

void _toastNotification(
    String txt, Color color, Toast length, ToastGravity gravity) {
  // close active toast if any before open new one
  Fluttertoast.cancel();

  Fluttertoast.showToast(
      msg: '$txt',
      toastLength: length,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 14.0);
}
