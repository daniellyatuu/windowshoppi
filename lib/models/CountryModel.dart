import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final int id;
  final String countryName;
  final String ios2;
  final String language;
  final String countryCode;
  final String timezone;
  final String flag;

  const Country({
    this.id,
    this.countryName,
    this.ios2,
    this.language,
    this.countryCode,
    this.timezone,
    this.flag,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      countryName: json['name'],
      ios2: json['ios2'],
      language: json['language'],
      countryCode: json['countryCode'],
      timezone: json['timezone'],
      flag: json['flag'],
    );
  }

  @override
  List<Object> get props => [
        id,
        countryName,
        ios2,
        language,
        countryCode,
        timezone,
        flag,
      ];
}
