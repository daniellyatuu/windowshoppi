import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:bloc/bloc.dart';

class WhatsappNumberBloc
    extends Bloc<WhatsappNumberEvents, WhatsappNumberStates> {
  WhatsappNumberBloc() : super(WhatsappNumberFormEmpty());

  @override
  Stream<WhatsappNumberStates> mapEventToState(
      WhatsappNumberEvents event) async* {
    yield WhatsappNumberFormSubmitting();

    if (event is SaveUserWhatsappNumber) {
      try {
        final User _user = await WhatsappNumberAPIClient()
            .saveNumber(event.contactId, event.data);

        yield WhatsappNumberFormSubmitted(user: _user);
      } catch (error) {
        yield WhatsappNumberFormError();
      }
    }
  }
}
