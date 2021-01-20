import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';

class CreateProfileBloc extends Bloc<CreateProfileEvents, CreateProfileStates> {
  CreateProfileBloc() : super(CreateProfileFormEmpty());

  @override
  Stream<CreateProfileStates> mapEventToState(
      CreateProfileEvents event) async* {
    if (event is SaveProfilePicture) {
      yield CreateProfileSubmitting();
      try {
        final User _user = await CreateProfileAPIClient().createProfile(
          event.accountId,
          event.contactId,
          event.picture,
        );

        if (_user is User) {
          yield CreateProfileSuccess(user: _user);
        } else {
          yield CreateProfileError();
        }
      } catch (_) {
        print(_);
        yield CreateProfileError();
      }
    }

    if (event is RemoveProfile) {
      yield RemoveProfileLoading();

      try {
        final User _user = await RemoveProfileAPIClient()
            .removeProfile(event.accountId, event.contactId);

        print('back to bloc');
        print(_user);

        if (_user is User) {
          yield RemoveProfileSuccess(user: _user);
        } else {
          yield RemoveProfileError();
        }
      } catch (_) {
        // print(_);
        // yield CreateProfileError();
      }
    }
  }
}
