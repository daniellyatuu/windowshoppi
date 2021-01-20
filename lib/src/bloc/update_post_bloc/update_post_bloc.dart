import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';

class UpdatePostBloc extends Bloc<UpdatePostEvents, UpdatePostStates> {
  UpdatePostBloc() : super(UpdatePostFormEmpty());

  @override
  Stream<UpdatePostStates> mapEventToState(UpdatePostEvents event) async* {
    yield UpdatePostSubmitting();
    if (event is UpdatePost) {
      print('product id = ${event.postId}');
      try {
        final Post _post =
            await UpdatePostAPIClient().updatePost(event.postId, event.data);

        if (_post is Post) {
          yield UpdatePostSuccess(newPost: _post);
        } else {
          yield UpdatePostError();
        }
      } catch (_) {
        print(_);
        yield UpdatePostError();
      }
    }
  }
}
