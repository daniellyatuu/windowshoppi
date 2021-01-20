import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int userId;
  final int accountId;
  final int contactId;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String accountName;
  final String group;
  final String profileImage;
  final String accountBio;
  final String businessBio;
  final String businessLocation;
  final String call;
  final String callIsoCode;
  final String whatsapp;
  final String whatsappIsoCode;

  const User({
    this.userId,
    this.accountId,
    this.contactId,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.accountName,
    this.group,
    this.profileImage,
    this.accountBio,
    this.businessBio,
    this.businessLocation,
    this.call,
    this.callIsoCode,
    this.whatsapp,
    this.whatsappIsoCode,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      accountId: json['account_id'],
      contactId: json['contact_id'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      accountName: json['account_name'],
      group: json['group'],
      profileImage: json['profile_image'],
      accountBio: json['account_bio'],
      businessBio: json['business_bio'],
      businessLocation: json['location_name'],
      call: json['call'],
      callIsoCode: json['call_iso_code'],
      whatsapp: json['whatsapp'],
      whatsappIsoCode: json['whatsapp_iso_code'],
    );
  }

  @override
  List<Object> get props => [
        userId,
        accountId,
        contactId,
        username,
        firstName,
        lastName,
        email,
        accountName,
        group,
        profileImage,
        accountBio,
        businessBio,
        businessLocation,
        call,
        callIsoCode,
        whatsapp,
        whatsappIsoCode,
      ];
}
