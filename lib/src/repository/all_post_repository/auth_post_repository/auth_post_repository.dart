import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:flutter/foundation.dart';

class AuthPostRepository {
  final AuthPostAPIClient authPostAPIClient;
  AuthPostRepository({@required this.authPostAPIClient});

  Future authPost(offset, limit, accountId) {
    return authPostAPIClient.authPost(offset, limit, accountId);
  }
}
