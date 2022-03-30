import 'package:betabeta/models/profile.dart';
import 'package:betabeta/screens/profile_edit_screen.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/utils/utils_methods.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/match_card.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

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

    return ListenerWidget(
      notifier: SettingsData.instance,
      builder: (context) {
        final currentUserProfile = Profile(
          age: age,
          jobTitle: SettingsData.instance.jobTitle,
          height: SettingsData.instance.heightInCm.toDouble(),
          imageUrls: SettingsData.instance.profileImagesUrls,
          children: SettingsData.instance.children,
          covidVaccine: SettingsData.instance.covid_vaccine,
          drinking: SettingsData.instance.drinking,
          uid: SettingsData.instance.uid,
          education: SettingsData.instance.education,
          fitness: SettingsData.instance.fitness,
          religion: SettingsData.instance.religion,
          hobbies: SettingsData.instance.hobbies,
          school: SettingsData.instance.school,
          smoking: SettingsData.instance.smoking,
          pets: SettingsData.instance.pets,
          username: SettingsData.instance.name,
          zodiac: SettingsData.instance.zodiac,
          matchChangedTime: DateTime.now(),
          compatibilityScore: 1.0,
          hotnessScore: 1.0,
          description: SettingsData.instance.userDescription,
        );

        return Stack(alignment: Alignment.topLeft, children: [
          Scaffold(
            // appBar: CustomAppBar(),
            body: MatchCard(
              clickable: true,
              showCarousel: true,
              profile: currentUserProfile,
              showActionButtons: false,
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
                  SizedBox(
                    width: 100,
                    child: RoundedButton(
                      elevation: 15,
                      color: Colors.transparent,
                      name: 'Edit',
                      onTap: () async {
                        // move to the profile screen.
                        await Get.toNamed(
                          ProfileEditScreen.routeName,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ]);
      },
    );
  }
}
