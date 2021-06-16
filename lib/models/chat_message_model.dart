import 'package:flutter/cupertino.dart';

class ChatMessage{
  String messageContent;
  String messageType;
  ChatMessage({@required this.messageContent, @required this.messageType});
  static List<ChatMessage> mockMessages = [
    ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
    ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
    ChatMessage(messageContent: "Hey Kriss, I am doing fine dude. wbu?", messageType: "sender"),
    ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    ChatMessage(messageContent: "Is there any thing wrong?", messageType: "sender"),
    ChatMessage(messageContent: "Another message1", messageType: "sender"),
    ChatMessage(messageContent: "Another message2", messageType: "sender"),
    ChatMessage(messageContent: "Another message3", messageType: "sender"),
    ChatMessage(messageContent: "Another message4", messageType: "sender"),
    ChatMessage(messageContent: "Another message5", messageType: "sender"),
    ChatMessage(messageContent: "Another message6", messageType: "sender"),
    ChatMessage(messageContent: "Another message7", messageType: "sender"),
    ChatMessage(messageContent: "Another message8", messageType: "sender"),
    ChatMessage(messageContent: "Another message9", messageType: "sender"),
    ChatMessage(messageContent: "Another message10", messageType: "sender"),
    ChatMessage(messageContent: "Final message", messageType: "receiver"),
  ];
}