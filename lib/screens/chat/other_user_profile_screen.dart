import 'package:betabeta/services/chatData.dart';
import 'package:betabeta/models/profile.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/match_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class OtherUserProfileScreen extends StatefulWidget {
  static const String routeName = '/other_user_profile';
  static const Duration minDurationForUpdate = Duration(hours: 1);
  OtherUserProfileScreen({Key? key})
      : userId = Get.arguments,
        super(key: key);
  final String userId;
  @override
  _OtherUserProfileScreenState createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {});
      });
    Profile? profileToShow = ChatData.instance.getUserById(widget.userId);
    if (profileToShow == null ||
        profileToShow.imageUrls == null ||
        profileToShow.lastUpdate == null ||
        DateTime.now().difference(profileToShow.lastUpdate!) >
            OtherUserProfileScreen.minDurationForUpdate) {
      ChatData.instance.updateUserDataFromServer(widget.userId);
    }
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenerWidget(
      notifier: ChatData.instance,
      builder: (context) {
        Profile? profileToShow = ChatData.instance.getUserById(widget.userId);
        return Stack(alignment: Alignment.topLeft, children: [
          Scaffold(
            // appBar: CustomAppBar(),
            body: profileToShow == null
                ? SizedBox()
                : MatchCard(
                    clickable: true,
                    scrollController: _scrollController,
                    showCarousel: true,
                    profile: profileToShow,
                    showActionButtons: false,
                    showAI: false,
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                      elevation: 30,
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        FontAwesomeIcons.chevronLeft,
                        // shadows: [
                        //   Shadow(
                        //     blurRadius: 17.0,
                        //     color: Colors.black,
                        //     offset: Offset(-2.0, 2.0),
                        //   ),
                        // ],
                        size: 40,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              ),
            ),
          )
        ]);
      },
    );
  }
}
