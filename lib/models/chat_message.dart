import 'package:hive/hive.dart';

import 'message_type_adapter.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 0)
class ChatMessage extends HiveObject {
  @HiveField(0)
  String messageId;

  @HiveField(1)
  String fromId;

  @HiveField(2)
  String toId;

  @HiveField(3)
  String msg;

  @HiveField(4)
  DateTime sent;

  @HiveField(5)
  MessageType type;

  ChatMessage({
    required this.messageId,
    required this.fromId,
    required this.toId,
    required this.msg,
    required this.sent,
    required this.type,
  });
}
