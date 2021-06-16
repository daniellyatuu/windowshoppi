import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class NotificationStates extends Equatable {
  const NotificationStates();

  @override
  List<Object> get props => [];
}

class NotificationFetchLoading extends NotificationStates {}

class NotificationFailure extends NotificationStates {}

class NotificationNoInternet extends NotificationStates {}

class NotificationSuccess extends NotificationStates {
  final List<NotificationModel> notifications;
  final int activeAccountId;
  final bool hasReachedMax;
  final bool hasFailedToLoadMore;

  const NotificationSuccess({
    @required this.notifications,
    @required this.activeAccountId,
    @required this.hasReachedMax,
    this.hasFailedToLoadMore = false,
  });

  @override
  List<Object> get props => [notifications, hasReachedMax];

  @override
  String toString() =>
      'NotificationSuccess { posts: ${notifications.length}, hasReachedMax: $hasReachedMax }';
}
