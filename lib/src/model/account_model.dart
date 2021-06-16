import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final int accountId;
  final bool isFollowed;
  final String accountName;
  final String username;
  final String group;
  final String email;
  final String call;
  final String callDialCode;
  final String whatsapp;
  final String whatsappDialCode;
  final String accountProfile;
  final String accountBio;
  final String businessBio;

  const Account({
    this.accountId,
    this.isFollowed,
    this.accountName,
    this.username,
    this.group,
    this.email,
    this.call,
    this.callDialCode,
    this.whatsapp,
    this.whatsappDialCode,
    this.accountProfile,
    this.accountBio,
    this.businessBio,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['account_id'],
      isFollowed: json['is_followed'],
      accountName: json['account_name'],
      username: json['username'],
      group: json['group'],
      email: json['email'],
      call: json['call_number'],
      callDialCode: json['call_dial_code'],
      whatsapp: json['whatsapp_number'],
      whatsappDialCode: json['whatsapp_dial_code'],
      accountProfile: json['profile_image'],
      accountBio: json['account_bio'],
      businessBio: json['business_bio'],
    );
  }

  @override
  List<Object> get props => [
        accountId,
        isFollowed,
        accountName,
        username,
        group,
        email,
        call,
        callDialCode,
        whatsapp,
        whatsappDialCode,
        accountProfile,
        accountBio,
        businessBio,
      ];

  @override
  String toString() => 'Account { id: $accountId }';
}
