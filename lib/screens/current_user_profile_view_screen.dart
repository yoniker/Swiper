import 'package:betabeta/models/profile.dart';
import 'package:betabeta/screens/profile_details_screen.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/utils/utils_methods.dart';
import 'package:betabeta/widgets/match_card.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CurrentUserProfileViewScreen extends StatefulWidget {
  static const String routeName = '/user_profile_viewer';
  const CurrentUserProfileViewScreen({Key? key}) : super(key: key);

  @override
  _CurrentUserProfileViewScreenState createState() =>
      _CurrentUserProfileViewScreenState();
}

class _CurrentUserProfileViewScreenState
    extends State<CurrentUserProfileViewScreen> {
  @override
  _CurrentUserProfileViewScreenState createState() =>
      _CurrentUserProfileViewScreenState();

  @override
  Widget build(BuildContext context) {
    var Birthday = SettingsData.instance.userBirthday;
    DateTime userBirthday = DateTime.parse(Birthday);
    int age = UtilsMethods.calculateAge(userBirthday);

    final dummyProfile = Profile(
        username: SettingsData.instance.name,
        age: age,
        headline: SettingsData.instance.userDescription,
        description: SettingsData.instance.userDescription,
        imageUrls: SettingsData.instance.profileImagesUrls,
        location: SettingsData.instance.locationDescription,
        height:
            "TODO add height to current profile", //TODO add height to profile
        jobTitle:
            "TODO add job title to current profile", //TODO add job title to profile
        compatibilityScore:
            1, //Compatibility scores is calculated between users.
        hotnessScore: 1);
    return Stack(alignment: Alignment.topLeft, children: [
      Scaffold(
        // appBar: CustomAppBar(),
        body: MatchCard(
            clickable: true, showCarousel: true, profile: dummyProfile),
      ),
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                  elevation: 0,
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
              SizedBox(
                width: 100,
                child: RoundedButton(
                  elevation: 10,
                  color: Colors.transparent,
                  name: 'Edit',
                  onTap: () async {
                    // move to the profile screen.
                    await Get.toNamed(
                      ProfileDetailsScreen.routeName,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      )
    ]);
  }
}
