import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:flutter/cupertino.dart';

class AuthenticationRepository {
  final AuthenticationAPIClient authenticationAPIClient;

  AuthenticationRepository({@required this.authenticationAPIClient})
      : assert(authenticationAPIClient != null);

  Future getUser(token) {
    return authenticationAPIClient.getUser(token);
  }
}
