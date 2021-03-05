import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:flutter/foundation.dart';

class AllPostRepository {
  final AllPostAPIClient allPostAPIClient;
  AllPostRepository({@required this.allPostAPIClient});

  Future userPost(offset, limit) {
    return allPostAPIClient.allPost(offset, limit);
  }
}
