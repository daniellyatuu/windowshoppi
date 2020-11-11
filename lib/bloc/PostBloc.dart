// import 'dart:convert';
// import 'package:bloc/bloc.dart';
// import 'package:flutter/foundation.dart';
// import 'package:windowshoppi/bloc/PostEvent.dart';
// import 'package:windowshoppi/bloc/PostState.dart';
// import 'package:meta/meta.dart';
// import 'package:http/http.dart' as http;
// import 'package:windowshoppi/models/global.dart';
// import 'package:windowshoppi/models/post.dart';
// import 'package:rxdart/rxdart.dart';
//
// class PostBloc extends Bloc<PostEvent, PostState> {
//   final http.Client httpClient;
//
//   PostBloc({@required this.httpClient}) : super(PostInitial());
//
//   @override
//   Stream<Transition<PostEvent, PostState>> transformEvents(
//     Stream<PostEvent> events,
//     TransitionFunction<PostEvent, PostState> transitionFn,
//   ) {
//     return super.transformEvents(
//       events.debounceTime(const Duration(milliseconds: 500)),
//       transitionFn,
//     );
//   }
//
//   @override
//   Stream<PostState> mapEventToState(PostEvent event) async* {
//     final currentState = state;
//     bool _reachedMax = _hasReachedMax(currentState);
//     var _event = event;
//     PostState _currentState = currentState;
//
//     print(_reachedMax);
//     print(_event);
//     print(_currentState);
//
//     if (_event is PostFetched && !_reachedMax) {
//       try {
//         if (_currentState is PostInitial) {
//           final posts = await _fetchPosts(0, 40);
//           print('for post init');
//           print(posts);
//           yield PostSuccess(posts: posts, hasReachedMax: false);
//           return;
//         }
//         if (_currentState is PostSuccess) {
//           final posts = await _fetchPosts(_currentState.posts.length, 40);
//           print('for post success');
//           print(posts);
//           yield posts.isEmpty
//               ? _currentState.copyWith(hasReachedMax: true)
//               : PostSuccess(
//                   posts: _currentState.posts + posts,
//                   hasReachedMax: false,
//                 );
//         }
//       } catch (_) {
//         yield PostFailure();
//       }
//     }
//   }
//
//   // bool _hasReachedMax(PostState state) =>
//   //     state is PostSuccess && state.hasReachedMax;
//
//   bool _hasReachedMax(PostState state) => false;
//
//   Future<List<Post>> _fetchPosts(int startIndex, int limit) async {
//     final response = await httpClient.get(
//         POST_API + '?category=0&country=1&offset=$startIndex&limit=$limit');
//     // print(response.statusCode);
//     // print(response.body);
//     if (response.statusCode == 200) {
//       return compute(parseProducts, response.body);
//     } else {
//       throw Exception('error fetching posts');
//     }
//     // if (response.statusCode == 200) {
//     //   var _postData = json.decode(response.body);
//     //   final data = _postData as List;
//     //   print(_postData['result']);
//     //   return data.map((json) {
//     //     return Post(
//     //       id: json['id'],
//     //       business: json['bussiness'],
//     //       accountName: json['account_name'],
//     //       accountPicture: json['account_profile'],
//     //       callNumber: json['call_number'],
//     //       whatsappNumber:
//     //           json['whatsapp_number'] != null ? json['whatsapp_number'] : null,
//     //       businessLocation: json['business_location'],
//     //       caption: json['caption'],
//     //       // productPhoto: (json['post_photos'] as List)
//     //       //     .map((i) => Images.fromJson(i))
//     //       //     .toList(),
//     //     );
//     //   }).toList();
//     // } else {
//     //   throw Exception('error fetching posts');
//     // }
//   }
// }
//
// List<Post> parseProducts(String responseBody) {
//   final parsed = jsonDecode(responseBody);
//
//   final parsed1 = parsed['results'].cast<Map<String, dynamic>>();
//
//   return parsed1.map<Post>((json) => Post.fromJson(json)).toList();
// }

import 'package:bloc/bloc.dart';
import 'package:windowshoppi/bloc/bloc.dart';
import 'package:windowshoppi/repository/repository.dart';
import 'package:windowshoppi/models/models.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class PostBloc extends Bloc<PostEvents, PostStates> {
  final PostsRepository postsRepository;
  PostBloc({@required this.postsRepository})
      : assert(postsRepository != null),
        super(PostEmpty());

  // @override
  // Stream<Transition<PostEvents, PostStates>> transformEvents(
  //   Stream<PostEvents> events,
  //   TransitionFunction<PostEvents, PostStates> transitionFn,
  // ) {
  //   return super.transformEvents(
  //     events.debounceTime(const Duration(milliseconds: 500)),
  //     transitionFn,
  //   );
  // }

  @override
  Stream<PostStates> mapEventToState(
    PostEvents event,
  ) async* {
    // print('step 1 : bloc');
    // print(event);
    if (event is FetchPosts) {
      yield PostLoading();
      try {
        if (event.keyword != '') {
          final List<Post> post = await postsRepository.getPosts(event.keyword);
          yield PostLoaded(post: post);
        } else {
          yield PostEmpty();
        }
      } catch (error) {
        print(error);
        yield PostError();
      }
    } else if (event is RefreshPosts) {
      try {
        if (event.keyword != '') {
          final List<Post> post = await postsRepository.getPosts(event.keyword);
          yield PostLoaded(post: post);
        } else {
          yield PostEmpty();
        }
      } catch (error) {
        print("Error" + error);
        yield state;
      }
    } else if (event is ResetPosts) {
      print('empty');
      yield PostEmpty();
    }
  }
}
