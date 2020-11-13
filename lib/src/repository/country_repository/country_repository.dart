import 'package:flutter/cupertino.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';

class CountryRepository {
  final CountryAPIClient countryAPIClient;

  CountryRepository({@required this.countryAPIClient})
      : assert(countryAPIClient != null);

  Future getCountry() {
    print('step 2 : country repository');
    return countryAPIClient.getCountry();
  }
}
