import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:windowshoppi/api.dart';
import 'package:windowshoppi/src/model/model_files.dart';

class CreatePostAPIClient {
  Future createPost(accountId, caption, location, lat, long, imageList) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    Uri uri = Uri.parse(USER_CREATE_POST);

    // create multipart request
    MultipartRequest request = http.MultipartRequest("POST", uri);

    var i = 0;
    for (var imageFile in imageList) {
      i += 1;
      String fileName =
          'image_' + accountId.toString() + '_' + i.toString() + '.jpg';

      ByteData byteData = await imageFile.getByteData(quality: 60);

      List<int> imageData = byteData.buffer.asUint8List();

      MultipartFile multipartFile = MultipartFile.fromBytes(
        'filename',
        imageData,
        filename: fileName,
        // contentType: MediaType("image", "jpg"),
      );
      request.files.add(multipartFile);
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    };

    // add headers
    request.headers.addAll(headers);

    request.fields['account'] = accountId.toString();
    request.fields['caption'] = caption;
    if (location != null) request.fields['location_name'] = location;
    if (lat != null) request.fields['latitude'] = lat;
    if (long != null) request.fields['longitude'] = long;

    // send
    var response = await request.send();

    if (response.statusCode == 501) {
      throw Exception('Error on uploading post');
    }

    if (response.statusCode == 201) {
      String result = await utf8.decoder.bind(response.stream).join();

      var _postResult = json.decode(result);

      // get post data
      int _postId = _postResult['id'];

      var _postUrl = USER_SINGLE_POST_DATA + "$_postId/";

      final getPostResponse = await http.get(
        _postUrl,
        headers: {HttpHeaders.authorizationHeader: "Token $token"},
      );

      if (getPostResponse.statusCode == 200) {
        return compute(_parseUser, getPostResponse.body);
      } else {
        throw Exception('Error fetching data from server');
      }
    }
  }
}

Post _parseUser(String responseData) {
  final parsed = jsonDecode(responseData);

  return Post.fromJson(parsed);
}
