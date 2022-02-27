import 'package:betabeta/models/profile.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/match_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CurrentUserProfileViewScreen extends StatefulWidget {
  static const String routeName = '/user_profile_viewer';
  const CurrentUserProfileViewScreen({Key? key}) : super(key: key);

  @override
  _CurrentUserProfileViewScreenState createState() =>
      _CurrentUserProfileViewScreenState();
}

class _CurrentUserProfileViewScreenState
    extends State<CurrentUserProfileViewScreen> {
  static final dummyProfile = Profile(
      username: SettingsData.instance.name,
      headline: SettingsData.instance.userDescription,
      description:
      SettingsData.instance.userDescription,
      imageUrls: SettingsData.instance.profileImagesUrls,
      location: '${SettingsData.instance.longitude},${SettingsData.instance.latitude} TODO convert this in server to named location such as Haifa,Israel', //TODO convert this in server to named location such as Haifa,Israel
      height: "TODO add height to current profile", //TODO add height to profile
      jobTitle: "TODO add job title to current profile", //TODO add job title to profile
      compatibilityScore: 1, //Compatibility scores is calculated between users.
      hotnessScore: 1);


  @override
  _CurrentUserProfileViewScreenState createState() =>
      _CurrentUserProfileViewScreenState();

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topLeft, children: [
      Scaffold(
        // appBar: CustomAppBar(),
        body: MatchCard(
            clickable: true,
            showCarousel: true,
            profile: dummyProfile),
      ),
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FloatingActionButton(
              backgroundColor: Colors.blueGrey,
              child: Icon(
                FontAwesomeIcons.chevronLeft,
                size: 40,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
      )
    ]);
  }
}
