import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/model/account_model.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:rxdart/rxdart.dart';

class SearchAccountBloc extends Bloc<SearchAccountEvents, SearchAccountStates> {
  final SearchAccountRepository searchAccountRepository;
  SearchAccountBloc({@required this.searchAccountRepository})
      : super(SearchAccountEmpty());

  @override
  Stream<Transition<SearchAccountEvents, SearchAccountStates>> transformEvents(
      Stream<SearchAccountEvents> events,
      TransitionFunction<SearchAccountEvents, SearchAccountStates>
          transitionFn) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<SearchAccountStates> mapEventToState(
      SearchAccountEvents event) async* {
    int _limit = 20;
    final currentState = state;

    if (event is ClearSearchAccountResult) {
      if (currentState is SearchAccountSuccess) currentState.accounts.clear();
      yield SearchAccountEmpty();
    }

    // check if new keyword match searched keyword
    String newKeyword;
    String prevKeyword;

    if (currentState is SearchAccountSuccess)
      prevKeyword = currentState.searchedKeyword;

    if (event is InitSearchAccountFetched) newKeyword = event.accountKeyword;

    if (event is InitSearchAccountFetched && newKeyword != prevKeyword) {
      if (currentState is SearchAccountEmpty) yield SearchAccountInitial();

      try {
        final List<Account> _accounts = await searchAccountRepository
            .searchAccount(event.accountKeyword, 0, _limit);

        yield SearchAccountSuccess(
            accounts: _accounts,
            hasReachedMax: _accounts.length < _limit ? true : false,
            searchedKeyword: event.accountKeyword);
      } catch (_) {
        yield SearchAccountFailure();
      }
    }

    if (event is SearchAccountLoadMore && !_hasReachedMax(currentState)) {
      if (currentState is SearchAccountSuccess) {
        final List<Account> _accounts =
            await searchAccountRepository.searchAccount(
                currentState.searchedKeyword, currentState.accounts.length, 10);

        yield SearchAccountSuccess(
          accounts: currentState.accounts + _accounts,
          hasReachedMax: _accounts.length < _limit ? true : false,
          searchedKeyword: currentState.searchedKeyword,
        );
      }
    }
  }

  // @override
  // Stream<SearchPostStates> mapEventToState(SearchPostEvents event) async* {
  //   final currentState = state;
  //
  //   if (event is ClearSearchPostResult) {
  //     if (currentState is SearchPostSuccess) currentState.posts.clear();
  //     yield SearchPostEmpty();
  //   }
  //
  //   if (event is InitSearchPostFetched) {
  //     if (currentState is SearchPostEmpty) yield SearchPostInitial();
  //
  //     try {
  //       final List<Post> _posts =
  //       await searchPostRepository.searchPost(event.postKeyword, 0, 21);
  //       yield SearchPostSuccess(
  //           posts: _posts,
  //           hasReachedMax: _posts.length < 20 ? true : false,
  //           searchedKeyword: event.postKeyword);
  //       print('save keyword');
  //     } catch (_) {
  //       yield SearchPostFailure();
  //     }
  //   }
  //
  //   if (event is SearchPostLoadMore && !_hasReachedMax(currentState)) {
  //     print('load more');
  //     print(currentState);
  //
  //     if (currentState is SearchPostSuccess) {
  //       print('searched keyword = ${currentState.searchedKeyword}');
  //       print(currentState.posts.length);
  //
  //       final List<Post> _posts = await searchPostRepository.searchPost(
  //           currentState.searchedKeyword, currentState.posts.length, 21);
  //
  //       yield _posts.isEmpty
  //           ? currentState.copyWith(hasReachedMax: true)
  //           : SearchPostSuccess(
  //         posts: currentState.posts + _posts,
  //         hasReachedMax: false,
  //         searchedKeyword: currentState.searchedKeyword,
  //       );
  //     }

  //   }

  // }
  //
  bool _hasReachedMax(SearchAccountStates state) =>
      state is SearchAccountSuccess && state.hasReachedMax;
}
