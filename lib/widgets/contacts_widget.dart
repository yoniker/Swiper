import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/chatData.dart';
import 'package:betabeta/models/profile.dart';
import 'package:betabeta/screens/chat/chat_screen.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsWidget extends StatefulWidget {
  ContactsWidget({this.search = ''});

  final String search;

  @override
  _ContactsWidgetState createState() => _ContactsWidgetState();
}

class _ContactsWidgetState extends State<ContactsWidget> {
  List<Profile> allUsers = ChatData.instance.users;
  Set<String> usersIdsInConversations =
      ChatData.instance.allConversationsParticipantsIds;
  late List<Profile> usersNotInConversations;

  void updateConversationsData() {
    allUsers = ChatData.instance.users;
    usersIdsInConversations = ChatData.instance.allConversationsParticipantsIds;
    usersNotInConversations = allUsers
        .where((user) => !usersIdsInConversations.contains(user.uid))
        .toSet()
        .toList();
  }

  void listenContacts() {
    setState(() {
      updateConversationsData();
    });
  }

  @override
  void initState() {
    updateConversationsData();
    ChatData.instance.addListener(
        listenContacts); //TODO add an option to listen only to users box changes on the ChatData API

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: usersNotInConversations.length,
            itemBuilder: (context, index) {
              Profile currentUser = usersNotInConversations[index];
              if (currentUser.username
                  .split(' ')[0]
                  .toLowerCase()
                  .contains(widget.search))
                return GestureDetector(
                  onTap: () {
                    {
                      Get.toNamed(
                          ChatScreen.getRouteWithUserId(currentUser.uid));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 35.0,
                          backgroundImage: NetworkImage(
                              NewNetworkService.getProfileImageUrl(
                                  currentUser.profileImage)),
                        ),
                        SizedBox(
                          height: 6.0,
                        ),
                        Text(
                          currentUser.username.split(' ')[0],
                          style: subTitleStyle,
                        ),
                      ],
                    ),
                  ),
                );
              return SizedBox();
            }));
  }

  @override
  void dispose() {
    ChatData.instance.removeListener(listenContacts);
    super.dispose();
  }
}
