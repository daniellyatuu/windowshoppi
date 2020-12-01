import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id;
  final int business;
  final String accountName;
  final String accountPicture;
  final String callNumber;
  final String whatsappNumber;
  final String businessLocation;
  final String caption;
  final List<Images> productPhoto;

  const Post({
    this.id,
    this.business,
    this.accountName,
    this.accountPicture,
    this.callNumber,
    this.whatsappNumber,
    this.businessLocation,
    this.caption,
    this.productPhoto,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      business: json['bussiness'],
      accountName: json['account_name'],
      accountPicture: json['account_profile'],
      callNumber: json['call_number'],
      whatsappNumber:
          json['whatsapp_number'] != null ? json['whatsapp_number'] : null,
      businessLocation: json['business_location'],
      caption: json['caption'],
      productPhoto:
          (json['post_photos'] as List).map((i) => Images.fromJson(i)).toList(),
    );
  }

  @override
  List<Object> get props => [
        id,
        business,
        accountName,
        accountPicture,
        callNumber,
        whatsappNumber,
        businessLocation,
        caption,
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
