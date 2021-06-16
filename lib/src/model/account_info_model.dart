import 'package:equatable/equatable.dart';

class AccountInfo extends Equatable {
  final int followerNumber;
  final int followingNumber;
  final int postNumber;

  const AccountInfo({
    this.followerNumber,
    this.followingNumber,
    this.postNumber,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    return AccountInfo(
      followerNumber: json['follower_number'],
      followingNumber: json['following_number'],
      postNumber: json['post_number'],
    );
  }

  @override
  List<Object> get props => [
        followerNumber,
        followingNumber,
        postNumber,
      ];
}
