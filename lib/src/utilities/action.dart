import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as Io;
import 'dart:convert';
import 'dart:math';
import 'dart:io';

call(String userNo) {
  String phoneNumber = "tel:$userNo";
  launch(phoneNumber);
}

chat(String userWhatsappNo, String initMessage) {
  FlutterOpenWhatsapp.sendSingleMessage("$userWhatsappNo", "$initMessage");
}

Future<File> urlToFile(String imageUrl) async {
// generate random number.
  var rng = new Random();
// get temporary directory of device.
  Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
  String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
  File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.
  http.Response response = await http.get(imageUrl);
// write bodyBytes received in response to file.
  await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
  return file;
}

Future shareToWhatsapp(image) async {
  var _isSuccess;

  var _urlToFile = await urlToFile(image);

  final bytes = Io.File(_urlToFile.path).readAsBytesSync();

  String img64 = base64Encode(bytes);

  String _base64Image = "data:image/jpeg;base64," + img64;

  var result = FlutterShareMe().shareToWhatsApp(
    base64Image: _base64Image,
    msg:
        'From windowshoppi App, Download the App. \n https://play.google.com/store/apps/details?id=com.windowshoppi.windowshoppi',
  );
  await result.then(
    (value) {
      _isSuccess = value;
    },
  );

  return _isSuccess;
}
