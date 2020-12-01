import 'package:equatable/equatable.dart';

class WhatsappNumber extends Equatable {
  final String whatsapp;

  const WhatsappNumber({
    this.whatsapp,
  });

  factory WhatsappNumber.fromJson(Map<String, dynamic> json) {
    return WhatsappNumber(
      whatsapp: json['whatsapp'],
    );
  }

  @override
  List<Object> get props => [whatsapp];
}
