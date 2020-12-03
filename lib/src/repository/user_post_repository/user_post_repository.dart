import 'package:flutter/foundation.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';

class UserPostRepository {
  final UserPostAPIClient userPostAPIClient;

  UserPostRepository({@required this.userPostAPIClient});

  Future userPost(offset, limit, accountId) {
    return userPostAPIClient.userPost(offset, limit, accountId);
  }
}
