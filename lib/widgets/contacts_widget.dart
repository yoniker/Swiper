import 'package:betabeta/constants/app_functionality_consts.dart';
import 'package:betabeta/constants/assets_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/constants/lists_consts.dart';
import 'package:betabeta/models/infoConversation.dart';
import 'package:betabeta/screens/main_navigation_screen.dart';
import 'package:betabeta/services/chatData.dart';
import 'package:betabeta/models/profile.dart';
import 'package:betabeta/screens/chat/chat_screen.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/animated_widgets/animated_minitcard_widget.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/cupertino.dart';
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
  late List<InfoConversation> conversationsUserInitiated =
      ChatData.instance.conversationsCurrentUserStarted;

  String headline = 'My matches';

  void updateConversationsData() {
    allUsers = ChatData.instance.users;
    usersIdsInConversations = ChatData.instance.allConversationsParticipantsIds;
    usersNotInConversations = allUsers
        .where((user) => !usersIdsInConversations.contains(user.uid))
        .toSet()
        .toList();
    usersNotInConversations.length == 0
        ? headline = 'No new matches'
        : headline = 'My matches';
    conversationsUserInitiated =
        ChatData.instance.conversationsCurrentUserStarted;
  }

  void listenContacts() {
    setState(() {
      updateConversationsData();
    });
  }

  void maxedOutPopUpDialog() {
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text(
                "You already have ${kMaxInitiatedConversations} conversations you\'ve started.",
              ),
              content: Text(
                  '\nIn order to start a new conversation, please clear at least one slot \n\n(While in conversation, on the top right corner of the screen, click on the \'x\' button).'),
              actions: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Colors.red),
                    ))
              ],
            ));
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
    String maleOrFemaleImage =
        SettingsData.instance.preferredGender == PreferredGender.Women.name
            ? AssetsPaths.Woman1Swipe
            : AssetsPaths.Man1Swipe;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10),
          child: Text(
            headline,
            style: boldTextStyle,
          ),
        ),
        Container(
            height: 120,
            child: usersNotInConversations.length == 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedMiniTcardWidget(
                        maleOrFemaleImage: maleOrFemaleImage,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'This is where your \nnew matches will appear.',
                              style: subTitleStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              width: 200,
                              height: 40,
                              child: RoundedButton(
                                elevation: 5,
                                color: Colors.black87,
                                withPadding: false,
                                name: 'Keep swiping!',
                                onTap: () {
                                  MainNavigationScreen.pageController
                                      .animateToPage(
                                          MainNavigationScreen
                                              .MATCHING_PAGE_INDEX,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.fastOutSlowIn);
                                },
                              ),
                            ),
                            Text(
                              'Go get \'em 😉',
                              style: subTitleStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
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
                            if (conversationsUserInitiated.length >=
                                kMaxInitiatedConversations)
                              maxedOutPopUpDialog();
                            else
                              Get.toNamed(ChatScreen.getRouteWithUserId(
                                  currentUser.uid));
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
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      return SizedBox();
                    })),
      ],
    );
  }
}
