import 'package:fluttertoast/fluttertoast.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

class AccountListBloc extends Bloc<AccountListEvents, AccountListStates> {
  AccountListBloc() : super(AccountInitFetchLoading());

  @override
  Stream<Transition<AccountListEvents, AccountListStates>> transformEvents(
    Stream<AccountListEvents> events,
    TransitionFunction<AccountListEvents, AccountListStates> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<AccountListStates> mapEventToState(AccountListEvents event) async* {
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

    if (event is AccountInitFetch && currentState is! AccountSuccess) {
      try {
        final _account = await AccountListAPIClient()
            .getAccounts(0, _limit, event.activeAccountId);

        if (_account == 'no_internet') {
          yield AccountNoInternet();
        } else if (_account is List<AccountListModel>) {
          yield AccountSuccess(
            accountList: _account,
            activeAccountId: event.activeAccountId,
            hasReachedMax: _account.length < _limit ? true : false,
          );
        }
      } catch (_) {
        yield AccountFailure();
      }
    }

    if (event is AccountLoadMore && !_hasReachedMax(currentState)) {
      if (currentState is AccountSuccess) {
        try {
          final _account = await AccountListAPIClient().getAccounts(
              currentState.accountList.length,
              _limit,
              currentState.activeAccountId);

          if (_account == 'no_internet') {
            _toastNotification('No internet connection.', Colors.red,
                Toast.LENGTH_SHORT, ToastGravity.BOTTOM);

            yield AccountSuccess(
              accountList: currentState.accountList,
              activeAccountId: currentState.activeAccountId,
              hasReachedMax:
                  currentState.accountList.length < _limit ? true : false,
              hasFailedToLoadMore: true,
            );
          } else if (_account is List<AccountListModel>) {
            yield AccountSuccess(
              accountList: currentState.accountList + _account,
              activeAccountId: currentState.activeAccountId,
              hasReachedMax: _account.length < _limit ? true : false,
              hasFailedToLoadMore: true,
            );
          }
        } catch (_) {
          _toastNotification('Failed to fetch accounts.Try again', Colors.red,
              Toast.LENGTH_SHORT, ToastGravity.BOTTOM);

          yield AccountSuccess(
            accountList: currentState.accountList,
            activeAccountId: currentState.activeAccountId,
            hasReachedMax:
                currentState.accountList.length < _limit ? true : false,
            hasFailedToLoadMore: true,
          );
        }
      }
    }
  }

  bool _hasReachedMax(AccountListStates state) =>
      state is AccountSuccess && state.hasReachedMax;
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
