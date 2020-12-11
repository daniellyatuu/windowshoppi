import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id;
  final String username;
  final int accountId;
  final String accountName;
  final String accountProfile;
  final String callNumber;
  final String whatsappNumber;
  final String caption;
  final String datePosted;
  final List<Images> productPhoto;

  const Post({
    this.id,
    this.username,
    this.accountId,
    this.accountName,
    this.accountProfile,
    this.callNumber,
    this.whatsappNumber,
    this.caption,
    this.datePosted,
    this.productPhoto,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      username: json['username'],
      accountId: json['account_id'],
      accountName: json['account_name'],
      accountProfile: json['account_profile'],
      callNumber: json['call_number'],
      whatsappNumber: json['whatsapp_number'],
      caption: json['caption'],
      datePosted: json['date_posted'],
      productPhoto:
          (json['post_photos'] as List).map((i) => Images.fromJson(i)).toList(),
    );
  }

  @override
  List<Object> get props => [
        id,
        username,
        accountId,
        accountName,
        accountProfile,
        callNumber,
        whatsappNumber,
        caption,
        datePosted,
        productPhoto,
      ];

  @override
  String toString() => 'Post { id: $id }';
}

class Images {
  final String filename;

  Images({this.filename});

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      filename: json['filename'],
    );
  }
}
