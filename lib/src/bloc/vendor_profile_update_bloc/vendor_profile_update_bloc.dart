import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:bloc/bloc.dart';

class VendorProfileUpdateBloc
    extends Bloc<VendorProfileUpdateEvents, VendorProfileUpdateStates> {
  VendorProfileUpdateBloc() : super(VendorProfileUpdateFormEmpty());

  @override
  Stream<VendorProfileUpdateStates> mapEventToState(
      VendorProfileUpdateEvents event) async* {
    yield VendorProfileUpdateSubmitting();

    if (event is UpdateVendorProfile) {
      try {
        final _user = await VendorProfileUpdateAPIClient()
            .vendorUpdateProfile(event.accountId, event.contactId, event.data);

        if (_user == 'no_internet') {
          yield VendorProfileUpdateNoInternet();
        } else if (_user == 'user_exists') {
          yield VendorProfileUpdateUserExist();
        } else if (_user is User) {
          yield VendorProfileUpdateFormSubmitted(user: _user);
        }
      } catch (_) {
        yield VendorProfileUpdateFormError();
      }
    }
  }
}
