import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class CreateProfileEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class SaveProfilePicture extends CreateProfileEvents {
  final int accountId;
  final int contactId;
  final Asset picture;

  SaveProfilePicture({
    @required this.accountId,
    @required this.contactId,
    @required this.picture,
  });

  @override
  List<Object> get props => [accountId, contactId, picture];
}

class RemoveProfile extends CreateProfileEvents {
  final int accountId;
  final int contactId;
  RemoveProfile({@required this.accountId, @required this.contactId});

  @override
  List<Object> get props => [accountId, contactId];
}
