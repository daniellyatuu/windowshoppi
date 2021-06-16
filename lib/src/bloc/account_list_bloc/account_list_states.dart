import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class AccountListStates extends Equatable {
  const AccountListStates();

  @override
  List<Object> get props => [];
}

class AccountInitFetchLoading extends AccountListStates {}

class AccountFailure extends AccountListStates {}

class AccountNoInternet extends AccountListStates {}

class AccountSuccess extends AccountListStates {
  final List<AccountListModel> accountList;
  final int activeAccountId;
  final bool hasReachedMax;
  final bool hasFailedToLoadMore;

  const AccountSuccess({
    @required this.accountList,
    @required this.activeAccountId,
    @required this.hasReachedMax,
    this.hasFailedToLoadMore = false,
  });

  @override
  List<Object> get props =>
      [accountList, activeAccountId, hasReachedMax, hasFailedToLoadMore];

  @override
  String toString() =>
      'AccountSuccess { posts: ${accountList.length}, hasReachedMax: $hasReachedMax }';
}
