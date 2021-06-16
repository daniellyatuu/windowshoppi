import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

class UserPostBloc extends Bloc<UserPostEvents, UserPostStates> {
  final UserPostRepository userPostRepository;
  UserPostBloc({@required this.userPostRepository}) : super(UserPostInitial());

  @override
  Stream<Transition<UserPostEvents, UserPostStates>> transformEvents(
    Stream<UserPostEvents> events,
    TransitionFunction<UserPostEvents, UserPostStates> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<UserPostStates> mapEventToState(UserPostEvents event) async* {
    int _limit = 21;
    final currentState = state;

    if (event is UserPostRefresh) {
      if (currentState is UserPostInitNoInternet ||
          currentState is UserPostFailure) yield UserPostInitial();

      try {
        // get new posts
        final _posts =
            await userPostRepository.userPost(0, _limit, event.accountId);

        if (_posts == 'no_internet') {
          yield UserPostInitNoInternet();
        } else if (_posts == 'invalid_token') {
          yield InvalidToken();
        } else if (_posts is List<Post>) {
          if (currentState is UserPostSuccess)
            // remove current posts
            currentState.posts.clear();

          final List<Post> posts = _posts;

          yield UserPostSuccess(
              posts: posts,
              hasReachedMax: posts.length < _limit ? true : false);
        }
      } catch (_) {
        yield UserPostFailure();
      }
    }

    if (event is UserPostInsert) {
      yield UserPostInitial();
      if (currentState is UserPostSuccess) {
        currentState.posts.insert(0, event.post);
        yield UserPostSuccess(
          posts: currentState.posts,
          hasReachedMax: currentState.posts.length < _limit ? true : false,
        );
      }
    }

    if (event is UserPostRemove) {
      print('inside UserPostRemove');
      yield UserPostInitial();
      if (currentState is UserPostSuccess) {
        currentState.posts
            .removeWhere((element) => element.id == event.post.id);

        yield UserPostSuccess(
          posts: currentState.posts,
          hasReachedMax: currentState.posts.length < _limit ? true : false,
        );
      }
    }

    if (event is ReplacePost) {
      if (currentState is UserPostSuccess) {
        var prevPostIndex = currentState.posts.indexOf(event.prevPost);

        //remove prevPost
        currentState.posts.remove(event.prevPost);

        //insert newPost on the index of prevPost
        currentState.posts.insert(prevPostIndex, event.newPost);

        yield UserPostInitial();
        yield UserPostSuccess(
          posts: currentState.posts,
          hasReachedMax: currentState.posts.length < _limit ? true : false,
        );
      }
    }

    if (event is UserPostFetchedInit && !_hasReachedMax(currentState)) {
      if (currentState is UserPostInitial) {
        try {
          final _posts =
              await userPostRepository.userPost(0, _limit, event.accountId);

          if (_posts == 'no_internet') {
            yield UserPostInitNoInternet();
          } else if (_posts == 'invalid_token') {
            yield InvalidToken();
          } else if (_posts is List<Post>) {
            final List<Post> posts = _posts;

            yield UserPostSuccess(
                posts: posts,
                hasReachedMax: posts.length < _limit ? true : false);
          }
        } catch (_) {
          yield UserPostFailure();
        }
      }
    }

    if (event is UserPostFetched && !_hasReachedMax(currentState)) {
      if (currentState is UserPostSuccess) {
        try {
          final _posts = await userPostRepository.userPost(
              currentState.posts.length, _limit, event.accountId);

          if (_posts == 'no_internet') {
            yield UserPostInitial();
            yield UserPostSuccess(
              posts: currentState.posts,
              hasReachedMax: false,
              hasFailedToLoadMore: true,
            );
          } else if (_posts == 'invalid_token') {
            yield InvalidToken();
          } else if (_posts is List<Post>) {
            final List<Post> posts = _posts;
            yield UserPostSuccess(
              posts: currentState.posts + posts,
              hasReachedMax: posts.length < _limit ? true : false,
            );
          }
        } catch (_) {
          yield UserPostInitial();
          yield UserPostSuccess(
            posts: currentState.posts,
            hasReachedMax: false,
            hasFailedToLoadMore: true,
          );
        }
      }
    }
  }

  bool _hasReachedMax(UserPostStates state) =>
      state is UserPostSuccess && state.hasReachedMax;
}
