import 'package:betabeta/models/chatData.dart';
import 'package:betabeta/screens/profile_screen.dart';
import 'package:betabeta/utils/mixins.dart';
import 'package:betabeta/widgets/circular_user_avatar.dart';
import 'package:betabeta/widgets/contacts_widget.dart';
import 'package:betabeta/widgets/conversations_preview_widget.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({Key? key}) : super(key: key);
  static const String routeName = '/conversations_screen';

  @override
  _ConversationsScreenState createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen>
    with MountedStateMixin {
  void listen() {
    setStateIfMounted(() {});
  }

  @override
  void initState() {
    ChatData.instance.addListener(listen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: CustomAppBar(
        hasTopPadding: true,
        customTitle: Container(
          padding: EdgeInsets.only(left: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: (){
                      Get.toNamed(ProfileScreen.routeName);
                    },
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(ProfileScreen.routeName);
                      },
                      child: CircularUserAvatar(backgroundColor: Colors.grey,),
                    ),
                  )
              ),
            ],
          ),
        ),
        showAppLogo: false,
        hasBackButton: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  )),
              child: Column(
                children: [
                  ContactsWidget(),
                  ConversationsPreviewWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    ChatData.instance.removeListener(listen);
    super.dispose();
  }
}
