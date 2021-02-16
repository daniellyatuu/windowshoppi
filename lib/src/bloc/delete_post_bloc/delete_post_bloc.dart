import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/repository/delete_post_repository/delete_post_api_client.dart';

class DeletePostBloc extends Bloc<DeletePostEvents, DeletePostStates> {
  DeletePostBloc() : super(DeletePostLoading());

  @override
  Stream<DeletePostStates> mapEventToState(DeletePostEvents event) async* {
    yield DeletePostLoading();

    if (event is DeletePost) {
      try {
        final _result = await DeletePostAPIClient().deletePost(event.postId);

        if (_result == 'no_internet') {
          yield DeletePostNoInternet();
        } else if (_result == 200) {
          await Future.delayed(Duration(milliseconds: 500));
          yield DeletePostSuccess();
        }
      } catch (_) {
        yield DeletePostError();
      }
    }
  }
}
