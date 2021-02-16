import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class CreatePostEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class CreatePost extends CreatePostEvents {
  final int accountId;
  final String caption;
  final String location;
  final String lat;
  final String long;
  final String url;
  final String urlText;
  final List<Asset> resultList;
  final int postType;
  CreatePost({
    @required this.accountId,
    @required this.caption,
    @required this.location,
    @required this.lat,
    @required this.long,
    @required this.url,
    @required this.urlText,
    @required this.resultList,
    @required this.postType,
  });

  @override
  List<Object> get props => [
        accountId,
        caption,
        location,
        lat,
        long,
        url,
        urlText,
        resultList,
        postType,
      ];
}

class CreateRecommendationPost extends CreatePostEvents {
  final int accountId;
  final String caption;
  final String recommendationName;
  final int recommendationType;
  final String recommendationPhoneIsoCode;
  final String recommendationPhoneDialCode;
  final String recommendationPhoneNumber;
  final String location;
  final String lat;
  final String long;
  final String url;
  final String urlText;
  final List<Asset> resultList;
  final int postType;
  CreateRecommendationPost({
    @required this.accountId,
    @required this.caption,
    @required this.recommendationName,
    @required this.recommendationType,
    @required this.recommendationPhoneIsoCode,
    @required this.recommendationPhoneDialCode,
    @required this.recommendationPhoneNumber,
    @required this.location,
    @required this.lat,
    @required this.long,
    @required this.url,
    @required this.urlText,
    @required this.resultList,
    @required this.postType,
  });

  @override
  List<Object> get props => [
        accountId,
        caption,
        recommendationName,
        recommendationType,
        recommendationPhoneIsoCode,
        recommendationPhoneDialCode,
        recommendationPhoneNumber,
        location,
        lat,
        long,
        url,
        urlText,
        resultList,
        postType,
      ];
}
