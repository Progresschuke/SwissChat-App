import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:swiss_chat_app/controllers/chat_image_provider.dart';
import 'package:swiss_chat_app/controllers/emoji_provider.dart';
import 'package:swiss_chat_app/helpers/date_formatter.dart';
import 'package:swiss_chat_app/models/chat_message.dart';
import 'package:swiss_chat_app/models/chat_user.dart';
import 'package:swiss_chat_app/models/message.dart';
import 'package:swiss_chat_app/views/chat/components/widgets/message_card.dart';

import '../../api/api.dart';
import '../../controllers/user_model_provider.dart';
import '../../utils/boxes.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({
    super.key,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  List<Message>? messages;

  final messageController = TextEditingController();

  void resetState() {
    FocusScope.of(context).unfocus();
    ref.read(emojiStateProvider.notifier).showEmojiFalse();
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(uploadingImageProvider);
    ChatUser user = ref.watch(userModelProvider);
    Size size = MediaQuery.of(context).size;
    //list of users messages

    //for handling emoji
    bool emoji = ref.watch(emojiStateProvider);

    //for handling users text messages

    return GestureDetector(
      onTap: resetState,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: userAppBar(context),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        ),
        body: Column(
          children: [
            Expanded(
                child: ValueListenableBuilder<Box<ChatMessage>>(
              valueListenable: Boxes.getChatMessages().listenable(),
              builder: (context, box, child) {
                final chatMessages = box.values.toList().cast<ChatMessage>();

                chatMessages.sort((a, b) => a.sent.compareTo(b.sent));

                if (chatMessages.isNotEmpty) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 0.0 * size.width,
                        vertical: 0.0 * size.height),
                    height: 0.9 * size.height,
                    child: ListView.builder(
                        itemCount: chatMessages.length,
                        // reverse: true,
                        padding: EdgeInsets.only(top: size.height * .01),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (user.id == chatMessages[index].toId) {
                            return MessageCard(
                              message: chatMessages[index],
                            );
                          }
                          return const SizedBox();
                        }),
                  );
                } else {
                  return const Text('Send a message 👋!',
                      style: TextStyle(fontSize: 20));
                }
              },
            )),

            //progress indicator for showing uploading state
            if (uploadState)
              const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: CircularProgressIndicator(strokeWidth: 2))),

            userInputForm(),

            //show emojis on keyboard emoji button click & vice versa
            if (emoji)
              SizedBox(
                height: size.height * 0.35,
                child: EmojiPicker(
                  textEditingController: messageController,
                  config: Config(
                    bgColor: Theme.of(context).colorScheme.background,
                    columns: 6,
                    emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

//custom appBar for user
  Widget userAppBar(BuildContext context) {
    final user = ref.watch(userModelProvider);
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: APIs.getChatUserInfo(user),
      builder: (context, snapshot) {
        final data = snapshot.data?.docs;
        final list =
            data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

        return Container(
          padding: EdgeInsets.only(top: 0.005 * size.height),
          child: Row(
            children: [
              //to navigate to contact screen
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.black54)),

              //user profile picture
              ClipRRect(
                borderRadius: BorderRadius.circular(size.height * .03),
                child: CachedNetworkImage(
                  width: .04 * size.height,
                  height: .04 * size.height,
                  imageUrl:
                      list.isNotEmpty ? list[0].imageUrl! : user.imageUrl!,
                  fit: BoxFit.fill,
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(child: Icon(CupertinoIcons.person)),
                ),
              ),

              SizedBox(width: 0.04 * size.width),

              //user name & last seen time
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //user name
                  Text(list.isNotEmpty ? list[0].username! : user.username!,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),

                  SizedBox(height: size.height * .003),

                  //last seen time of chatUser
                  Text(
                    list.isNotEmpty
                        ? list[0].isOnline!
                            ? 'Online'
                            : ChatDateFormatter.getLastActiveTime(
                                context: context,
                                lastActive: list[0].lastActive!)
                        : ChatDateFormatter.getLastActiveTime(
                            context: context, lastActive: user.lastActive!),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

//custom chat messages input
  Widget userInputForm() {
    final user = ref.watch(userModelProvider);
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        ref.read(emojiStateProvider.notifier).resetEmoji();
                      },
                      icon: const Icon(Icons.emoji_emotions)),
                  Expanded(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: messageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        ref.read(emojiStateProvider.notifier).showEmojiFalse();
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Message',
                          hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary)),
                    ),
                  ),

                  //to pick image from gallery
                  IconButton(
                    onPressed: () async {
                      ref.read(chatGalleryImageProvider.notifier).selectImage();
                      final galleryImage = ref.watch(chatGalleryImageProvider);
                      if (galleryImage != null) {
                        ref
                            .read(uploadingImageProvider.notifier)
                            .isUploadingTrue();
                        await APIs.sendChatImage(user, galleryImage);
                        ref
                            .read(uploadingImageProvider.notifier)
                            .isUploadingFalse();
                      }
                    },
                    icon: const Icon(Icons.image),
                  ),

                  //to take a picture from camera
                  IconButton(
                    onPressed: () async {
                      ref.read(chatCameraImageProvider.notifier).selectImage();
                      final cameraImage = ref.watch(chatCameraImageProvider);
                      if (cameraImage != null) {
                        ref
                            .read(uploadingImageProvider.notifier)
                            .isUploadingTrue();
                        await APIs.sendChatImage(user, cameraImage);
                        ref
                            .read(uploadingImageProvider.notifier)
                            .isUploadingFalse();
                      }
                    },
                    icon: const Icon(Icons.camera_alt_outlined),
                  )
                ],
              ),
            ),
          ),

          //to send text messages
          MaterialButton(
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                APIs.sendMessage(user, messageController.text, Type.text);
                messageController.text = '';
              }
            },
            minWidth: 0,
            shape: const CircleBorder(),
            padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: const Icon(
              Icons.send,
              size: 26,
            ),
          )
        ],
      ),
    );
  }
}
