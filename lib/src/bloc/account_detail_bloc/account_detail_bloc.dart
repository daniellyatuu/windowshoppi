import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountDetailBloc extends Bloc<AccountDetailEvents, AccountDetailStates> {
  AccountDetailBloc() : super(AccountDetailLoading());

  @override
  Stream<AccountDetailStates> mapEventToState(
      AccountDetailEvents event) async* {
    if (event is GetAccountDetail) {
      try {
        final _account =
            await AccountDetailAPIClient().getAccountDetail(event.accountId);

        if (_account == 404) {
          yield AccountNotFound();
        } else if (_account is Account) {
          yield AccountDetailSuccess(account: _account);
        }
      } catch (error) {
        yield AccountDetailError();
      }
    }
  }
}
