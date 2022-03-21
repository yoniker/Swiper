import 'package:betabeta/models/chatData.dart';
import 'package:betabeta/models/infoMessage.dart';
import 'package:betabeta/models/infoUser.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/services/app_state_info.dart';
import 'package:betabeta/utils/mixins.dart';
import 'package:betabeta/widgets/chat_profile_display_widget.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'dart:convert';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) :userid=Get.parameters[USERID_PARAM]??'no_user_param_found',super(key: key);
  static const String routeName = '/chat_screen';
  static const String USERID_PARAM = "user_id";
  static String getRouteWithUserId(String userid){
    return routeName+'?$USERID_PARAM=$userid';
  }


  final String userid;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with MountedStateMixin{
  List<types.Message> _messages = <types.Message>[];
  late String conversationId;
  late InfoUser theUser;


  void updateChatData() {
    List<InfoMessage> currentChatMessages = ChatData.instance.messagesInConversation(conversationId);
    _messages = currentChatMessages.map((message) => message.toUiMessage()).toList();

  }

  void listenConversation()async{
    setStateIfMounted((){
      updateChatData();

    });

    if(AppStateInfo.instance.appState==AppLifecycleState.resumed){
      await ChatData.instance.markConversationAsRead(conversationId);}
  }



  @override
  void initState() {
    InfoUser? userFound = ChatData.instance.getUserById(widget.userid);
    if(userFound==null){Get.back();} //TODO on this kind of error another option is to put out a detailed error screen
    theUser = userFound!;
    conversationId = ChatData.instance.calculateConversationId(theUser.uid);
    ChatData.instance.markConversationAsRead(conversationId).then((_)
    {ChatData.instance.listenConversation(conversationId,listenConversation);
    AppStateInfo.instance.addListener(listenConversation);

    }

    );
    updateChatData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(
        hasTopPadding: true,
        hasBackButton: true,
        customTitle: ProfileDisplay(theUser,minRadius: 10,maxRadius: 20,direction: Axis.horizontal,),
      ),
      body: Chat(
        user: types.User(id: SettingsData.instance.facebookId),
        showUserAvatars:true,
        onSendPressed: (text){
          ChatData.instance.sendMessage(theUser.uid,
              jsonEncode({"type":"text","content":"${text.text}"}));
        },
        messages: _messages,
        onMessageTap: (context,message){
          ChatData.instance.resendMessageIfError(conversationId, message.id);

        },
        onMessageLongPress: (context,message){
          ChatData.instance.resendMessageIfError(conversationId, message.id);
        },


      ),
    );
  }

  @override
  void dispose() {
    ChatData.instance.removeListenerConversation(conversationId,listenConversation);
    AppStateInfo.instance.removeListener(listenConversation);
    super.dispose();
  }
}
