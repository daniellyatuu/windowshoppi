import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id;
  final String username;
  final String group;
  // final String accountBio;
  final String businessBio;
  final int accountId;
  // final String accountName;
  final String accountProfile;
  // final String callNumber;
  // final String whatsappNumber;
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
    // this.accountBio,
    this.businessBio,
    this.accountId,
    // this.accountName,
    this.accountProfile,
    // this.callNumber,
    // this.whatsappNumber,
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
      // accountBio: json['account_bio'],
      businessBio: json['business_bio'],
      accountId: json['account_id'],
      // accountName: json['account_name'],
      accountProfile: json['account_profile'],
      // callNumber: json['call_number'],
      // whatsappNumber: json['whatsapp_number'],
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
        // accountBio,
        businessBio,
        accountId,
        // accountName,
        accountProfile,
        // callNumber,
        // whatsappNumber,
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
