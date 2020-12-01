import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class WhatsappNumberEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class SaveUserWhatsappNumber extends WhatsappNumberEvents {
  final int contactId;
  final dynamic data;
  SaveUserWhatsappNumber({@required this.contactId, @required this.data})
      : assert(contactId != null, data != null);

  @override
  List<Object> get props => [contactId, data];
}
