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
  Future createPost(accountId, caption, imageList) async {
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

    // send
    var response = await request.send();

    if (response.statusCode == 201) {
      String result = await utf8.decoder.bind(response.stream).join();
      print(result);
      var _postResult = json.decode(result);

      print('result was returned');

      // get post data
      // USER_SINGLE_POST_DATA
      int _postId = _postResult['id'];

      var _postUrl = USER_SINGLE_POST_DATA + "$_postId/";

      print(_postUrl);

      final getPostResponse = await http.get(
        _postUrl,
        headers: {HttpHeaders.authorizationHeader: "Token $token"},
      );

      print(getPostResponse.statusCode);
      print(getPostResponse.body);

      if (getPostResponse.statusCode == 200) {
        return compute(_parseUser, getPostResponse.body);
      } else {
        throw Exception('Error fetching data from server');
      }

      // if (response.statusCode == 200) {
      //   return compute(parseUser, response.body);
      // } else {
      //   throw Exception('Error fetching data from server');
      // }
      // var _post = Post.fromJson(jsonDecode(result));
      // return _post;
    }

    // // listen for response
    // response.stream.transform(utf8.decoder).listen((result) async {
    //   print(result);
    //   return result;
    //   // if (result == '"success"') {
    //   //   clearImage(); // remove images
    //   //   _notification('Post created successfully', Colors.black, Colors.red);
    //   //   fetchProduct(VENDOR_POST, removeListData = true, firstLoading = true);
    //   // }
    // });
    //
    // if (response.statusCode == 201) {
    //   return 'created';
    // } else {
    //   return 'error';
    // }
  }
}

Post _parseUser(String responseData) {
  final parsed = jsonDecode(responseData);

  return Post.fromJson(parsed);
}
