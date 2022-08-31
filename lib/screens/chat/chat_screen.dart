import 'package:betabeta/models/infoMessage.dart';
import 'package:betabeta/models/profile.dart';
import 'package:betabeta/screens/chat/other_user_profile_screen.dart';
import 'package:betabeta/screens/main_navigation_screen.dart';
import 'package:betabeta/services/aws_networking.dart';
import 'package:betabeta/services/chatData.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/services/app_state_info.dart';
import 'package:betabeta/utils/mixins.dart';
import 'package:betabeta/widgets/chat_profile_display_widget.dart';
import 'package:betabeta/widgets/circular_user_avatar.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key})
      : userid = Get.parameters[USERID_PARAM] ?? 'no_user_param_found',
        super(key: key);
  static const String routeName = '/chat_screen';
  static const String USERID_PARAM = "user_id";
  static String getRouteWithUserId(String userid) {
    return routeName + '?$USERID_PARAM=$userid';
  }

  final String userid;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with MountedStateMixin {
  List<types.Message> _messages = <types.Message>[];
  late String conversationId;
  late Profile theUser;
  late String typedMessage;

  void updateChatData() {
    List<InfoMessage> currentChatMessages =
        ChatData.instance.messagesInConversation(conversationId);
    _messages =
        currentChatMessages.map((message) => message.toUiMessage()).toList();
    //Let's see if we are still matched with the user. If not, let's go back to main screen (notice that at this point we might be looking at the other user's profile)
    Profile? userFound = ChatData.instance.getUserById(widget.userid);
    if (userFound == null && mounted) {
      Get.snackbar('Match not found!', 'match not found!');
      Get.offAllNamed(MainNavigationScreen.routeName);
    }
  }

  void listenConversation() async {
    setStateIfMounted(() {
      updateChatData();
    });

    if (AppStateInfo.instance.appState == AppLifecycleState.resumed) {
      await ChatData.instance.markConversationAsRead(conversationId);
    }
  }

  void unmatchUser() async {
    await AWSServer.instance.unmatch(theUser.uid);
  }

  @override
  void initState() {
    Profile? userFound = ChatData.instance.getUserById(widget.userid);
    if (userFound == null) {
      Get.snackbar('Match not found!', 'match not found!');
      Get.offAllNamed(MainNavigationScreen.routeName);
    } //TODO on this kind of error another option is to put out a detailed error screen
    theUser = userFound!;
    typedMessage = '';
    conversationId = ChatData.instance.calculateConversationId(theUser.uid);
    ChatData.instance.markConversationAsRead(conversationId);
    ChatData.instance.listenConversation(conversationId, listenConversation);
    //AppStateInfo.instance.addListener(listenConversation);
    updateChatData();
    super.initState();
  }

  TextDirection chatInputTextDirection = TextDirection.ltr;
  //
  intl.TextDirection? LTRtoRTL(String text) {
    if (intl.Bidi.detectRtlDirectionality(text)) {
      chatInputTextDirection = TextDirection.rtl;
      return intl.TextDirection.RTL;
    }
    chatInputTextDirection = TextDirection.ltr;
    return intl.TextDirection.LTR;
  }

  bool isRTL(String text) {
    return intl.Bidi.detectRtlDirectionality(text);
  }

  Widget buildEmptyChatWidget() {
    Profile? theUser = ChatData.instance.getUserById(widget.userid);
    DateTime? matchTime = theUser?.matchChangedTime;
    if (theUser == null || matchTime == null) {
      return SizedBox();
    }

    Duration howLongAgo = DateTime.now().difference(matchTime);
    String howLongAgoDescription() {
      if (howLongAgo.inDays > 0) return '${howLongAgo.inDays} days ago';
      if (howLongAgo.inHours > 0) return '${howLongAgo.inHours} hours ago';
      return '${howLongAgo.inMinutes} minutes ago';
    }

    return AnimatedScale(
      duration: Duration(milliseconds: 300),
      scale: MediaQuery.of(context).viewInsets.bottom == 0 ? 1 : 0.8,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: MediaQuery.of(context).viewInsets.bottom == 0 ? 1 : 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You matched with ',
                    style: TextStyle(fontSize: 20, color: Colors.black54),
                  ),
                  Text(
                    theUser.username,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              child: CircularUserAvatar(
                imageProvider: NetworkImage(
                    AWSServer.getProfileImageUrl(theUser.profileImage)),
                radius: 80,
              ),
              onTap: () {
                Get.toNamed(OtherUserProfileScreen.routeName,
                    arguments: theUser.uid);
              },
            ),
            SizedBox(
              height: 20,
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: MediaQuery.of(context).viewInsets.bottom == 0 ? 1 : 0,
              child: Text(
                howLongAgoDescription(),
                style: TextStyle(fontSize: 20, color: Colors.black54),
              ),
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        hasTopPadding: true,
        hasBackButton: true,
        customTitle: ProfileDisplay(
          theUser,
          direction: Axis.horizontal,
          radius: 16,
          onTap: () {
            Get.toNamed(OtherUserProfileScreen.routeName,
                arguments: theUser.uid);
          },
        ),
        trailing: SizedBox(
          height: 30,
          child: Row(
            children: [
              FloatingActionButton.small(
                elevation: 0,
                backgroundColor: Colors.transparent,
                onPressed: () {
                  showDialog(
                    context: context,
                    useRootNavigator: true,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                      title: Text('Unmatch ${theUser.username} ?'),
                      content: Text(
                          '${theUser.username} will be removed from your chat.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            Get.back();
                            unmatchUser();
                          },
                          child: Text(
                            'Unmatch',
                            style: TextStyle(color: Colors.red[800]),
                          ),
                        )
                      ],
                    ),
                  );
                },
                child: Icon(
                  FontAwesomeIcons.ellipsisVertical,
                  color: Colors.black87,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Chat(
            l10n: ChatL10nEn(inputPlaceholder: ' Send a message'),
            inputOptions: InputOptions(
                onTextChanged: (input) {
                  if (isRTL(input))
                    setState(() {
                      chatInputTextDirection = TextDirection.rtl;
                    });
                  else
                    setState(() {
                      chatInputTextDirection = TextDirection.ltr;
                    });
                },
                textDirection: chatInputTextDirection),
            theme: DefaultChatTheme(
              primaryColor: Color(0xFF1565C0),
              secondaryColor: Color(0xFFE0E0E0),
              backgroundColor: Colors.transparent,
              inputMargin: EdgeInsets.all(10),
              inputPadding: EdgeInsets.all(10),
              inputBackgroundColor: Colors.transparent,
              inputContainerDecoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey, width: 1.5),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              inputTextColor: Colors.black87,
              inputTextCursorColor: Colors.blue,
            ),
            emptyState: SizedBox(),
            user: types.User(id: SettingsData.instance.uid),
            showUserAvatars: true,
            onSendPressed: (text) {
              ChatData.instance.sendMessage(
                  theUser.uid,
                  ChatData.encodeTextMessage("${intl.BidiFormatter.LTR().wrapWithUnicode(text.text, direction: LTRtoRTL(text.text))}")
                  );
            },
            messages: _messages,
            onMessageTap: (context, message) {
              ChatData.instance
                  .resendMessageIfError(conversationId, message.id);
            },
            onMessageLongPress: (context, message) {
              ChatData.instance
                  .resendMessageIfError(conversationId, message.id);
            },
          ),
          if (_messages.length == 0) buildEmptyChatWidget(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    ChatData.instance
        .removeListenerConversation(conversationId, listenConversation);
    //AppStateInfo.instance.removeListener(listenConversation);
    super.dispose();
  }
}
