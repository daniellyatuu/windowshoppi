import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:flutter/foundation.dart';

class SearchAccountRepository {
  final SearchAccountAPIClient searchAccountAPIClient;

  SearchAccountRepository({@required this.searchAccountAPIClient});

  Future searchAccount(accountKeyword, offset, limit) {
    return searchAccountAPIClient.searchAccount(accountKeyword, offset, limit);
  }
}
