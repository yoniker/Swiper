import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/models/profile.dart';
import 'package:betabeta/widgets/chat_profile_display_widget.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/match_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class GotNewMatchScreen extends StatefulWidget {
  const GotNewMatchScreen({Key? key}) : super(key: key);
  static const String routeName = '/gotNewMatch';

  @override
  _GotNewMatchScreenState createState() => _GotNewMatchScreenState();
}

class _GotNewMatchScreenState extends State<GotNewMatchScreen> {
  late Profile theUser;

  @override
  void initState() {
    theUser = Get.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MatchCard(
            profile: theUser,
            clickable: true,
            showCarousel: true,
            showActionButtons: false,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: FloatingActionButton(
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
                },
              ),
            ),
          ),
          Center(
            child: Text(
              'You matched with ${theUser.username}!',
              style: kTitleStyleWhite,
            ),
          )
        ],
      ),
    );
  }
}
