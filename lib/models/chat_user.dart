import 'package:json_annotation/json_annotation.dart';

part 'chat_user.g.dart';

@JsonSerializable()
class ChatUser {
  String? imageUrl;
  String? about;
  String? username;
  String? createdAt;
  bool? isOnline;
  String? id;
  String? lastActive;
  String? email;
  String? pushToken;

  ChatUser({
    this.imageUrl,
    this.about,
    this.username,
    this.createdAt,
    this.isOnline,
    this.id,
    this.lastActive,
    this.email,
    this.pushToken,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) =>
      _$ChatUserFromJson(json);
  Map<String, dynamic> toJson() => _$ChatUserToJson(this);
}
