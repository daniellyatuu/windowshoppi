import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id;
  final String username;
  final String group;
  final String accountBio;
  final String businessBio;
  final int accountId;
  final String accountName;
  final String accountProfile;
  final String callNumber;
  final String whatsappNumber;
  final String caption;
  final String taggedLocation;
  final String datePosted;
  final List<Images> productPhoto;

  const Post({
    this.id,
    this.username,
    this.group,
    this.accountBio,
    this.businessBio,
    this.accountId,
    this.accountName,
    this.accountProfile,
    this.callNumber,
    this.whatsappNumber,
    this.caption,
    this.taggedLocation,
    this.datePosted,
    this.productPhoto,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      username: json['username'],
      group: json['group'],
      accountBio: json['account_bio'],
      businessBio: json['business_bio'],
      accountId: json['account_id'],
      accountName: json['account_name'],
      accountProfile: json['account_profile'],
      callNumber: json['call_number'],
      whatsappNumber: json['whatsapp_number'],
      caption: json['caption'],
      taggedLocation: json['location_name'],
      datePosted: json['date_posted'],
      productPhoto:
          (json['post_photos'] as List).map((i) => Images.fromJson(i)).toList(),
    );
  }

  @override
  List<Object> get props => [
        id,
        username,
        group,
        accountBio,
        businessBio,
        accountId,
        accountName,
        accountProfile,
        callNumber,
        whatsappNumber,
        caption,
        taggedLocation,
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
