import 'package:hive_flutter/hive_flutter.dart';

enum MessageType { text, image }

class MessageTypeAdapter extends TypeAdapter<MessageType> {
  @override
  final typeId = 1;

  @override
  MessageType read(BinaryReader reader) {
    return MessageType.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, MessageType obj) {
    writer.writeByte(obj.index);
  }
}
