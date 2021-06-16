import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:rxdart/rxdart.dart';

class AuthSearchPostBloc
    extends Bloc<AuthSearchPostEvents, AuthSearchPostStates> {
  final AuthSearchPostRepository authSearchPostRepository;

  AuthSearchPostBloc({@required this.authSearchPostRepository})
      : super(AuthSearchPostEmpty());

  @override
  Stream<Transition<AuthSearchPostEvents, AuthSearchPostStates>>
      transformEvents(
          Stream<AuthSearchPostEvents> events,
          TransitionFunction<AuthSearchPostEvents, AuthSearchPostStates>
              transitionFn) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<AuthSearchPostStates> mapEventToState(
      AuthSearchPostEvents event) async* {
    int _limit = 21;
    final currentState = state;

    if (event is AuthClearSearchPostResult) {
      if (currentState is AuthSearchPostSuccess) currentState.posts.clear();
      yield AuthSearchPostEmpty();
    }

    // check if new keyword match searched keyword
    String newKeyword;
    String prevKeyword;
    if (currentState is AuthSearchPostSuccess)
      prevKeyword = currentState.searchedKeyword;

    if (event is AuthInitSearchPostFetched) newKeyword = event.postKeyword;

    if (event is AuthInitSearchPostFetched && newKeyword != prevKeyword) {
      print('POST INIT');
      if (currentState is AuthSearchPostEmpty) yield AuthSearchPostInitial();

      try {
        final List<Post> _posts = await authSearchPostRepository.authSearchPost(
            event.postKeyword, event.accountId, 0, _limit);
        yield AuthSearchPostSuccess(
            posts: _posts,
            hasReachedMax: _posts.length < _limit ? true : false,
            searchedKeyword: event.postKeyword);
        print('save keyword for post');
      } catch (_) {
        yield AuthSearchPostFailure();
      }
    }

    if (event is AuthSearchPostLoadMore && !_hasReachedMax(currentState)) {
      if (currentState is AuthSearchPostSuccess) {
        final List<Post> _posts = await authSearchPostRepository.authSearchPost(
            currentState.searchedKeyword,
            event.accountId,
            currentState.posts.length,
            _limit);
        print('POST MORE = ${_posts.length}');
        yield AuthSearchPostSuccess(
          posts: currentState.posts + _posts,
          hasReachedMax: _posts.length < _limit ? true : false,
          searchedKeyword: currentState.searchedKeyword,
        );
      }
    }
  }

  bool _hasReachedMax(AuthSearchPostStates state) =>
      state is AuthSearchPostSuccess && state.hasReachedMax;
}
