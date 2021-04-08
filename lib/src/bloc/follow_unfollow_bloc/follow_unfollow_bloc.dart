import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class FollowUnfollowBloc
    extends Bloc<FollowUnfollowEvents, FollowUnfollowStates> {
  FollowUnfollowBloc() : super(FollowLoading());

  @override
  Stream<FollowUnfollowStates> mapEventToState(
      FollowUnfollowEvents event) async* {
    print('inside follow unfollow bloc');
  }
}
