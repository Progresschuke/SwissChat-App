// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      toId: json['toId'] as String,
      msg: json['msg'] as String,
      read: json['read'] as String,
      type: $enumDecode(_$TypeEnumMap, json['type']),
      fromId: json['fromId'] as String,
      sent: json['sent'] as String,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'toId': instance.toId,
      'msg': instance.msg,
      'read': instance.read,
      'fromId': instance.fromId,
      'sent': instance.sent,
      'type': _$TypeEnumMap[instance.type]!,
    };

const _$TypeEnumMap = {
  Type.text: 'text',
  Type.image: 'image',
};
