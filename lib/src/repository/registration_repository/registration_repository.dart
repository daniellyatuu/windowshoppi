import 'package:flutter/foundation.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';

class RegistrationRepository {
  final RegistrationAPIClient registrationAPIClient;

  RegistrationRepository({@required this.registrationAPIClient})
      : assert(registrationAPIClient != null);

  Future registerUser(data) {
    return registrationAPIClient.registerUser(data);
  }
}
