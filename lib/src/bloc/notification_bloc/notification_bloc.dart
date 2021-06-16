import 'package:fluttertoast/fluttertoast.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

class NotificationBloc extends Bloc<NotificationEvents, NotificationStates> {
  NotificationBloc() : super(NotificationFetchLoading());

  @override
  Stream<Transition<NotificationEvents, NotificationStates>> transformEvents(
    Stream<NotificationEvents> events,
    TransitionFunction<NotificationEvents, NotificationStates> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<NotificationStates> mapEventToState(NotificationEvents event) async* {
    int _limit = 21;
    final currentState = state;

    if (event is NotificationRefresh) {
      print('here fresh');
      if (currentState is NotificationSuccess) {
        try {
          final _notifications = await NotificationAPIClient().getNotification(
              offset: 0,
              limit: _limit,
              accountId: currentState.activeAccountId);

          if (_notifications is List<NotificationModel>) {
            yield NotificationSuccess(
              notifications: _notifications,
              activeAccountId: currentState.activeAccountId,
              hasReachedMax: _notifications.length < _limit ? true : false,
            );
          }
        } catch (_) {
          yield NotificationFailure();
        }
      }
    }

    if (event is NotificationInitFetch &&
        currentState is! NotificationSuccess) {
      try {
        final _notifications = await NotificationAPIClient().getNotification(
            offset: 0, limit: _limit, accountId: event.accountId);

        if (_notifications is List<NotificationModel>) {
          yield NotificationSuccess(
            notifications: _notifications,
            activeAccountId: event.accountId,
            hasReachedMax: _notifications.length < _limit ? true : false,
          );
        }
      } catch (_) {
        yield NotificationFailure();
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
