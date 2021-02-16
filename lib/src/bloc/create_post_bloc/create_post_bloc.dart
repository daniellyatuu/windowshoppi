import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';

class CreatePostBloc extends Bloc<CreatePostEvents, CreatePostStates> {
  CreatePostBloc() : super(CreatePostFormEmpty());

  @override
  Stream<CreatePostStates> mapEventToState(CreatePostEvents event) async* {
    yield CreatePostSubmitting();

    if (event is CreatePost) {
      try {
        final _post = await CreatePostAPIClient().createPost(
          accountId: event.accountId,
          caption: event.caption,
          location: event.location,
          lat: event.lat,
          long: event.long,
          url: event.url,
          urlText: event.urlText,
          imageList: event.resultList,
          postType: event.postType,
        );

        if (_post == 'no_internet') {
          yield CreatePostNoInternet();
        } else if (_post is Post) {
          yield CreatePostSuccess(post: _post);
        }
      } catch (_) {
        yield CreatePostError();
      }
    }

    if (event is CreateRecommendationPost) {
      try {
        final _post =
            await CreateRecommendationAPIClient().createRecommendation(
          accountId: event.accountId,
          caption: event.caption,
          recommendationName: event.recommendationName,
          recommendationType: event.recommendationType,
          recommendationPhoneIsoCode: event.recommendationPhoneIsoCode,
          recommendationPhoneDialCode: event.recommendationPhoneDialCode,
          recommendationPhoneNumber: event.recommendationPhoneNumber,
          location: event.location,
          lat: event.lat,
          long: event.long,
          url: event.url,
          urlText: event.urlText,
          imageList: event.resultList,
          postType: event.postType,
        );

        if (_post == 'no_internet') {
          yield CreatePostNoInternet();
        } else if (_post is Post) {
          yield CreatePostSuccess(post: _post);
        }
      } catch (_) {
        yield CreatePostError();
      }
    }
  }
}
