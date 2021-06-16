import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';

class FcmTokenBloc extends Bloc<FcmTokenEvents, FcmTokenStates> {
  FcmTokenBloc() : super(FcmTokenInit());

  @override
  Stream<FcmTokenStates> mapEventToState(FcmTokenEvents event) async* {
    print('update token');
    if (event is UpdateToken) {
      try {
        final _result =
            await FcmTokenAPIClient().updateToken(fcmToken: event.fcmToken);

        // print('back to bloc $_result');
        // if (_result == 'no_internet') {
        //   yield FollowUnfollowNoInternet();
        // } else if (_result == 'followed') {
        //   yield FollowSuccess(followingId: event.followData['following']);
        // } else if (_result == 'unfollowed') {
        //   yield UnfollowSuccess(unFollowingId: event.followData['following']);
        // }
      } catch (_) {
        print(_);
      }
    }
  }
}
