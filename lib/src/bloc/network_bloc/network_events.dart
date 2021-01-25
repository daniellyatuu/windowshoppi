import 'package:windowshoppi/src/bloc/bloc_files.dart';

abstract class NetworkEvents {}

class ListenConnection extends NetworkEvents {}

class ConnectionChanged extends NetworkEvents {
  NetworkStates connection;
  ConnectionChanged(this.connection);
}
