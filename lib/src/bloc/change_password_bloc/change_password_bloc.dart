import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:bloc/bloc.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvents, ChangePasswordStates> {
  ChangePasswordBloc() : super(ChangePasswordFormEmpty());

  @override
  Stream<ChangePasswordStates> mapEventToState(
      ChangePasswordEvents event) async* {
    yield ChangePasswordFormSubmitting();

    if (event is UpdateUserPassword) {
      try {
        final data = await ChangePasswordAPIClient().changePassword(event.data);

        if (data == 'invalid_current_password') {
          yield InvalidCurrentPassword();
        } else if (data == 'success') {
          yield ChangePasswordFormSubmitted();
        } else {
          yield ChangePasswordFormError();
        }
      } catch (error) {
        yield ChangePasswordFormError();
      }
    }
  }
}
