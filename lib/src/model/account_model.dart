import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final int accountId;
  final String accountName;
  final String username;
  final String group;
  final String email;
  final String call;
  final String whatsapp;
  final String accountProfile;
  final String accountBio;
  final String businessBio;

  const Account({
    this.accountId,
    this.accountName,
    this.username,
    this.group,
    this.email,
    this.call,
    this.whatsapp,
    this.accountProfile,
    this.accountBio,
    this.businessBio,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['account_id'],
      accountName: json['account_name'],
      username: json['username'],
      group: json['group'],
      email: json['email'],
      call: json['call_number'],
      whatsapp: json['whatsapp_number'],
      accountProfile: json['account_profile'],
      accountBio: json['account_bio'],
      businessBio: json['business_bio'],
    );
  }

  @override
  List<Object> get props => [
        accountId,
        accountName,
        username,
        group,
        email,
        call,
        whatsapp,
        accountProfile,
        accountBio,
        businessBio,
      ];

  @override
  String toString() => 'Account { id: $accountId }';
}
