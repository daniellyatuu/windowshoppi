import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/api.dart';
import 'package:http/http.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';

class CreatePostAPIClient {
  Future createPost({
    @required accountId,
    @required caption,
    @required location,
    @required lat,
    @required long,
    @required url,
    @required urlText,
    @required imageList,
    @required postType,
  }) async {
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var token = localStorage.getString('token');

      Uri uri = Uri.parse(userCreatePostUri);

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
      if (url != '') request.fields['url'] = url;
      if (url != '') request.fields['url_action_text'] = urlText;
      request.fields['post_type'] = postType.toString();

      // send
      var response = await request.send();

      if (response.statusCode == 201) {
        String result = await utf8.decoder.bind(response.stream).join();

        var _postResult = json.decode(result);

        // get post data
        int _postId = _postResult['id'];

        var _postUrl = userSinglePostDataUri + "$_postId/";
        var _url = Uri.http('$getRequestServerName', '$_postUrl');

        final getPostResponse = await http.get(
          _url,
          headers: {HttpHeaders.authorizationHeader: "Token $token"},
        );

        if (getPostResponse.statusCode == 200) {
          return compute(_parsePost, getPostResponse.body);
        } else {
          throw Exception('Error fetching data from server');
        }
      } else {
        throw Exception('Error on uploading post');
      }
    } on SocketException {
      return 'no_internet';
    }
  }
}

Post _parsePost(String responseData) {
  final parsed = jsonDecode(responseData);

  return Post.fromJson(parsed);
}
