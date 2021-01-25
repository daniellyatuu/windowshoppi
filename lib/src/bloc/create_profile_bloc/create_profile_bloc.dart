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

      final _user = await CreateProfileAPIClient().createProfile(
        event.accountId,
        event.contactId,
        event.picture,
      );

      if (_user == 'no_internet') {
        yield CreateProfileNoInternet();
      } else if (_user is User) {
        yield CreateProfileSuccess(user: _user);
      } else {
        yield CreateProfileError();
      }
    }

    if (event is RemoveProfile) {
      yield RemoveProfileLoading();

      final _user = await RemoveProfileAPIClient()
          .removeProfile(event.accountId, event.contactId);

      if (_user == 'no_internet') {
        yield RemoveProfileNoInternet();
      } else if (_user is User) {
        yield RemoveProfileSuccess(user: _user);
      } else {
        yield RemoveProfileError();
      }
    }
  }
}
