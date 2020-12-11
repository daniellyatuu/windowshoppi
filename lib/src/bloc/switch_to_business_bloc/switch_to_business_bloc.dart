import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:bloc/bloc.dart';

class SwitchToBusinessBloc
    extends Bloc<SwitchToBusinessEvents, SwitchToBusinessStates> {
  SwitchToBusinessBloc() : super(SwitchToBusinessFormEmpty());

  @override
  Stream<SwitchToBusinessStates> mapEventToState(
      SwitchToBusinessEvents event) async* {
    yield SwitchToBusinessSubmitting();

    if (event is SwitchToBusinessAccount) {
      try {
        final _user = await SwitchToBusinessAPIClient()
            .switchAccount(event.accountId, event.contactId, event.data);

        if (_user == 'user_exists') {
          yield SwitchToBusinessUserExist();
        } else if (_user is User) {
          yield SwitchToBusinessFormSubmitted(user: _user);
        }
      } catch (error) {
        yield SwitchToBusinessFormError();
      }
    }
  }
}
