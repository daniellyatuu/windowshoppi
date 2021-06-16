import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id;
  final String username;
  final String group;
  final String businessBio;
  final int accountId;
  final bool isFollowed;
  final String accountProfile;
  final String caption;
  final String recommendationName;
  final String recommendationType;
  final String recommendationPhoneIsoCode;
  final String recommendationPhoneDialCode;
  final String recommendationPhoneNumber;
  final bool isUrlValid;
  final String url;
  final String urlText;
  final String taggedLocation;
  final double latitude;
  final double longitude;
  final String datePosted;
  final List<Images> productPhoto;
  final String postType;

  const Post({
    this.id,
    this.username,
    this.group,
    this.businessBio,
    this.accountId,
    this.isFollowed,
    this.accountProfile,
    this.caption,
    this.recommendationName,
    this.recommendationType,
    this.recommendationPhoneIsoCode,
    this.recommendationPhoneDialCode,
    this.recommendationPhoneNumber,
    this.isUrlValid,
    this.url,
    this.urlText,
    this.taggedLocation,
    this.latitude,
    this.longitude,
    this.datePosted,
    this.productPhoto,
    this.postType,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      username: json['username'],
      group: json['group'],
      businessBio: json['business_bio'],
      accountId: json['account_id'],
      isFollowed: json['is_followed'],
      accountProfile: json['account_profile'],
      caption: json['caption'],
      recommendationName: json['recommendation_name'],
      recommendationType: json['recommendation_type'],
      recommendationPhoneIsoCode: json['recommendation_phone_iso_code'],
      recommendationPhoneDialCode: json['recommendation_phone_dial_code'],
      recommendationPhoneNumber: json['recommendation_phone_number'],
      isUrlValid: json['is_url_valid'],
      url: json['url'],
      urlText: json['url_action_text'],
      taggedLocation: json['location_name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      datePosted: json['date_posted'],
      productPhoto:
          (json['post_photos'] as List).map((i) => Images.fromJson(i)).toList(),
      postType: json['post_type'],
    );
  }

  @override
  List<Object> get props => [
        id,
        username,
        group,
        businessBio,
        accountId,
        isFollowed,
        accountProfile,
        caption,
        recommendationName,
        recommendationType,
        recommendationPhoneIsoCode,
        recommendationPhoneDialCode,
        recommendationPhoneNumber,
        isUrlValid,
        url,
        urlText,
        taggedLocation,
        latitude,
        longitude,
        datePosted,
        productPhoto,
        postType,
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
