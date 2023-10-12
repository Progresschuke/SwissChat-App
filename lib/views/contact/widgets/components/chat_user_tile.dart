import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swiss_chat_app/api/api.dart';
import 'package:swiss_chat_app/controllers/emoji_provider.dart';
import 'package:swiss_chat_app/helpers/date_formatter.dart';
import 'package:swiss_chat_app/models/chat_user.dart';
import 'package:swiss_chat_app/models/message.dart';

import '../../../../controllers/user_model_provider.dart';

class ChatUserTile extends ConsumerStatefulWidget {
  const ChatUserTile({
    super.key,
    required this.model,
  });

  final ChatUser model;

  @override
  ConsumerState<ChatUserTile> createState() => _ChatUserTileState();
}

class _ChatUserTileState extends ConsumerState<ChatUserTile> {
  Message? message;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: APIs.getLastMessage(widget.model),
      builder: (context, snapshot) {
        final data = snapshot.data?.docs;

        //to prevent null/ range error
        final list =
            data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

        if (list.isNotEmpty) {
          // if(message!.type == Type.image) {
          //   message = message.
          // }
          message = list[0];
        }
        // if (data != null && data.first.exists) {
        //   message = Message.fromJson(data.first.data());
        // }
        return Card(
          child: InkWell(
              onTap: () {
                ref.read(emojiStateProvider.notifier).showEmojiFalse();
                ref.read(userModelProvider.notifier).getUserModel(widget.model);
                context.push('/chat');
              },
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CachedNetworkImage(
                    width: .055 * size.height,
                    height: .055 * size.height,
                    fit: BoxFit.fill,
                    imageUrl: widget.model.imageUrl!,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                title: Text(widget.model.username!),

                subtitle: message != null
                    ? SizedBox(
                        child: message!.type == Type.text
                            ? Text(
                                message!.msg,
                                maxLines: 1,
                              )
                            : const Row(children: [
                                Icon(Icons.image, size: 12),
                                Text('image')
                              ]),
                      )
                    : const Text(''),

                //to show null if chat user has no message
                trailing: message == null
                    ? null

                    //to show green indicator if current user has unread messages from a  chat user
                    : message!.read.isEmpty && message!.fromId != APIs.user.uid
                        ? Container(
                            padding: const EdgeInsets.all(2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.lightGreen,
                            ),
                            height: 20,
                            width: 20,
                            child: Text('${message!.read.length + 1} '),
                          )

                        // to show time of last message sent
                        : Text(ChatDateFormatter.getLastMessageTime(
                            context: context, time: message!.sent)),
              )),
        );
      },
    );
  }
}
