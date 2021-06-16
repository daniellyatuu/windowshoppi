import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final int senderAccountId;
  final String content;

  const NotificationModel({
    this.senderAccountId,
    this.content,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      senderAccountId: json['sender_account'],
      content: json['content'],
    );
  }

  @override
  List<Object> get props => [
        senderAccountId,
        content,
      ];
}
