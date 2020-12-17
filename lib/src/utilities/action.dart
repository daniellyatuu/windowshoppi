import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:url_launcher/url_launcher.dart';

call(String userNo) {
  String phoneNumber = "tel:$userNo";
  launch(phoneNumber);
}

chat(String userWhatsappNo, String initMessage) {
  FlutterOpenWhatsapp.sendSingleMessage("$userWhatsappNo", "$initMessage");
}
