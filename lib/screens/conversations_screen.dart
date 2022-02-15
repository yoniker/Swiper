import 'package:betabeta/models/chatData.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/utils/mixins.dart';
import 'package:betabeta/widgets/contacts_widget.dart';
import 'package:betabeta/widgets/conversations_preview_widget.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:flutter/material.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({Key? key}) : super(key: key);
  static const String routeName = '/conversations_screen';

  @override
  _ConversationsScreenState createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> with MountedStateMixin {
  void listen(){setStateIfMounted(() {});}






  @override
  void initState() {
    ChatData().addListener(listen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: CustomAppBar(
        hasBackButton: false,
        hasTopPadding:true,
        customTitle:Row(
          children: [
            ProfileImageAvatar.network(url:SettingsData.instance.facebookProfileImageUrl),
            Text(SettingsData.instance.name)
          ],
        ),

      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color:Theme.of(context).colorScheme.secondary,borderRadius:BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),

              ) ),

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
    ChatData().removeListener(listen);
    super.dispose();
  }
}
