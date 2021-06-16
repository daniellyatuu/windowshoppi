import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class FollowedAccountBloc
    extends Bloc<FollowedAccountEvents, FollowedAccountStates> {
  FollowedAccountBloc() : super(FollowedAccountInit());

  @override
  Stream<FollowedAccountStates> mapEventToState(
      FollowedAccountEvents event) async* {
    final currentState = state;

    List<int> _followedAccounts = [];
    List<int> _unfollowedAccounts = [];

    if (event is SaveFollowedAccount) {
      if (currentState is FollowedUnfollowedAccounts) {
        // remove followed account in unfollowed account list if exists
        currentState.unfollowedAccounts.remove(event.accountId);

        if (!currentState.followedAccounts.contains(event.accountId)) {
          currentState.followedAccounts.add(event.accountId);
        }

        _followedAccounts.addAll(currentState.followedAccounts);
        _unfollowedAccounts.addAll(currentState.unfollowedAccounts);
      } else {
        _followedAccounts.add(event.accountId);
      }

      yield FollowedLoading();
      yield FollowedUnfollowedAccounts(
          followedAccounts: _followedAccounts,
          unfollowedAccounts: _unfollowedAccounts);
    }

    if (event is SaveUnFollowedAccount) {
      if (currentState is FollowedUnfollowedAccounts) {
        // remove unfollowed account in followed account list if exists
        currentState.followedAccounts.remove(event.accountId);

        if (!currentState.unfollowedAccounts.contains(event.accountId)) {
          currentState.unfollowedAccounts.add(event.accountId);
        }

        _followedAccounts.addAll(currentState.followedAccounts);
        _unfollowedAccounts.addAll(currentState.unfollowedAccounts);
      } else {
        _unfollowedAccounts.add(event.accountId);
      }

      yield FollowedLoading();
      yield FollowedUnfollowedAccounts(
          followedAccounts: _followedAccounts,
          unfollowedAccounts: _unfollowedAccounts);
    }
  }
}
