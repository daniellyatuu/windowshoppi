import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/repository/account_info_repo/account_info_api_client.dart';

class OtherAccountInfoBloc
    extends Bloc<OtherAccountInfoEvents, OtherAccountInfoStates> {
  OtherAccountInfoBloc() : super(OtherAccountInfoLoading());

  @override
  Stream<OtherAccountInfoStates> mapEventToState(
      OtherAccountInfoEvents event) async* {
    final currentState = state;

    if (event is GetOtherAccountInfo) {
      try {
        final _accountInfo =
            await AccountInfoAPIClient().getAccountInfo(event.accountId);

        print('back to bloc = $_accountInfo');

        if (_accountInfo == 404) {
          yield OtherAccountInfoNotFound();
        } else if (_accountInfo is AccountInfo) {
          yield OtherAccountInfoSuccess(accountInfo: _accountInfo);
        }
      } catch (_) {
        yield OtherAccountInfoError();
      }
    }
  }
}
