import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/services/chatData.dart';
import 'package:betabeta/models/infoConversation.dart';
import 'package:betabeta/models/infoMessage.dart';
import 'package:betabeta/models/profile.dart';
import 'package:betabeta/screens/chat/chat_screen.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/lists_consts.dart';

class ConversationsPreviewWidget extends StatefulWidget {
  ConversationsPreviewWidget({this.search = ''});

  final String search;

  @override
  _ConversationsPreviewWidgetState createState() =>
      _ConversationsPreviewWidgetState();
}

class _ConversationsPreviewWidgetState
    extends State<ConversationsPreviewWidget> {
  List<InfoConversation> conversations = ChatData.instance.conversations;

  void listenConversations() {
    setState(() {
      conversations = ChatData.instance.conversations;
    });
  }

  @override
  void initState() {
    ChatData.instance.addListener(listenConversations);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: conversations.length != 0
              ? Text(
                  'Conversations',
                  style: boldTextStyle,
                )
              : Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      Stack(
                        children: [
                          Image.asset(
                            'assets/images/speechBubble2.png',
                            scale: 2.5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 70.0, top: 30),
                            child: Image.asset(
                              'assets/images/speechBubble.gif',
                              scale: 2.3,
                            ),
                          )
                        ],
                      ),
                      Text(
                        'Find your conversations here',

                        ///ToDo find a similar short phrase
                        style: titleStyle,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Start a chat from your matches!',
                        textAlign: TextAlign.center,
                        style: subTitleStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black.withOpacity(0.65)),
                      )
                    ],
                  ),
                ),
        ),
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              double commonHeight = 80;
              InfoConversation conversation = conversations[index];
              InfoMessage lastMessage = conversation.messages[0];
              Profile? collocutor = ChatData.instance
                  .getUserById(ChatData.instance.getCollocutorId(conversation));
              bool messageWasRead =
                  ChatData.instance.conversationRead(conversation);
              // String heightInFeet =
              //     'Height: ${cmToFeet(collocutor?.height)} ft';
              if (collocutor != null) if (collocutor.username
                  .split(' ')[0]
                  .toLowerCase()
                  .contains(widget.search))
                return GestureDetector(
                  onTap: () {
                    if (collocutor != null) {
                      Get.toNamed(
                          ChatScreen.getRouteWithUserId(collocutor.uid));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),

                            blurRadius: 5,
                            offset:
                                Offset(-2.0, 2.0), // changes position of shadow
                          ),
                        ],
                        color:
                            messageWasRead ? Colors.grey[50] : Colors.blue[50],
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0))),
                    margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: commonHeight,
                              width: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  image: DecorationImage(
                                      image: NetworkImage(collocutor != null
                                          ? NewNetworkService
                                              .getProfileImageUrl(
                                                  collocutor.profileImage)
                                          : ''),
                                      fit: BoxFit.cover)),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              height: commonHeight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            collocutor != null
                                                ? collocutor.username
                                                    .split(' ')[0]
                                                : '',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            collocutor.age != null
                                                ? ', ${collocutor.age}'
                                                : '',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        child: Text(
                                            lastMessage.toUiMessage().text,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        collocutor.height != null &&
                                                collocutor.height != 0
                                            ? 'Height: ${cmToFeet(collocutor.height)} ft'
                                            : '',
                                        style: TextStyle(
                                          color: Colors.blueGrey[400],
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (!messageWasRead)
                          Container(
                            width: 50,
                            height: 25,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.blue),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.mail,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              return Container();
            }),
      ],
    );
  }

  @override
  void dispose() {
    ChatData.instance.removeListener(listenConversations);
    super.dispose();
  }
}
