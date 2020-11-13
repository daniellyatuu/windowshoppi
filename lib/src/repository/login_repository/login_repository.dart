import 'package:flutter/foundation.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';

class LoginRepository {
  final LoginAPIClient loginAPIClient;

  LoginRepository({@required this.loginAPIClient})
      : assert(loginAPIClient != null);

  Future userLogin(data) {
    return loginAPIClient.userLogin(data);
  }
}
