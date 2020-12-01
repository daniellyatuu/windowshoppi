// import 'package:windowshoppi/src/model/model_files.dart';
// import 'package:windowshoppi/src/repository/repository_files.dart';
// import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';

class SwitchToBusinessBloc
    extends Bloc<SwitchToBusinessEvents, SwitchToBusinessStates> {
  SwitchToBusinessBloc() : super(SwitchToBusinessFormEmpty());

  @override
  Stream<SwitchToBusinessStates> mapEventToState(
      SwitchToBusinessEvents event) async* {
    print('to bloc for Daniel');
    yield SwitchToBusinessSubmitting();

    if (event is SwitchToBusinessAccount) {
      try {
        final _user = await SwitchToBusinessAPIClient()
            .switchAccount(event.accountId, event.contactId, event.data);

        print('back to bloc');
        print(_user);
        if (_user == 'user_exists') {
          yield SwitchToBusinessUserExist();
        } else if (_user is User) {
          final User user = _user;
          yield SwitchToBusinessFormSubmitted(user: _user);
        }
      } catch (error) {
        yield SwitchToBusinessFormError();
      }
    }
  }
}

// class WindowshopperProfileUpdateBloc extends Bloc<
//     WindowshopperProfileUpdateEvents, WindowshopperProfileUpdateStates> {
//   WindowshopperProfileUpdateBloc()
//       : super(WindowshopperProfileUpdateFormEmpty());
//
//   @override
//   Stream<WindowshopperProfileUpdateStates> mapEventToState(
//       WindowshopperProfileUpdateEvents event) async* {
//     yield WindowshopperProfileUpdateSubmitting();
//
//     if (event is UpdateWindowshopperProfile) {
//       try {
//         final _user = await WindowshopperProfileUpdateAPIClient()
//             .updateProfile(event.accountId, event.contactId, event.data);
//
//         print('back to bloc');
//         print(_user);
//         if (_user == 'user_exists') {
//           yield WindowshopperProfileUpdateUserExist();
//         } else if (_user is User) {
//           final User user = _user;
//           yield WindowshopperProfileUpdateFormSubmitted(user: _user);
//         }
//       } catch (error) {
//         yield WindowshopperProfileUpdateFormError();
//       }
//     }
//   }
// }
