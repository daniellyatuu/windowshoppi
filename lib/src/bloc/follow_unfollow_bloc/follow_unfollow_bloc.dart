import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';

class FollowUnfollowBloc
    extends Bloc<FollowUnfollowEvents, FollowUnfollowStates> {
  FollowUnfollowBloc() : super(FollowUnfollowInit());

  @override
  Stream<FollowUnfollowStates> mapEventToState(
      FollowUnfollowEvents event) async* {
    yield FollowLoading();

    if (event is FollowAccount) {
      try {
        final _result =
            await FollowUnfollowAPIClient().followUnfollow(event.followData);
        print('back to bloc $_result');
        if (_result == 'no_internet') {
          yield FollowUnfollowNoInternet();
        } else if (_result == 'true') {
          yield FollowSuccess();
        }
      } catch (_) {
        print(_);
        yield FollowUnfollowError();
      }
    }
  }
}
