import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:swiss_chat_app/api/api.dart';
import 'package:swiss_chat_app/controllers/login_state_provider.dart';
import 'package:swiss_chat_app/controllers/search_list_provider.dart';
import 'package:swiss_chat_app/views/contact/widgets/components/chat_user_tile.dart';
import 'package:swiss_chat_app/views/contact/widgets/components/settings_dialog.dart';

import '../../helpers/dialogs.dart';
import '../../models/chat_user.dart';

class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key});

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
  final List<ChatUser> userSearchList = [];
  List<ChatUser> userList = [];

  @override
  Widget build(BuildContext context) {
    bool isSearching = ref.watch(searchListProvider);
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        ref.read(searchListProvider.notifier).isSearchingFalse();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.home),
          elevation: 4,
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          title: isSearching
              ? TextField(
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Username, Email, ...'),
                  autofocus: true,
                  style: const TextStyle(fontSize: 17, letterSpacing: 0.5),

                  //to update search list
                  onChanged: (val) {
                    userSearchList.clear();

                    for (var i in userList) {
                      if (i.username!
                              .toLowerCase()
                              .contains(val.toLowerCase()) ||
                          i.email!.toLowerCase().contains(val.toLowerCase())) {
                        userSearchList.add(i);
                        setState(() {
                          userSearchList;
                        });
                      }
                    }
                  },
                )
              : Text(
                  'SwissChat',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
          actions: [
            IconButton(
                onPressed: () {
                  ref.read(searchListProvider.notifier).onSearch();
                },
                icon: isSearching
                    ? const Icon(CupertinoIcons.clear_circled_solid)
                    : const Icon(CupertinoIcons.search)),
            SizedBox(width: 0.05 * size.width),
            IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showDialog(
                    barrierColor: const Color(0x5AF0F0F0),
                    context: context,
                    builder: (context) {
                      return SettingsDialog(size: size);
                    },
                  );
                }),
            SizedBox(width: 0.05 * size.width),
          ],
        ),
        body: StreamBuilder(
          stream: APIs.firestore
              .collection('users')
              .where('id', isNotEqualTo: APIs.user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              //if data is loading
              case ConnectionState.waiting:
                return Center(child: Dialogs.circularProgress(context));

              //if no data available
              case ConnectionState.none:
                return const Center(child: Text('No Contact available!'));

              //if data is loaded or active
              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;
                userList =
                    data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                        [];
                if (userList.isNotEmpty) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 0.0 * size.width,
                        vertical: 0.0 * size.height),
                    height: 0.9 * size.height,
                    child: ListView.builder(
                        itemCount: isSearching
                            ? userSearchList.length
                            : userList.length,
                        padding: EdgeInsets.only(top: size.height * .01),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUserTile(
                              model: isSearching
                                  ? userSearchList[index]
                                  : userList[index]);
                        }),
                  );
                } else {
                  return const Center(
                    child: Text('No Connections Found!',
                        style: TextStyle(fontSize: 20)),
                  );
                }
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ref.read(loginStateProvider.notifier).isLoginFalse();
            APIs.clearUserData();
            APIs.auth.signOut();
          },
          tooltip: 'Message',
          child: const Icon(Icons.add_comment),
        ),
      ),
    );
  }
}
