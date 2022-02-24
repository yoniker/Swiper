import 'dart:async';
import 'dart:math';

import 'package:betabeta/models/infoConversation.dart';
import 'package:betabeta/models/infoMessage.dart';
import 'package:betabeta/models/infoMessageReceipt.dart';
import 'package:betabeta/models/infoUser.dart';
import 'package:betabeta/models/persistentMessagesData.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/screens/chat_screen.dart';
import 'package:betabeta/screens/got_new_match_screen.dart';
import 'package:betabeta/screens/main_navigation_screen.dart';
import 'package:betabeta/services/app_state_info.dart';
import 'package:betabeta/services/chat_networking.dart';
import 'package:betabeta/services/notifications_controller.dart';
import 'package:betabeta/services/service_websocket.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';

Future<void> handleBackgroundMessage(RemoteMessage rawMessage) async {
  await PersistMessages().writeShouldSync(true);
  await ChatData.initDB();
  await SettingsData.instance.readSettingsFromShared();
  await NotificationsController.instance.initialize();
  var message = rawMessage.data;
  if (message['push_notification_type'] == 'new_message') {
    final String senderId = message['user_id'];
    if (senderId != SettingsData.instance.uid) {
      final InfoUser sender =
          InfoUser.fromJson(jsonDecode(message["sender_details"]));
      await NotificationsController.instance.showNewMessageNotification(
          senderName: sender.name,
          senderId: sender.uid,
          showSnackIfResumed: false);
    }
  }
}

Future<bool> setupInteractedMessage() async {
  bool notificationFromTerminatedState = false;
  // Get any messages which caused the application to open from
  // a terminated state.
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  // If the message also contains a data property with a "type" of "chat",
  // navigate to a chat screen
  if (initialMessage != null) {
    notificationFromTerminatedState = true;
    _handleMessageOpenedFromNotification(initialMessage);
  }

  // Also handle any interaction when the app is in the background via a
  // Stream listener
  FirebaseMessaging.onMessageOpenedApp
      .listen(_handleMessageOpenedFromNotification);
  return notificationFromTerminatedState;
}

void _handleMessageOpenedFromNotification(RemoteMessage message) async {
  final InfoMessage messageReceived = InfoMessage.fromJson(message.data);
  await ChatData().syncWithServer();
  //ChatData().addMessageToDB(messageReceived);
  if (messageReceived.userId != SettingsData.instance.uid) {
    InfoUser? sender = ChatData().getUserById(messageReceived.userId);
    AppStateInfo.instance.latestTabOnMainNavigation =
        MainNavigationScreen.CONVERSATIONS_PAGE_INDEX;
    Get.offAllNamed(MainNavigationScreen.routeName);
    if (sender != null) {
      Get.toNamed(ChatScreen.getRouteWithUserId(sender.uid));
    }
  }
}

class ChatData extends ChangeNotifier {
  static const CONVERSATIONS_BOXNAME = 'conversations';
  static const USERS_BOXNAME = 'users';
  Map<String, Tuple2<ValueListenable<Box>, int>> listenedValues = {};
  Map<String, double> markingConversation = {};
  StreamSubscription? _fcmSubscription, _websocketSubscription;

  static Future<void> initDB() async {
    //The following try-catch blocks are a bad code practice and are here because onBackground(..) handler sometimes tries to register adapters again
    //TODO check when exactly onbackground does an exception and when it's ok and remove the "bad code practice".
    try {
      await Hive.initFlutter();
    } catch (_) {}
    try {
      Hive.registerAdapter(
          InfoUserAdapter()); //TODO should I initialize Hive within the singleton?
      Hive.registerAdapter(InfoMessageAdapter());
      Hive.registerAdapter(InfoConversationAdapter());
      Hive.registerAdapter(InfoMessageReceiptAdapter());
    } catch (_) {}

    try {
      await Hive.openBox<InfoConversation>(ChatData.CONVERSATIONS_BOXNAME);
      await Hive.openBox<InfoUser>(ChatData.USERS_BOXNAME);
    } catch (_) {}
  }

  List<String> participantsFromConversationId(String conversationId) {
    //get participants ids from strings such as "conversation_104428005452977_with_104828875410871";
    List<String> l = conversationId.split('_with_');
    l[0] = l[0].split('conversation_')[1];
    return l;
  }

  Future<void> deleteDB() async {
    await conversationsBox.deleteAll(conversationsBox
        .keys); //Instead of deleteFromDisk which closes the box and creates an issue if another login occurs
    await usersBox.deleteAll(usersBox.keys);
  }

  void addMessageToDB(InfoMessage messageReceived,
      {String? otherParticipantsId}) {
    //Add message to DB -only if sender is in current active matches (=in user box).
    final String conversationId = messageReceived.conversationId;
    final InfoConversation? existingConversation =
        conversationsBox.get(conversationId);
    if (existingConversation == null) {
      final messages = [messageReceived];
      final List<String> participantsIds =
          participantsFromConversationId(conversationId);
      for (var participantId in participantsIds) {
        if (SettingsData.instance.uid != participantId &&
            !usersBox.keys.contains(participantId)) {
          return; //This message belongs to a sender who is not an active match
        }
      }
      conversationsBox.put(
          conversationId,
          InfoConversation(
              conversationId: conversationId,
              lastChangedTime: 0,
              creationTime: 0,
              participantsIds: participantsIds,
              messages: messages));
      return;
    }
    //Conversation exists so update messages and participants etc
    //print('Conversation exists. Updating conversation');
    var messages = existingConversation.messages;
    final int indexOldMessage = messages.indexWhere(
        (message) => message.messageId == messageReceived.messageId);
    if (indexOldMessage < 0) {
      //print("Message didn't exist");
      messages.insert(0, messageReceived);
    } else {
      //print('Message existed so just updating message...');
      if (messages[indexOldMessage] !=
          messageReceived) //TODO pointless as long as I don't implement operator ==
      {
        InfoMessage currentDbMessage = messages[indexOldMessage];
        //TODO combine currentDbMessage and messageReceived
        var currentReceipts = currentDbMessage.receipts;
        var receivedReceipts = messageReceived.receipts;
        for (var key in receivedReceipts.keys) {
          if (currentReceipts.keys.contains(key)) {
            currentReceipts[key]!.sentTime = max(
                receivedReceipts[key]!.sentTime,
                currentReceipts[key]!.sentTime);
            currentReceipts[key]!.readTime = max(
                receivedReceipts[key]!.readTime,
                currentReceipts[key]!.readTime);
          } else {
            currentReceipts[key] = receivedReceipts[key]!;
          }
        }

        InfoMessage updatedMessage = InfoMessage(
            content: messageReceived.content,
            messageId: messageReceived.messageId,
            conversationId: messageReceived.conversationId,
            userId: messageReceived.userId,
            receipts: currentReceipts,
            messageStatus: messageReceived.messageStatus,
            readTime: messageReceived.readTime,
            sentTime: messageReceived.sentTime,
            addedDate: messageReceived.addedDate,
            changedDate: messageReceived.changedDate);
        messages[indexOldMessage] = updatedMessage;
      }
    }
    messages.sort((messageA, messageB) =>
        (messageB.changedDate ?? messageB.addedDate ?? 0) >
                (messageA.changedDate ?? messageA.addedDate ?? 0)
            ? 1
            : -1);
    List<String> participantsIds = existingConversation.participantsIds;

    participantsIds = participantsFromConversationId(conversationId);
    for (var participantId in participantsIds) {
      if (!usersBox.keys.contains(participantId)) {}
    }
    InfoConversation updatedConversation = InfoConversation(
        conversationId: existingConversation.conversationId,
        lastChangedTime: existingConversation.lastChangedTime,
        creationTime: existingConversation.creationTime,
        participantsIds: participantsIds,
        messages:
            messages); //TODO notice that changed time is complete bullshit for now
    conversationsBox.put(conversationId, updatedConversation);
    return;
  }

  void handlePushData(message) async {
    if (message['push_notification_type'] == 'new_read_receipt') {
      //TODO for now just sync with server "everything" there is to sync. Of course,this can be improved if and when necessary
      syncWithServer();
      return;
    }

    if (message['push_notification_type'] == 'match_info') {
      //Match info,but not a new match,for now this can only mean cancelled match
      syncWithServer();
      return;
    }
    if (message['push_notification_type'] == 'new_match') {
      await syncWithServer();
      String? userId = message['user_id'];
      InfoUser? theUser = userId == null ? null : getUserById(userId);
      if (theUser != null) {
        Get.toNamed(GotNewMatchScreen.routeName, arguments: theUser);
      }
    }

    //If here then push notification is new message as all other notifications types were handled above this line
    final String senderId = message['user_id'];
    if (senderId != SettingsData.instance.uid) {
      //Update Users Box
      final InfoUser sender =
          InfoUser.fromJson(jsonDecode(message["sender_details"]));
      usersBox.put(sender.uid, sender); //Update users box
      NotificationsController.instance.showNewMessageNotification(
          senderName: sender.name, senderId: senderId);
    }
    final InfoMessage messageReceived = InfoMessage.fromJson(message);
    addMessageToDB(messageReceived);
    notifyListeners();
    syncWithServer();
  }

  Future<void> syncWithServer() async {
    Tuple2<List<InfoMessage>, List<dynamic>> newData =
        await ChatNetworkHelper.getMessagesByTimestamp();
    List<InfoMessage> newMessages = newData.item1;
    List<dynamic> unparsedUsers = newData.item2;
    await updateUsersData(unparsedUsers);
    await removeOrphanConversations();
    print('got ${newMessages.length} new messages from server while syncing');
    double maxTimestampSeen = 0.0;
    for (final message in newMessages) {
      addMessageToDB(message);
      maxTimestampSeen =
          max(maxTimestampSeen, message.changedDate ?? message.sentTime ?? 0);
    }

    if (SettingsData.instance.lastSync < maxTimestampSeen) {
      //print('setting last sync to be $maxTimestampSeen');
      SettingsData.instance.lastSync = maxTimestampSeen;
    }

    notifyListeners();
  }

  void setupStreams() {
    try {
      _fcmSubscription = _fcmStream.listen(handlePushData);
      _websocketSubscription =
          ServiceWebsocket.instance.stream.listen((message) {
        handlePushData(message);
      });
    } catch (_) {}
    ;
  }

  Future<void> cancelSubscriptions() async {
    await _fcmSubscription?.cancel();
    await _websocketSubscription?.cancel();
  }

  Future<bool> onInitApp() async {
    //Returns true if there's a notification interaction from terminated state
    await syncWithServer(); //Sync with the server as soon as the app starts
    setupStreams();
    return await setupInteractedMessage();
  }

  //Make it a singleton
  ChatData._privateConstructor() {}
  static final ChatData _instance = ChatData._privateConstructor();

  String calculateConversationId(String otherUserId) {
    String userId1 = SettingsData.instance.uid;
    String userId2 = otherUserId;
    if (userId1.compareTo(userId2) > 0) {
      var temp = userId1; //Swap...
      userId1 = userId2;
      userId2 = temp;
    }

    return 'conversation_${userId1}_with_$userId2';
  }

  String calculateMessageId(String conversationId, double epochTime) {
    return SettingsData.instance.uid +
        '_' +
        conversationId +
        '_' +
        epochTime.toString();
  }

  void listenConversation(String conversationId, VoidCallback listener) {
    if (!listenedValues.containsKey(conversationId)) {
      listenedValues[conversationId] =
          Tuple2(conversationsBox.listenable(keys: [conversationId]), 0);
    }
    listenedValues[conversationId]!.item1.addListener(listener);
    listenedValues[conversationId]!
        .withItem2(listenedValues[conversationId]!.item2 + 1);
  }

  void removeListenerConversation(
      String conversationId, VoidCallback listener) {
    if (listenedValues.containsKey(conversationId)) {
      listenedValues[conversationId]!.item1.removeListener(listener);
      listenedValues[conversationId]!
          .withItem2(listenedValues[conversationId]!.item2 - 1);
      if (listenedValues[conversationId]!.item2 <= 0) {
        listenedValues.remove(conversationId);
      }
    }
  }

  factory ChatData() {
    return _instance;
  }
  final Stream<dynamic> _fcmStream = createStream();
  final Box<InfoConversation> conversationsBox =
      Hive.box(CONVERSATIONS_BOXNAME);
  final Box<InfoUser> usersBox = Hive.box(USERS_BOXNAME);

  Future<void> removeOrphanConversations() async {
    var allConversations = conversationsBox.keys.toList();
    for (var conversation_id in allConversations) {
      var participants = participantsFromConversationId(conversation_id);
      String otherParticipant = participants[0] != SettingsData.instance.uid
          ? participants[0]
          : participants[1];
      if (!usersBox.containsKey(otherParticipant)) {
        conversationsBox.delete(conversation_id);
      }
    }
  }

  Future<void> updateUsersData(List<dynamic> unparsedUsers) async {
    for (var unparsedUser in unparsedUsers) {
      InfoUser user = InfoUser.fromJson(unparsedUser);
      if (unparsedUser['status'] != 'active') {
        await usersBox.delete(user.uid);
      } else {
        await usersBox.put(user.uid, user);
      }
    }
  }

  void sendMessage(String otherUserId, String messageContent,
      {double? epochTime}) async {
    if (epochTime == null) {
      epochTime = DateTime.now().millisecondsSinceEpoch / 1000;
    }
    String conversationId = calculateConversationId(otherUserId);
    String messageId = calculateMessageId(conversationId, epochTime);
    InfoMessage newMessage = InfoMessage(
        content: messageContent,
        messageId: messageId,
        conversationId: conversationId,
        userId: SettingsData.instance.uid,
        messageStatus: 'Uploading',
        receipts: {},
        changedDate: epochTime,
        addedDate: epochTime);
    addMessageToDB(newMessage, otherParticipantsId: otherUserId);
    String? newMessageStatus;
    try {
      TaskResult result = await ChatNetworkHelper.sendMessage(
          otherUserId, messageContent, epochTime);
      newMessageStatus = result == TaskResult.success ? 'Sent' : 'Error';
    } catch (_) {
      newMessageStatus = 'Error';
    }
    InfoMessage updatedMessage = InfoMessage(
        content: messageContent,
        messageId: messageId,
        conversationId: conversationId,
        userId: SettingsData.instance.uid,
        messageStatus: newMessageStatus,
        receipts: {},
        changedDate: epochTime,
        addedDate: epochTime);
    //TODO alternative is to implement copyWith...
    addMessageToDB(updatedMessage, otherParticipantsId: otherUserId);
    return;
  }

  Future<void> resendMessageIfError(
      String conversationId, String messageId) async {
    if (!conversationsBox.keys.contains(conversationId)) {
      return;
    }
    InfoConversation conversation = conversationsBox.get(conversationId)!;
    int indexMessage = conversation.messages
        .indexWhere((message) => message.messageId == messageId);
    if (indexMessage < 0) {
      return;
    }
    InfoMessage message = conversation.messages[indexMessage];
    if (message.messageStatus != 'Error') {
      return;
    }
    sendMessage(getCollocutorId(conversation), message.content,
        epochTime: message.addedDate);
  }

  double timeConversationLastChanged(InfoConversation conversation) {
    if (conversation.messages.length == 0) {
      return 0;
    }
    InfoMessage lastMessage = conversation.messages[0];
    if ((lastMessage.changedDate ?? 0) > 0) {
      return lastMessage.changedDate!;
    }
    if ((lastMessage.addedDate ?? 0) > 0) {
      return lastMessage.addedDate!;
    }
    if ((lastMessage.sentTime ?? 0) > 0) {
      return lastMessage.sentTime!;
    }
    return 0;
  }

  List<InfoConversation> get conversations {
    //Get the conversations sorted before displaying those to the user
    List<InfoConversation> allConversations = conversationsBox.values.toList();
    //((messageA,messageB)=> (messageB.changedDate??messageB.addedDate??0)>(messageA.changedDate??messageA.addedDate??0)?1:-1);
    allConversations.sort((conversation1, conversation2) =>
        timeConversationLastChanged(conversation2) >
                timeConversationLastChanged(conversation1)
            ? 1
            : -1);
    return List.unmodifiable(allConversations);
  }

  bool conversationRead(InfoConversation conversation) {
    if (conversation.messages.length == 0) {
      return true;
    }
    InfoMessage lastMessage = conversation.messages[0];
    if (lastMessage.userId == SettingsData.instance.uid) {
      return true;
    }
    //Check read receipt..
    if (!lastMessage.receipts.containsKey(SettingsData.instance.uid)) {
      return false;
    }
    InfoMessageReceipt currentUserReceipt =
        lastMessage.receipts[SettingsData.instance.uid]!;
    if (currentUserReceipt.readTime == 0) {
      return false;
    }
    return true;
  }

  String getCollocutorId(InfoConversation conversation) {
    for (var participantId in conversation.participantsIds) {
      if (participantId != SettingsData.instance.uid) {
        return participantId;
      }
    }
    return SettingsData.instance.uid;
  }

  List<InfoUser> get users {
    var usersList = List<InfoUser>.from(usersBox.values);
    usersList.sort((user1, user2) =>
        user1.changedTime.isAfter(user2.changedTime) ? -1 : 1);
    return List.unmodifiable(usersList);
  }

  InfoUser? getUserById(String userId) {
    return usersBox.get(userId);
  }

  List<InfoMessage> messagesInConversation(String conversationId) {
    InfoConversation? foundConversation = conversationsBox.get(conversationId);
    if (foundConversation == null) {
      return [];
    }
    return foundConversation.messages;
  }

  static Stream<dynamic> createStream() {
    late StreamController<dynamic> controller;
    StreamSubscription? subscription;
    void setFirebaseEvents() {
      if (subscription == null) {
        subscription =
            FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          controller.add(message.data);
        });
        FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
      }
    }

    void unsetFirebaseEvents() {
      if (subscription != null) {
        subscription!.cancel();
        subscription = null;
      }
    }

    controller = StreamController<dynamic>(
        onListen: setFirebaseEvents,
        onPause: unsetFirebaseEvents,
        onResume: setFirebaseEvents,
        onCancel: unsetFirebaseEvents);

    return controller.stream;
  }

  Future<void> markConversationAsRead(String conversationId) async {
    String currentUserId = SettingsData.instance.uid;
    InfoConversation? theConversation = conversationsBox.get(conversationId);
    if (theConversation == null) {
      return;
    }
    double timeToTransmit = 0.0;
    for (var message in theConversation.messages) {
      var sender = message.userId;
      if (sender == SettingsData.instance.uid) {
        continue;
      }
      //We got to the first message not by the user. Since messages are sorted by change date, this is the most recent message
      if (message.receipts.containsKey(currentUserId) &&
          message.receipts[currentUserId]!.readTime > 0) {
        return; //There is a read receipt already
      }

      timeToTransmit = message.addedDate ??
          message.changedDate ??
          DateTime(2021).millisecondsSinceEpoch /
              1000; //The last date should never happen,but just in case - use a contant date so that we won't revisit this function when there's a bug
      if (markingConversation.containsKey(conversationId) &&
          markingConversation[conversationId]! >= timeToTransmit) {
        return; //We already sent a receipt for the conversation
      }
      markingConversation[conversationId] = timeToTransmit;

      break;
    }
    if (timeToTransmit == 0.0) {
      return;
    } //This can happen only when it wasn't set above after initialization eg when there's no message from sender for example
    bool markedSuccessfully =
        await ChatNetworkHelper.markConversationAsRead(conversationId);
    if (markedSuccessfully) {
      for (var message in theConversation.messages) {
        var sender = message.userId;
        if (sender == SettingsData.instance.uid) {
          continue;
        }
        if (!message.receipts.containsKey(currentUserId) ||
            message.receipts[currentUserId]!.readTime == 0) {
          if (!message.receipts.containsKey(currentUserId)) {
            message.receipts[currentUserId] = InfoMessageReceipt(
                userId: currentUserId, sentTime: 0, readTime: 0);
          }
          message.receipts[currentUserId]!.readTime =
              DateTime.now().millisecondsSinceEpoch /
                  1000; //TODO Dor actually update messages in DB
        }
      }

      conversationsBox.put(conversationId, theConversation);
    } else {
      markingConversation[conversationId] = 0.0; //There was an error
    }
  }
}
