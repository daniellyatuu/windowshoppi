import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';

class PostBloc extends Bloc<PostEvents, PostStates> {
  final PostRepository postRepository;
  PostBloc({@required this.postRepository})
      : assert(postRepository != null),
        super(PostInitial());

  @override
  Stream<Transition<PostEvents, PostStates>> transformEvents(
    Stream<PostEvents> events,
    TransitionFunction<PostEvents, PostStates> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<PostStates> mapEventToState(PostEvents event) async* {
    final currentState = state;
    print('fetch post from server bloc');
    print(state);
    if (event is PostFetched && !_hasReachedMax(currentState)) {
      try {
        if (currentState is PostInitial) {
          final posts = await postRepository.getPost(0, 20);
          yield PostSuccess(posts: posts, hasReachedMax: false);
          return;
        }
        if (currentState is PostSuccess) {
          final posts =
              await postRepository.getPost(currentState.posts.length, 20);
          yield posts.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : PostSuccess(
                  posts: currentState.posts + posts,
                  hasReachedMax: false,
                );
        }
      } catch (_) {
        yield PostFailure();
      }
    }
  }

  bool _hasReachedMax(PostStates state) =>
      state is PostSuccess && state.hasReachedMax;

  // Future<List<Post>> _fetchPosts(int startIndex, int limit) async {
  //   final response = await httpClient.get(
  //       'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit');
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body) as List;
  //     return data.map((rawPost) {
  //       return Post(
  //         id: rawPost['id'],
  //       );
  //     }).toList();
  //   } else {
  //     throw Exception('error fetching posts');
  //   }
  // }
}
