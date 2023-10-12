import 'package:hive/hive.dart';
import 'package:swiss_chat_app/models/chat_message.dart';

class Boxes {
  static Box<ChatMessage> getChatMessages() =>
      Hive.box<ChatMessage>('chatMessages');
}
