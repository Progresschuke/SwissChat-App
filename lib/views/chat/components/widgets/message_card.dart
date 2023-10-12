import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:swiss_chat_app/api/api.dart';
import 'package:swiss_chat_app/models/chat_message.dart';
import 'package:swiss_chat_app/models/message_type_adapter.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final ChatMessage message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? greenMessage()
        : greyMessage();
  }

//for current user
  Widget greenMessage() {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //for adding some space
        Row(
          children: [
            SizedBox(width: size.width * .04),

            //blue-ticks icon for unread message

            // if (widget.message.read.isEmpty)
            //   const Icon(Icons.done_all_rounded, color: Colors.grey, size: 20),

            //blue-ticks icon for read message

            // if (widget.message.read.isNotEmpty)
            //   const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),

            //for adding some space
            const SizedBox(width: 2),

            //message time
            Padding(
              padding: EdgeInsets.only(right: size.width * .04),
              child: Text(
                TimeOfDay.fromDateTime(widget.message.sent).format(context),
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ),
          ],
        ),

        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == MessageType.image
                ? size.width * .03
                : size.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: size.width * .04, vertical: size.height * .01),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
              border: Border.all(
                color: Theme.of(context).colorScheme.tertiary,
              ),
              //making borders curved
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: widget.message.type == MessageType.text
                ?
                //if user sends a text
                Text(
                    widget.message.msg,
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  )
                :
                //if user sends an image
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 65),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

//for chat user
  Widget greyMessage() {
    //to update read messages of chat users
    // if (widget.message.read.isEmpty) {
    //   APIs.updateMessageReadStatus(widget.message);
    // }
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == MessageType.image
                ? size.width * .03
                : size.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: size.width * .04, vertical: size.height * .01),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                border: Border.all(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                ),
                //for curved borders
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: widget.message.type == MessageType.text
                ?

                //show text
                Text(
                    widget.message.msg,
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  )
                :

                //show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),

        //message time
        Padding(
          padding: EdgeInsets.only(right: size.width * .04),
          child: Text(
            TimeOfDay.fromDateTime(widget.message.sent).format(context),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
