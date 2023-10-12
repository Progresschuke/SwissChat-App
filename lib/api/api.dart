import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiss_chat_app/models/message.dart';
import 'package:swiss_chat_app/models/message_type_adapter.dart';

import '../models/chat_message.dart';
import '../models/chat_user.dart';
import '../utils/boxes.dart';

class APIs {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // to return current user
  static User get user => auth.currentUser!;

  //for personal user detail
  static ChatUser me = ChatUser(
      id: user.uid,
      username: user.displayName,
      email: user.email,
      about: "Hey, I'm using Swiss Chat!",
      imageUrl: user.photoURL,
      createdAt: '',
      isOnline: false,
      lastActive: '',
      pushToken: '');

  //to get current user details

  static Future<void> getUserDetails() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        // await getFirebaseMessagingToken();
        //for setting user status to active
        // APIs.updateActiveStatus(true);
      } else {
        return;
      }
    });
  }

  // for creating a new user
  static Future<void> createUser(
      String username, String email, String image) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        id: user.uid,
        username: username,
        email: email,
        about: "Hey, I'm using Swiss Chat!",
        imageUrl: image,
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: '');

    //update user info
    await user.updateDisplayName(username);
    await user.updatePhotoURL(image);

    //save users details

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final userDetails = ChatUser(
        id: user.uid,
        username: user.displayName,
        email: user.email,
        about: "Hey, I'm using Swiss Chat!",
        imageUrl: user.photoURL,
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: '');

    String userData = jsonEncode(userDetails);
    print(userData);
    prefs.setString('userData', userData);

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  //to store current logged in userdata
  static Future storeUserData(User currentUser) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final loggedUserDetails = ChatUser(
        id: currentUser.uid,
        username: currentUser.displayName,
        email: currentUser.email,
        about: "Hey, I'm using Swiss Chat!",
        imageUrl: currentUser.photoURL,
        createdAt: '',
        isOnline: false,
        lastActive: '',
        pushToken: '');

    String loggedUserData = jsonEncode(loggedUserDetails);
    print(loggedUserData);
    prefs.setString('loggedUserData', loggedUserData);
  }

  //to get stored loggedUserData
  static Future getLoggedUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var dataString = prefs.getString('loggedUserData');

    Map<String, dynamic> jsonData =
        dataString != null ? (jsonDecode(dataString)) : {};

    ChatUser chatter = ChatUser.fromJson(jsonData);
    print(chatter.username);
    return chatter;
  }

  //to get stored current userdata
  static Future getStoredData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var dataString = prefs.getString('userData');

    Map<String, dynamic> jsonData =
        dataString != null ? (jsonDecode(dataString)) : {};

    ChatUser chatter = ChatUser.fromJson(jsonData);
    print(chatter.username);
    return chatter;
  }

  //to clear userdata (newly signed)
  static Future clearUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.remove('loggedUserData');
  }

  // update user's profile
  static Future<void> updateProfilePicture(File file) async {
    final storageRef =
        APIs.storage.ref().child('user_images').child('${user.uid}.jpg');

    await storageRef.putFile(file);
    me.imageUrl = await storageRef.getDownloadURL();

    await APIs.firestore
        .collection('users')
        .doc(user.uid)
        .update({'imageUrl': me.imageUrl});
  }

  // To get all logged in users
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    return firestore
        .collection('users')
        .where('id', whereIn: userIds.isEmpty ? [''] : userIds)
        .snapshots();
  }

  // to get message id
  static String getMessageID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // to get messages from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUsersMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getMessageID(user.id!)}/messages/')
        .orderBy('sent', descending: false)
        .snapshots();
  }

  //to send messages to a specific user
  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    final timeSent = DateTime.now().millisecondsSinceEpoch.toString();
    final sent = DateTime.now();

    final Message message = Message(
        toId: chatUser.id!,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: timeSent);

    // Store the message locally using Hive

    final chatMessage = ChatMessage(
      fromId: user.uid,
      msg: msg,
      toId: chatUser.id!,
      sent: sent,
      type: MessageType.text,
      messageId: sent.toString(),
    );

    final box = Boxes.getChatMessages();
    box.add(chatMessage);

    final ref =
        firestore.collection('chats/${getMessageID(chatUser.id!)}/messages/');
    await ref.doc(timeSent).set(message.toJson());
  }

  //update read status of message
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getMessageID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //to get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getMessageID(user.id!)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //to send images on chat
  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    //getting image file extension
    final fileExt = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getMessageID(chatUser.id!)}/${DateTime.now().millisecondsSinceEpoch}.$fileExt');

    //uploading image
    await ref.putFile(file, SettableMetadata(contentType: 'image/$fileExt'));

    //to upload chat image to firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  //to get a chat user's information
  static Stream<QuerySnapshot<Map<String, dynamic>>> getChatUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // to update users activity, if offline or online and to get the last seen time of the chat user
  static Future<void> updateActivity(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      // 'push_token': me.pushToken,
    });
  }
}

SharedPreferences? sharedPreferences;
