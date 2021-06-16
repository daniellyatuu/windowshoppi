import 'package:fluttertoast/fluttertoast.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

class FollowingPostBloc extends Bloc<FollowingPostEvents, FollowingPostStates> {
  FollowingPostBloc() : super(FollowingPostInitFetchLoading());

  @override
  Stream<Transition<FollowingPostEvents, FollowingPostStates>> transformEvents(
    Stream<FollowingPostEvents> events,
    TransitionFunction<FollowingPostEvents, FollowingPostStates> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<FollowingPostStates> mapEventToState(
      FollowingPostEvents event) async* {
    int _limit = 21;
    final currentState = state;

    // if (event is AuthPostRefresh) {
    //   if (currentState is AllPostFailure || currentState is AllPostNoInternet)
    //     yield AuthPostInitFetchLoading();
    //
    //   try {
    //     // get new auth posts
    //     final _authPosts =
    //     await authPostRepository.authPost(0, _limit, event.accountId);
    //
    //     if (_authPosts == 'no_internet') {
    //       // SHOW ALERT ON UI WITHOUT REMOVE currentState
    //       _toastNotification('No internet connection', Colors.red,
    //           Toast.LENGTH_SHORT, ToastGravity.BOTTOM);
    //
    //       if (currentState is! AuthPostSuccess) {
    //         yield AuthPostNoInternet();
    //       }
    //     } else if (_authPosts is List<Post>) {
    //       yield AuthPostSuccess(
    //         posts: _authPosts,
    //         activeAccountId: event.accountId,
    //         hasReachedMax: _authPosts.length < _limit ? true : false,
    //       );
    //     }
    //   } catch (_) {
    //     // SHOW ALERT ON UI WITHOUT REMOVE currentState
    //     _toastNotification('Failed to fetch posts.Try again', Colors.red,
    //         Toast.LENGTH_SHORT, ToastGravity.BOTTOM);
    //
    //     if (currentState is! AuthPostSuccess) {
    //       yield AuthPostFailure();
    //     }
    //   }
    // }
    //
    // if (event is AuthAllPostInsert) {
    //   yield AuthPostInitFetchLoading();
    //   if (currentState is AuthPostSuccess) {
    //     currentState.posts.insert(0, event.post);
    //     yield AuthPostSuccess(
    //       posts: currentState.posts,
    //       activeAccountId: currentState.activeAccountId,
    //       hasReachedMax: currentState.posts.length < _limit ? true : false,
    //     );
    //   }
    // }
    //
    // if (event is AuthPostRemove) {
    //   yield AuthPostInitFetchLoading();
    //   if (currentState is AuthPostSuccess) {
    //     currentState.posts
    //         .removeWhere((element) => element.id == event.post.id);
    //
    //     yield AuthPostSuccess(
    //       posts: currentState.posts,
    //       activeAccountId: currentState.activeAccountId,
    //       hasReachedMax: currentState.posts.length < _limit ? true : false,
    //     );
    //   }
    // }

    if (event is FollowingPostInitFetch &&
        currentState is! FollowingPostSuccess) {
      print('here fetch data');
      try {
        final _followingPosts = await FollowingPostAPIClient()
            .getFollowingPost(0, _limit, event.accountId);

        if (_followingPosts == 'no_internet') {
          yield FollowingPostNoInternet();
        } else if (_followingPosts is List<Post>) {
          yield FollowingPostSuccess(
            posts: _followingPosts,
            activeAccountId: event.accountId,
            hasReachedMax: _followingPosts.length < _limit ? true : false,
          );
        }
      } catch (_) {
        yield FollowingPostFailure();
      }
    }

    // if (event is AuthPostLoadMore && !_hasReachedMax(currentState)) {
    //   if (currentState is AuthPostSuccess) {
    //     try {
    //       final _authPosts = await authPostRepository.authPost(
    //           currentState.posts.length, _limit, currentState.activeAccountId);
    //
    //       if (_authPosts == 'no_internet') {
    //         _toastNotification('No internet connection.', Colors.red,
    //             Toast.LENGTH_SHORT, ToastGravity.BOTTOM);
    //
    //         yield AuthPostSuccess(
    //           posts: currentState.posts,
    //           activeAccountId: currentState.activeAccountId,
    //           hasReachedMax: currentState.posts.length < _limit ? true : false,
    //           hasFailedToLoadMore: true,
    //         );
    //       } else if (_authPosts is List<Post>) {
    //         yield AuthPostSuccess(
    //           posts: currentState.posts + _authPosts,
    //           activeAccountId: currentState.activeAccountId,
    //           hasReachedMax: _authPosts.length < _limit ? true : false,
    //           hasFailedToLoadMore: true,
    //         );
    //       }
    //     } catch (_) {
    //       _toastNotification('Failed to fetch posts.Try again', Colors.red,
    //           Toast.LENGTH_SHORT, ToastGravity.BOTTOM);
    //
    //       yield AuthPostSuccess(
    //         posts: currentState.posts,
    //         activeAccountId: currentState.activeAccountId,
    //         hasReachedMax: currentState.posts.length < _limit ? true : false,
    //         hasFailedToLoadMore: true,
    //       );
    //     }
    //   }
    // }
  }

  // bool _hasReachedMax(AuthPostSuccess state) =>
  //     state is AuthPostSuccess && state.hasReachedMax;
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
