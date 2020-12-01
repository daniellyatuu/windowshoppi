import 'package:flutter/foundation.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';

class PostRepository {
  final PostAPIClient postAPIClient;

  PostRepository({@required this.postAPIClient})
      : assert(postAPIClient != null);

  Future getPost(startIndex, limit) {
    print('step 2 : post repository');
    return postAPIClient.fetchPosts(startIndex, limit);
  }
}
