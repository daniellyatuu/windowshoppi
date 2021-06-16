import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/repository/account_info_repo/account_info_api_client.dart';

class AccountInfoBloc extends Bloc<AccountInfoEvents, AccountInfoStates> {
  AccountInfoBloc() : super(AccountInfoLoading());

  @override
  Stream<AccountInfoStates> mapEventToState(AccountInfoEvents event) async* {
    final currentState = state;

    if (event is GetAccountInfo) {
      try {
        final _accountInfo =
            await AccountInfoAPIClient().getAccountInfo(event.accountId);

        print('back to bloc = $_accountInfo');

        if (_accountInfo == 404) {
          yield AccountInfoNotFound();
        } else if (_accountInfo is AccountInfo) {
          yield AccountInfoSuccess(accountInfo: _accountInfo);
        }
      } catch (_) {
        yield AccountInfoError();
      }
    }

    if (event is IncrementPostNo) {
      if (currentState is AccountInfoSuccess) {
        final _accountInfo = AccountInfo(
          followerNumber: currentState.accountInfo.followerNumber,
          followingNumber: currentState.accountInfo.followingNumber,
          postNumber: currentState.accountInfo.postNumber + 1,
        );

        yield AccountInfoLoading();
        yield AccountInfoSuccess(accountInfo: _accountInfo);
      }
    }

    if (event is DecrementPostNo) {
      if (currentState is AccountInfoSuccess) {
        final _accountInfo = AccountInfo(
          followerNumber: currentState.accountInfo.followerNumber,
          followingNumber: currentState.accountInfo.followingNumber,
          postNumber: currentState.accountInfo.postNumber - 1,
        );

        yield AccountInfoLoading();
        yield AccountInfoSuccess(accountInfo: _accountInfo);
      }
    }

    if (event is IncrementFollowing) {
      if (currentState is AccountInfoSuccess) {
        final _accountInfo = AccountInfo(
          followerNumber: currentState.accountInfo.followerNumber,
          followingNumber: currentState.accountInfo.followingNumber + 1,
          postNumber: currentState.accountInfo.postNumber,
        );

        yield AccountInfoLoading();
        yield AccountInfoSuccess(accountInfo: _accountInfo);
      }
    }

    if (event is DecrementFollowing) {
      if (currentState is AccountInfoSuccess) {
        final _accountInfo = AccountInfo(
          followerNumber: currentState.accountInfo.followerNumber,
          followingNumber: currentState.accountInfo.followingNumber - 1,
          postNumber: currentState.accountInfo.postNumber,
        );

        yield AccountInfoLoading();
        yield AccountInfoSuccess(accountInfo: _accountInfo);
      }
    }
  }
}
