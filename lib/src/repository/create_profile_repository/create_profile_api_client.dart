import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/api.dart';
import 'package:http/http.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';

class CreateProfileAPIClient {
  Future createProfile(accountId, contactId, picture) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    var _url = UPDATE_PROFILE_PICTURE + '$accountId' + '/';

    Uri uri = Uri.parse(_url);

    // create multipart request
    MultipartRequest request = http.MultipartRequest("POST", uri);

    String fileName = 'profile_picture_' + accountId.toString() + '_' + '.jpg';

    ByteData byteData = await picture.getByteData(quality: 60);

    List<int> imageData = byteData.buffer.asUint8List();

    MultipartFile multipartFile = MultipartFile.fromBytes(
      'profile_picture',
      imageData,
      filename: fileName,
      // contentType: MediaType("image", "jpg"),
    );
    request.files.add(multipartFile);

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    };

    // add headers
    request.headers.addAll(headers);

    // send
    var response = await request.send();

    print(response.statusCode);

    if (response.statusCode == 200) {
      final getUserResponse = await http.get(
        USER_DATA,
        headers: {HttpHeaders.authorizationHeader: "Token $token"},
      );

      if (getUserResponse.statusCode == 200) {
        return compute(_parseUser, getUserResponse.body);
      } else {
        throw Exception('Error fetching data from server');
      }
    }
  }
}

User _parseUser(String responseData) {
  final parsed = jsonDecode(responseData);

  return User.fromJson(parsed);
}
