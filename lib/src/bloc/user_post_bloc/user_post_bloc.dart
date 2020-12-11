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
    final currentState = state;

    if (event is UserPostInsert) {
      yield UserPostInitial();
      if (currentState is UserPostSuccess) {
        currentState.posts.insert(0, event.post);
        yield UserPostSuccess(
          posts: currentState.posts,
          hasReachedMax: false,
        );
      }
    }

    if (event is UserPostFetched && !_hasReachedMax(currentState)) {
      try {
        if (currentState is UserPostInitial) {
          final _posts =
              await userPostRepository.userPost(0, 21, event.accountId);

          if (_posts == 'invalid_token') {
            yield InvalidToken();
          } else if (_posts is List<Post>) {
            final List<Post> posts = _posts;
            yield UserPostSuccess(posts: posts, hasReachedMax: false);
          }
        }
        if (currentState is UserPostSuccess) {
          final _posts = await userPostRepository.userPost(
              currentState.posts.length, 21, event.accountId);

          if (_posts == 'invalid_token') {
            yield InvalidToken();
          } else if (_posts is List<Post>) {
            final List<Post> posts = _posts;
            yield posts.isEmpty
                ? currentState.copyWith(hasReachedMax: true)
                : UserPostSuccess(
                    posts: currentState.posts + posts,
                    hasReachedMax: false,
                  );
          }
        }
      } catch (_) {
        yield UserPostFailure();
      }
    }
  }

  bool _hasReachedMax(UserPostStates state) =>
      state is UserPostSuccess && state.hasReachedMax;
}