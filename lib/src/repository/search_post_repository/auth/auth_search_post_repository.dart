import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:flutter/foundation.dart';

class AuthSearchPostRepository {
  final AuthSearchPostAPIClient authSearchPostAPIClient;

  AuthSearchPostRepository({@required this.authSearchPostAPIClient});

  Future authSearchPost(postKeyword, accountId, offset, limit) {
    return authSearchPostAPIClient.authSearchPost(
        postKeyword, accountId, offset, limit);
  }
}
