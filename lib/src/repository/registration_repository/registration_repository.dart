import 'package:flutter/foundation.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';

class RegistrationRepository {
  final RegistrationAPIClient registrationAPIClient;

  RegistrationRepository({@required this.registrationAPIClient})
      : assert(registrationAPIClient != null);

  Future registerUser(data) {
    print('step 2 : register repository');
    return registrationAPIClient.registerUser(data);
  }
}
