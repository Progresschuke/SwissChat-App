// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatUser _$ChatUserFromJson(Map<String, dynamic> json) => ChatUser(
      imageUrl: json['imageUrl'] as String?,
      about: json['about'] as String?,
      username: json['username'] as String?,
      createdAt: json['createdAt'] as String?,
      isOnline: json['isOnline'] as bool?,
      id: json['id'] as String?,
      lastActive: json['lastActive'] as String?,
      email: json['email'] as String?,
      pushToken: json['pushToken'] as String?,
    );

Map<String, dynamic> _$ChatUserToJson(ChatUser instance) => <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'about': instance.about,
      'username': instance.username,
      'createdAt': instance.createdAt,
      'isOnline': instance.isOnline,
      'id': instance.id,
      'lastActive': instance.lastActive,
      'email': instance.email,
      'pushToken': instance.pushToken,
    };
