import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:flutter/foundation.dart';

class AccountPostRepository {
  final AccountPostAPIClient accountPostAPIClient;

  AccountPostRepository({@required this.accountPostAPIClient});

  Future<List<Post>> accountPost(offset, limit, accountId) {
    return accountPostAPIClient.accountPost(offset, limit, accountId);
  }
}
