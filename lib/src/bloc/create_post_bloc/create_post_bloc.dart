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
        final Post _post = await CreatePostAPIClient().createPost(
          event.accountId,
          event.caption,
          event.location,
          event.lat,
          event.long,
          event.resultList,
        );

        if (_post is Post) {
          yield CreatePostSuccess(post: _post);
        } else {
          yield CreatePostError();
        }
      } catch (_) {
        print(_);
        yield CreatePostError();
      }
    }
  }
}
