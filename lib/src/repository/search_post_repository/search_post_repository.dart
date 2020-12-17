import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:flutter/foundation.dart';

class SearchPostRepository {
  final SearchPostAPIClient searchPostAPIClient;

  SearchPostRepository({@required this.searchPostAPIClient});

  Future searchPost(postKeyword, offset, limit) {
    return searchPostAPIClient.searchPost(postKeyword, offset, limit);
  }
}
