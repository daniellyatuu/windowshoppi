import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:rxdart/rxdart.dart';

class SearchPostBloc extends Bloc<SearchPostEvents, SearchPostStates> {
  final SearchPostRepository searchPostRepository;

  SearchPostBloc({@required this.searchPostRepository})
      : super(SearchPostEmpty());

  @override
  Stream<Transition<SearchPostEvents, SearchPostStates>> transformEvents(
      Stream<SearchPostEvents> events,
      TransitionFunction<SearchPostEvents, SearchPostStates> transitionFn) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<SearchPostStates> mapEventToState(SearchPostEvents event) async* {
    int _limit = 21;
    final currentState = state;

    if (event is ClearSearchPostResult) {
      if (currentState is SearchPostSuccess) currentState.posts.clear();
      yield SearchPostEmpty();
    }

    // check if new keyword match searched keyword
    String newKeyword;
    String prevKeyword;
    if (currentState is SearchPostSuccess)
      prevKeyword = currentState.searchedKeyword;

    if (event is InitSearchPostFetched) newKeyword = event.postKeyword;

    if (event is InitSearchPostFetched && newKeyword != prevKeyword) {
      print('POST INIT');
      if (currentState is SearchPostEmpty) yield SearchPostInitial();

      try {
        final List<Post> _posts =
            await searchPostRepository.searchPost(event.postKeyword, 0, _limit);
        yield SearchPostSuccess(
            posts: _posts,
            hasReachedMax: _posts.length < _limit ? true : false,
            searchedKeyword: event.postKeyword);
        print('save keyword for post');
      } catch (_) {
        yield SearchPostFailure();
      }
    }

    if (event is SearchPostLoadMore && !_hasReachedMax(currentState)) {
      if (currentState is SearchPostSuccess) {
        final List<Post> _posts = await searchPostRepository.searchPost(
            currentState.searchedKeyword, currentState.posts.length, _limit);
        print('POST MORE = ${_posts.length}');
        yield SearchPostSuccess(
          posts: currentState.posts + _posts,
          hasReachedMax: _posts.length < _limit ? true : false,
          searchedKeyword: currentState.searchedKeyword,
        );
      }
    }
  }

  bool _hasReachedMax(SearchPostStates state) =>
      state is SearchPostSuccess && state.hasReachedMax;
}
