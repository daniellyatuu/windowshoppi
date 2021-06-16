import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class OtherAccountInfoEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class GetOtherAccountInfo extends OtherAccountInfoEvents {
  final int accountId;
  GetOtherAccountInfo({@required this.accountId});
}
