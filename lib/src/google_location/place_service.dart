import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class Place {
  double lat;
  double lng;

  Place({
    this.lat,
    this.lng,
  });

  @override
  String toString() {
    return 'Place(latitude: $lat, longitude: $lng)';
  }
}

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  final client = Client();

  PlaceApiProvider(this.sessionToken);

  final sessionToken;

  static final String androidKey = 'AIzaSyACwnUDLCglTA7xvX8U6azmSFoWlNzgtso';
  static final String iosKey = 'AIzaSyACwnUDLCglTA7xvX8U6azmSFoWlNzgtso';
  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    var request =
        Uri.https('maps.googleapis.com', '/maps/api/place/autocomplete/json', {
      'input': '$input',
      // 'types': 'address',
      'language': '$lang',
      'components': 'country:tz',
      'key': '$apiKey',
      'sessiontoken': '$sessionToken'
    });

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(
      request,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);

      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {
    // final request =
    //     'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$apiKey&sessiontoken=$sessionToken';

    var request =
        Uri.https('maps.googleapis.com', '/maps/api/place/details/json', {
      'place_id': '$placeId',
      // 'fields': 'address_component',
      'key': '$apiKey',
      'sessiontoken': '$sessionToken'
    });

    // final response = await client.get(request);

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(
      request,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);

      if (result['status'] == 'OK') {
        final coordinates = result['result']['geometry'];

        // build result
        final place = Place();

        place.lat = coordinates['location']['lat'];
        place.lng = coordinates['location']['lng'];

        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}
