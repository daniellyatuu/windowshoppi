import 'package:windowshoppi/src/utilities/database_helper.dart';

activeCountry() async {
  final dbHelper = DatabaseHelper.instance;

  var activeCountryData = await dbHelper.getActiveCountryFromUserTable();
  if (activeCountryData == null) {
    print('get country data');
    // var _country = await _fetchCountry();
    // return _country;
  } else {
    return activeCountryData;
  }
}
