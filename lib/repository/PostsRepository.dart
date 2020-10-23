import 'package:flutter/cupertino.dart';
import 'package:windowshoppi/models/models.dart';
import 'package:windowshoppi/repository/PostsAPIClient.dart';

class PostsRepository {
  final PostsAPIClient postsAPIClient;

  PostsRepository({@required this.postsAPIClient})
      : assert(postsAPIClient != null);

  Future getPosts(String keyword) {
    // print('step 2 : post repository');
    return postsAPIClient.getPosts(keyword);
  }
}
