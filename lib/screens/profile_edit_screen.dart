import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/lists_consts.dart';
import 'package:betabeta/screens/user_edit/children_screen.dart';
import 'package:betabeta/screens/user_edit/covid_screen.dart';
import 'package:betabeta/screens/user_edit/drinking_screen.dart';
import 'package:betabeta/screens/user_edit/education_screen.dart';
import 'package:betabeta/screens/user_edit/fitness_screen.dart';
import 'package:betabeta/screens/user_edit/my_hobbies_screen.dart';
import 'package:betabeta/screens/user_edit/my_pets_screen.dart';
import 'package:betabeta/screens/user_edit/orientation_edit_screen.dart';
import 'package:betabeta/screens/user_edit/pronouns_edit_screen.dart';
import 'package:betabeta/screens/user_edit/smoking_screen.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/utils/mixins.dart';
import 'package:betabeta/widgets/bubble_edit_block.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/images_upload_widget.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:betabeta/widgets/profile_edit_block.dart';
import 'package:betabeta/widgets/setting_edit_block.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

/// The Implemntation of the Profile-screen
class ProfileEditScreen extends StatefulWidget {
  static const String routeName = '/profile_details';

  ProfileEditScreen({Key? key}) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen>
    with MountedStateMixin {
  // --> All this information should be added to the data model.
  // this will be pre-filled with data from the server.

  @override
  initState() {
    super.initState();

    // this makes sure that if the state is not yet mounted, we don't end up calling setState
    // but instead push the function forward to the addPostFrameCallback function.
    _syncProfileImagesFromServer();
  }

  @override
  void dispose() {
    // make sure these are properly disposed after use.
    super.dispose();
  }

  int heightOptions = 129;

  TextEditingController aboutMeController =
      TextEditingController(text: SettingsData.instance.userDescription);
  TextEditingController schoolController =
      TextEditingController(text: SettingsData.instance.school);
  TextEditingController jobTitleController =
      TextEditingController(text: SettingsData.instance.jobTitle);

  void updateHeight(int value) {
    SettingsData.instance.heightInCm = value + startingCm;
  }

  void updateReligion(int value) {
    SettingsData.instance.religion = kReligionsList[value];
  }

  void updateZodiac(int value) {
    SettingsData.instance.zodiac = kZodiacsList[value];
  }

  choicesPopUp(List<String> choices, Function(int)? onChange) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            height: 300,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                          initialItem: choices.length ~/ 2),
                      itemExtent: 50.0,
                      onSelectedItemChanged: (onChange),
                      children:
                          choices.map((e) => Center(child: Text(e))).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenerWidget(
      notifier: SettingsData.instance,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: backgroundThemeColor,
            appBar: CustomAppBar(
              title: 'Edit Profile',
              hasTopPadding: true,
              showAppLogo: false,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      ' My pictures',
                      style: smallBoldedTitleBlack,
                    ),
                  ),
                  Center(
                    child: ImagesUploadwidget(),
                  ),
                  TextEditBlock(
                    keyboardType: TextInputType.multiline,
                    showCursor: true,
                    title: 'About me',
                    minLines: 4,
                    maxLines: 14,
                    maxCharacters: 1000,
                    controller: aboutMeController,
                    onType: (value) {
                      SettingsData.instance.userDescription = value;
                    },
                  ),
                  Divider(),
                  ProfileEditBlock(
                    title: 'Height',
                    icon: FontAwesomeIcons.ruler,
                    value: SettingsData.instance.heightInCm != 0
                        ? '${SettingsData.instance.heightInCm} cm (${cmToFeet(SettingsData.instance.heightInCm)} ft)'
                        : null,
                    onTap: () {
                      choicesPopUp(kHeightList, updateHeight);
                    },
                  ),
                  ProfileEditBlock(
                    title: 'Religion',
                    icon: FontAwesomeIcons.prayingHands,
                    value: SettingsData.instance.religion,
                    onTap: () {
                      choicesPopUp(kReligionsList, updateReligion);
                    },
                  ),
                  ProfileEditBlock(
                    title: 'Zodiac',
                    icon: FontAwesomeIcons.starAndCrescent,
                    value: SettingsData.instance.zodiac,
                    onTap: () {
                      choicesPopUp(kZodiacsList, updateZodiac);
                    },
                  ),
                  Divider(),
                  TextEditBlock(
                    showCursor: true,
                    title: 'Job title',
                    maxLines: 1,
                    maxCharacters: 20,
                    controller: jobTitleController,
                    onType: (val) {
                      SettingsData.instance.jobTitle = val;
                    },
                  ),
                  Divider(),
                  TextEditBlock(
                    showCursor: true,
                    title: 'School',
                    maxCharacters: 10,
                    maxLines: 1,
                    controller: schoolController,
                    onType: (val) {
                      SettingsData.instance.school = val;
                    },
                  ),
                  Divider(),
                  ProfileEditBlock(
                    title: 'Education',
                    icon: FontAwesomeIcons.graduationCap,
                    value: SettingsData.instance.education,
                    onTap: () {
                      Get.toNamed(EducationScreen.routeName);
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  ProfileEditBlock(
                    title: 'Fitness',
                    icon: FontAwesomeIcons.dumbbell,
                    value: SettingsData.instance.fitness,
                    onTap: () {
                      Get.toNamed(FitnessScreen.routeName);
                    },
                  ),
                  ProfileEditBlock(
                    title: 'Smoking',
                    icon: FontAwesomeIcons.smoking,
                    value: SettingsData.instance.smoking,
                    onTap: () {
                      Get.toNamed(SmokingScreen.routeName);
                    },
                  ),
                  ProfileEditBlock(
                    title: 'Drinking',
                    icon: FontAwesomeIcons.wineGlassAlt,
                    value: SettingsData.instance.drinking,
                    onTap: () {
                      Get.toNamed(DrinkingScreen.routeName);
                    },
                  ),
                  ProfileEditBlock(
                    title: 'Children',
                    icon: FontAwesomeIcons.babyCarriage,
                    value: SettingsData.instance.children,
                    onTap: () {
                      Get.toNamed(KidsScreen.routeName);
                    },
                  ),
                  ProfileEditBlock(
                    title: 'Covid Vaccine',
                    icon: FontAwesomeIcons.syringe,
                    value: SettingsData.instance.covid_vaccine,
                    onTap: () {
                      Get.toNamed(CovidScreen.routeName);
                    },
                  ),
                  Divider(),
                  BubbleEditBlock(
                    title: 'My hobbies',
                    bubbles: SettingsData.instance.hobbies,
                    onTap: () {
                      Get.toNamed(MyHobbiesScreen.routeName);
                    },
                  ),
                  BubbleEditBlock(
                    title: 'My pets',
                    bubbles: SettingsData.instance.pets,
                    altEmptyBubbles: kEmptyPets,
                    onTap: () {
                      Get.toNamed(MyPetsScreen.routeName);

                      //print(SettingsData.instance.hobbies);
                    },
                  ),
                  ProfileEditBlock(
                    title: 'Gender',
                    icon: FontAwesomeIcons.userAlt,
                    value: SettingsData.instance.userGender.capitalizeFirst,
                    onTap: () {
                      Get.toNamed(PronounsEditScreen.routeName);
                    },
                  ),
                  ProfileEditBlock(
                    title: 'Interested in',
                    icon: FontAwesomeIcons.users,
                    value: SettingsData.instance.preferredGender,
                    onTap: () {
                      Get.toNamed(OrientationEditScreen.routeName);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RoundedButton(
                        name: 'Done',
                        onTap: () {
                          Navigator.pop(context);
                        }),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _syncProfileImagesFromServer() async {
    var profileImagesUrls =
        await NewNetworkService.instance.getCurrentProfileImagesUrls();
    if (profileImagesUrls != null) {
      SettingsData.instance.profileImagesUrls = profileImagesUrls;
    }
  }
}
