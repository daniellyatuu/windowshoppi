import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final int accountId;
  final String accountName;
  final String username;
  final int group;
  final String accountProfile;

  const Account({
    this.accountId,
    this.accountName,
    this.username,
    this.group,
    this.accountProfile,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['account_id'],
      accountName: json['account_name'],
      username: json['username'],
      group: json['group'],
      accountProfile: json['account_profile'],
    );
  }

  @override
  List<Object> get props => [
        accountId,
        accountName,
        username,
        group,
        accountProfile,
      ];

  @override
  String toString() => 'Account { id: $accountId }';
}
