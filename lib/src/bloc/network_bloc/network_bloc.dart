import 'dart:async';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class NetworkBloc extends Bloc<NetworkEvents, NetworkStates> {
  NetworkBloc() : super(ConnectionInitial());

  StreamSubscription _subscription;

  @override
  Stream<NetworkStates> mapEventToState(NetworkEvents event) async* {
    if (event is ListenConnection) {
      _subscription = DataConnectionChecker().onStatusChange.listen((status) {
        add(
          ConnectionChanged(
            status == DataConnectionStatus.disconnected
                ? ConnectionFailure()
                : ConnectionSuccess(prevState: state),
          ),
        );
      });
    }
    if (event is ConnectionChanged) yield event.connection;
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
