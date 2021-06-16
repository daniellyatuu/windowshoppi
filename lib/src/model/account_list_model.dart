import 'package:equatable/equatable.dart';

class AccountListModel extends Equatable {
  final int accountId;
  final bool isFollowed;
  final String accountName;
  final String username;
  final String group;
  final String accountProfile;
  final List<dynamic> postImages;

  const AccountListModel({
    this.accountId,
    this.isFollowed,
    this.accountName,
    this.username,
    this.group,
    this.accountProfile,
    this.postImages,
  });

  factory AccountListModel.fromJson(Map<String, dynamic> json) {
    return AccountListModel(
      accountId: json['account_id'],
      isFollowed: json['is_followed'],
      accountName: json['account_name'],
      username: json['username'],
      group: json['group'],
      accountProfile: json['profile_image'],
      postImages: json['first_three_post'],
    );
  }

  @override
  List<Object> get props => [
        accountId,
        isFollowed,
        accountName,
        username,
        group,
        accountProfile,
        postImages,
      ];

  @override
  String toString() => 'AccountListModel { id: $accountId }';
}
