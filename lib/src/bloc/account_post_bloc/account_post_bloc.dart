import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class AccountPostBloc extends Bloc<AccountPostEvents, AccountPostStates> {
  final AccountPostRepository accountPostRepository;
  AccountPostBloc({@required this.accountPostRepository})
      : super(AccountPostInitial());

  @override
  Stream<Transition<AccountPostEvents, AccountPostStates>> transformEvents(
    Stream<AccountPostEvents> events,
    TransitionFunction<AccountPostEvents, AccountPostStates> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<AccountPostStates> mapEventToState(AccountPostEvents event) async* {
    int _limit = 21;
    final currentState = state;

    if (event is AccountPostRefresh) {
      if (currentState is AccountPostSuccess) {
        // get new posts
        final List<Post> _posts =
            await accountPostRepository.accountPost(0, _limit, event.accountId);

        // remove current posts
        currentState.posts.clear();

        yield AccountPostSuccess(
          posts: _posts,
          hasReachedMax: _posts.length < _limit ? true : false,
        );
      }
    }

    if (event is ResetAccountPostState) {
      yield AccountPostInitial();
    }

    if (event is AccountPostRemove) {
      yield AccountPostInitial();
      if (currentState is AccountPostSuccess) {
        currentState.posts.remove(event.post);
        yield AccountPostSuccess(
          posts: currentState.posts,
          hasReachedMax: currentState.posts.length < _limit ? true : false,
        );
      }
    }

    // initial fetch data
    if (event is AccountPostInitFetched) {
      try {
        final List<Post> _posts =
            await accountPostRepository.accountPost(0, _limit, event.accountId);

        yield AccountPostSuccess(
          posts: _posts,
          hasReachedMax: _posts.length < _limit ? true : false,
        );
      } catch (_) {
        yield AccountPostFailure();
      }
    }

    // load more data
    if (event is AccountPostFetchedMoreData && !_hasReachedMax(currentState)) {
      if (currentState is AccountPostSuccess) {
        try {
          final List<Post> _posts = await accountPostRepository.accountPost(
              currentState.posts.length, _limit, event.accountId);

          yield AccountPostSuccess(
            posts: currentState.posts + _posts,
            hasReachedMax: _posts.length < _limit ? true : false,
          );
        } catch (_) {
          yield AccountPostFailure();
        }
      }
    }
  }

  bool _hasReachedMax(AccountPostStates state) =>
      state is AccountPostSuccess && state.hasReachedMax;
}
