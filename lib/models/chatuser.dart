
import 'package:flutter/cupertino.dart';
class ChatUser{
  String name;
  String messageText;
  String imageURL;
  String time;
  ChatUser({@required this.name,@required this.messageText,@required this.imageURL,@required this.time});

  static List<ChatUser> mockChatUsers = [
    ChatUser(name: "Brad", messageText: "Awesome Setup", imageURL: "assets/mock_images/brad.jpg", time: "Now"),
    ChatUser(name: "Jennifer", messageText: "That's Great", imageURL: "assets/mock_images/jennifer.jpg", time: "Yesterday"),
    ChatUser(name: "Will", messageText: "Hey where are you?", imageURL: "assets/mock_images/will.jpg", time: "31 Mar"),
    ChatUser(name: "Scarlet", messageText: "Busy! Call me in 20 mins", imageURL: "assets/mock_images/scarlet.jpg", time: "28 Mar"),
    ChatUser(name: "Jane", messageText: "Thankyou, It's awesome", imageURL: "assets/mock_images/jane.jpg", time: "23 Mar"),
    ChatUser(name: "John Wick", messageText: "will update you in evening", imageURL: "assets/mock_images/john.jpg", time: "17 Mar"),
    ChatUser(name: "Glady", messageText: "How are you?", imageURL: "assets/mock_images/glady.jpg", time: "18 Feb"),
  ];


}