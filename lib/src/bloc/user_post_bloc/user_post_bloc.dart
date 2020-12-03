import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';

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

    print('in bloc');
    print('current state = $currentState');
    print(event);

    print('has reached end = ${_hasReachedMax(currentState)}');

    if (event is UserPostFetched && !_hasReachedMax(currentState)) {
      print('get user data');
      try {
        if (currentState is UserPostInitial) {
          print('get data for first time');
          final _posts =
              await userPostRepository.userPost(0, 20, event.accountId);
          print(_posts);

          if (_posts == 'invalid_token') {
            yield InvalidToken();
          } else if (_posts is List<Post>) {
            final List<Post> posts = _posts;
            yield UserPostSuccess(posts: posts, hasReachedMax: false);
          }
          // final posts = await _fetchPosts(0, 20);
          // yield PostSuccess(posts: posts, hasReachedMax: false);
          // return;
        }
        // if (currentState is PostSuccess) {
        //   final posts = await _fetchPosts(currentState.posts.length, 20);
        //   yield posts.isEmpty
        //       ? currentState.copyWith(hasReachedMax: true)
        //       : PostSuccess(
        //     posts: currentState.posts + posts,
        //     hasReachedMax: false,
        //   );
        // }
      } catch (_) {
        yield UserPostFailure();
      }
    }
  }

  // @override
  // Stream<PostState> mapEventToState(PostEvent event) async* {
  //   final currentState = state;
  //   if (event is PostFetched && !_hasReachedMax(currentState)) {
  //     try {
  //       if (currentState is PostInitial) {
  //         final posts = await _fetchPosts(0, 20);
  //         yield PostSuccess(posts: posts, hasReachedMax: false);
  //         return;
  //       }
  //       if (currentState is PostSuccess) {
  //         final posts = await _fetchPosts(currentState.posts.length, 20);
  //         yield posts.isEmpty
  //             ? currentState.copyWith(hasReachedMax: true)
  //             : PostSuccess(
  //                 posts: currentState.posts + posts,
  //                 hasReachedMax: false,
  //               );
  //       }
  //     } catch (_) {
  //       yield PostFailure();
  //     }
  //   }
  // }

  bool _hasReachedMax(UserPostStates state) =>
      state is UserPostSuccess && state.hasReachedMax;

  // Future<List<Post>> _fetchPosts(int startIndex, int limit) async {
  //   final response = await httpClient.get(
  //       'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit');
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body) as List;
  //     return data.map((rawPost) {
  //       return Post(
  //         id: rawPost['id'],
  //         title: rawPost['title'],
  //         body: rawPost['body'],
  //       );
  //     }).toList();
  //   } else {
  //     throw Exception('error fetching posts');
  //   }
  // }
}
