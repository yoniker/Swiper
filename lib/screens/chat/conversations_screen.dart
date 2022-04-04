import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/chatData.dart';
import 'package:betabeta/screens/profile_screen.dart';
import 'package:betabeta/utils/mixins.dart';
import 'package:betabeta/widgets/circular_user_avatar.dart';
import 'package:betabeta/widgets/contacts_widget.dart';
import 'package:betabeta/widgets/conversations_preview_widget.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/voila_logo_widget.dart';
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
    ChatData.instance
        .updateAllUsersData(); //TODO not optimal,see chatdata for more info
    ChatData.instance.addListener(listen);
    super.initState();
  }

  String searchProfile = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                hasTopPadding: true,
                titleTextColor: Colors.black,
                customTitle: Container(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(ProfileScreen.routeName);
                          },
                          child: CircularUserAvatar(
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                centerWidget: Center(
                  child: VoilaLogoWidget(),
                ),
                showAppLogo: false,
                hasBackButton: false,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextFormField(
                  onChanged: (newProfileName) {
                    setState(() {
                      searchProfile = newProfileName;
                    });
                  },
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 1,
                  maxLength: 15,
                  style: const TextStyle(fontSize: 20, color: Colors.black87),
                  decoration: InputDecoration(
                    counterText: '',
                    suffixIcon: Icon(Icons.search),
                    hintStyle:
                        const TextStyle(color: Colors.black26, fontSize: 18),
                    hintText: ' Search my matches',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black26),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 10),
                child: Text(
                  'Match pool',
                  style: boldTextStyle,
                ),
              ),
              ContactsWidget(
                search: searchProfile.toLowerCase(),
              ),
              ConversationsPreviewWidget(
                search: searchProfile.toLowerCase(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    ChatData.instance.removeListener(listen);
    super.dispose();
  }
}
