import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/screens/main_navigation_screen.dart';
import 'package:betabeta/services/chatData.dart';
import 'package:betabeta/models/profile.dart';
import 'package:betabeta/screens/chat/chat_screen.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsWidget extends StatefulWidget {
  ContactsWidget({this.search = ''});

  final String search;

  @override
  _ContactsWidgetState createState() => _ContactsWidgetState();
}

class _ContactsWidgetState extends State<ContactsWidget>
    with SingleTickerProviderStateMixin {
  List<Profile> allUsers = ChatData.instance.users;
  Set<String> usersIdsInConversations =
      ChatData.instance.allConversationsParticipantsIds;
  late List<Profile> usersNotInConversations;
  late AnimationController _controller;
  late Animation swipeAnimation;
  late Animation positionAnimation;
  late Animation expandAnimation;
  late Animation shrinkAnimation;

  String headline = 'My matches';

  void updateConversationsData() {
    allUsers = ChatData.instance.users;
    print('testing 1');
    usersIdsInConversations = ChatData.instance.allConversationsParticipantsIds;
    usersNotInConversations = allUsers
        .where((user) => !usersIdsInConversations.contains(user.uid))
        .toSet()
        .toList();
    usersNotInConversations.length == 0
        ? headline = 'No new matches'
        : headline = 'My matches';
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
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..forward()
          ..addListener(() {
            setState(() {});
            if (_controller.isCompleted) {
              _controller.repeat(reverse: true);
            }
          });
    swipeAnimation = Tween<double>(begin: -0.2, end: 0.2).animate(
      CurvedAnimation(
          parent: _controller,
          curve: Curves.fastOutSlowIn,
          reverseCurve: Curves.fastOutSlowIn),
    );
    positionAnimation = Tween<double>(begin: 0, end: 20).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Curves.fastOutSlowIn,
            reverseCurve: Curves.fastOutSlowIn));
    expandAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.fastOutSlowIn));
    shrinkAnimation = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int maleOrFemaleImage =
        SettingsData.instance.preferredGender == 'Women' ? 2 : 1;
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
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  width: 80,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 3, color: Colors.white),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/backimage.jpg'),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      )),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: positionAnimation.value),
                            child: Transform.rotate(
                              angle: swipeAnimation.value,
                              child: Container(
                                margin: EdgeInsets.all(5),
                                width: 80,
                                height: 105,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border:
                                      Border.all(width: 2, color: Colors.white),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/swipe$maleOrFemaleImage.jpg'),
                                      fit: BoxFit.cover),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.black,
                                            Colors.transparent
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.center),
                                      borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(10),
                                      )),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(
                                        Icons.thumb_up,
                                        color: Colors.green.withOpacity(
                                            expandAnimation.value * 1),
                                        size: expandAnimation.value * 35,
                                      ),
                                      Icon(
                                        Icons.thumb_down,
                                        color: Colors.red.withOpacity(
                                            shrinkAnimation.value * 1),
                                        size: shrinkAnimation.value * 35,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Swipe',
                                            textAlign: TextAlign.center,
                                            style: titleStyleWhite.copyWith(
                                                fontSize: 17, height: 0.8),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
                                onTap: () {},
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
                            {
                              Get.toNamed(ChatScreen.getRouteWithUserId(
                                  currentUser.uid));
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

  @override
  void dispose() {
    ChatData.instance.removeListener(listenContacts);
    _controller.dispose();
    super.dispose();
  }
}
