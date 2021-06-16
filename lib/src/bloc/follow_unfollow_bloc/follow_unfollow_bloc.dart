import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';

class FollowUnfollowBloc
    extends Bloc<FollowUnfollowEvents, FollowUnfollowStates> {
  FollowUnfollowBloc() : super(FollowUnfollowInit());

  @override
  Stream<FollowUnfollowStates> mapEventToState(
      FollowUnfollowEvents event) async* {
    if (event is FollowAccount) {
      yield FollowLoading(followingId: event.followData['following']);
      try {
        final _result =
            await FollowUnfollowAPIClient().followUnfollow(event.followData);
        print('back to bloc $_result');
        if (_result == 'no_internet') {
          _toastNotification('No internet connection', Colors.red,
              Toast.LENGTH_SHORT, ToastGravity.BOTTOM);
          yield FollowUnfollowNoInternet();
        } else if (_result == 'followed') {
          yield FollowSuccess(followingId: event.followData['following']);
        } else if (_result == 'unfollowed') {
          yield UnfollowSuccess(unFollowingId: event.followData['following']);
        }
      } catch (_) {
        print(_);
        yield FollowUnfollowError();
      }
    }
  }
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
