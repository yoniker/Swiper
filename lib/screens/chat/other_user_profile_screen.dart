import 'package:betabeta/models/profile.dart';
import 'package:betabeta/widgets/match_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class OtherUserProfileScreen extends StatefulWidget {
  static const String routeName = '/other_user_profile';
  OtherUserProfileScreen({Key? key}) :userToShow=Get.arguments,super(key: key);
  final Profile userToShow;
  @override
  _OtherUserProfileScreenState createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return  Stack(alignment: Alignment.topLeft, children: [
      Scaffold(
        // appBar: CustomAppBar(),
        body: MatchCard(
            clickable: true, showCarousel: true, profile: widget.userToShow),
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
  }
}
