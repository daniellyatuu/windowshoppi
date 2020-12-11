import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:flutter/foundation.dart';

class UserPostRepository {
  final UserPostAPIClient userPostAPIClient;

  UserPostRepository({@required this.userPostAPIClient});

  Future userPost(offset, limit, accountId) {
    return userPostAPIClient.userPost(offset, limit, accountId);
  }
}
