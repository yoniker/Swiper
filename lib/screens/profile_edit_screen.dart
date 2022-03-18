import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/screens/children_screen.dart';
import 'package:betabeta/screens/covid_screen.dart';
import 'package:betabeta/screens/drinking_screen.dart';
import 'package:betabeta/screens/education_screen.dart';
import 'package:betabeta/screens/fitness_screen.dart';
import 'package:betabeta/screens/my_hobbies_screen.dart';
import 'package:betabeta/screens/my_pets_screen.dart';
import 'package:betabeta/screens/orientation_edit_screen.dart';
import 'package:betabeta/screens/pronouns_edit_screen.dart';
import 'package:betabeta/screens/smoking_screen.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/utils/mixins.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/images_upload_widget.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/onboarding/input_field.dart';
import 'package:betabeta/widgets/profile_edit_block2.dart';
import 'package:betabeta/widgets/setting_edit_block.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:extended_image/extended_image.dart';
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
  bool _incognitoMode = true;

  String? _jobTitle = 'Please add';

  String? _school = 'Please add';

  bool _uploadingImage =
      false; //Is image in the process of being uploaded? give user a visual cue

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

  TextEditingController heightController =
      TextEditingController(text: "cm (ft)");
  TextEditingController genderController =
      TextEditingController(text: SettingsData.instance.userGender);
  TextEditingController orientationController =
      TextEditingController(text: SettingsData.instance.preferredGender);
  TextEditingController aboutMeController =
      TextEditingController(text: SettingsData.instance.userDescription);
  int ft = 0;
  int inches = 0;
  String? cm;
  String? zodiac;
  String? religion;

  cmToFeet(centimeters) {
    double height = centimeters / 2.54;
    double inch = height % 12;
    double feet = height / 12;
    return ("${feet.toInt()}' ${inch.toInt()}");
  }

  inchesToCm() {
    int inchesTotal = (ft * 12) + inches;
    cm = (inchesTotal * 2.54).toStringAsPrecision(5);
    heightController.text = cm!;
  }

  choicesPopUp(List<String> choices, String? controller) {
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
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            controller = choices[index].toString();
                          });
                        },
                        children:
                            choices.map((e) => Center(child: Text(e))).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListenerWidget(
      notifier: SettingsData.instance,
      builder: (context) {
        return Scaffold(
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
                  controller: aboutMeController,
                  onType: (value) {
                    SettingsData.instance.userDescription = value;
                  },
                ),
                TextEditBlock(
                  showCursor: true,
                  title: 'Job title',
                  initialValue: _jobTitle,
                  onType: (val) {
                    _jobTitle = val;
                  },
                ),
                TextEditBlock(
                  showCursor: true,
                  title: 'School',
                  initialValue: _school,
                  onType: (val) {
                    _school = val;
                  },
                ),
                ProfileEditBlock2(
                  title: 'Gender',
                  icon: FontAwesomeIcons.userAlt,
                  value: genderController.text.capitalizeFirst,
                  onTap: () async {
                    await Get.toNamed(PronounsEditScreen.routeName);
                    genderController.text = SettingsData.instance.userGender;
                  },
                ),
                ProfileEditBlock2(
                  title: 'Height',
                  icon: FontAwesomeIcons.ruler,
                  value: heightController.text != 'cm (ft)'
                      ? heightController.text
                      : null,
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
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
                                        scrollController:
                                            FixedExtentScrollController(
                                                initialItem: 63),
                                        itemExtent: 50.0,
                                        onSelectedItemChanged: (int index) {
                                          setState(() {
                                            cm = (index + 91).toString();
                                            heightController.text =
                                                "$cm cm (${cmToFeet(index + 91)} ft)";
                                          });
                                        },
                                        children: List.generate(129, (index) {
                                          return Center(
                                            child: Text(
                                                '${index + 91} cm (${cmToFeet(index + 91)} ft)'),
                                          );
                                          return SizedBox();
                                        }),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                ),
                ProfileEditBlock2(
                  title: 'Religion',
                  icon: FontAwesomeIcons.prayingHands,
                  onTap: () {
                    choicesPopUp([
                      'Atheism/Agnosticism',
                      'Bahá’í',
                      'Buddhism',
                      'Christianity',
                      'Confucianism',
                      'Druze',
                      'Gnosticism',
                      'Hinduism',
                      'Islam',
                      'Jainism',
                      'Judaism',
                      'Rastafarianism',
                      'Shinto',
                      'Sikhism',
                      'Zoroastrianism',
                      'Traditional African Religions',
                      'African Diaspora Religions',
                      'Indigenous American Religions',
                      'Other'
                    ], religion);
                  },
                ),
                ProfileEditBlock2(
                  title: 'Zodiac',
                  icon: FontAwesomeIcons.starAndCrescent,
                  value: zodiac != null ? zodiac : null,
                  onTap: () {
                    choicesPopUp([
                      'Capricorn',
                      'Aquarius',
                      'Pisces',
                      'Aries',
                      'Taurus',
                      'Gemini',
                      'Cancer',
                      'Leo',
                      'Virgo',
                      'Libra',
                      'Scorpio',
                      'Sagittarius'
                    ], zodiac);
                  },
                ),
                ProfileEditBlock2(
                  title: 'Fitness',
                  icon: FontAwesomeIcons.dumbbell,
                  onTap: () {
                    Get.toNamed(FitnessScreen.routeName);
                  },
                ),
                ProfileEditBlock2(
                  title: 'Smoking',
                  icon: FontAwesomeIcons.smoking,
                  onTap: () {
                    Get.toNamed(SmokingScreen.routeName);
                  },
                ),
                ProfileEditBlock2(
                  title: 'Drinking',
                  icon: FontAwesomeIcons.wineGlassAlt,
                  onTap: () {
                    Get.toNamed(DrinkingScreen.routeName);
                  },
                ),
                ProfileEditBlock2(
                  title: 'Education',
                  icon: FontAwesomeIcons.userGraduate,
                  onTap: () {
                    Get.toNamed(EducationScreen.routeName);
                  },
                ),
                ProfileEditBlock2(
                  title: 'Interested in',
                  icon: FontAwesomeIcons.users,
                  value: orientationController.text,
                  onTap: () async {
                    await Get.toNamed(OrientationEditScreen.routeName);
                    orientationController.text =
                        SettingsData.instance.preferredGender;
                  },
                ),
                ProfileEditBlock2(
                  title: 'Children',
                  icon: FontAwesomeIcons.babyCarriage,
                  onTap: () {
                    Get.toNamed(KidsScreen.routeName);
                  },
                ),
                ProfileEditBlock2(
                  title: 'Covid Vaccine',
                  icon: FontAwesomeIcons.syringe,
                  onTap: () {
                    Get.toNamed(CovidScreen.routeName);
                  },
                ),
                TextEditBlock(
                  title: 'My hobbies',
                  readOnly: true,
                  onTap: () {
                    Get.toNamed(MyHobbiesScreen.routeName);
                  },
                ),
                TextEditBlock(
                  title: 'My pets',
                  readOnly: true,
                  onTap: () {
                    Get.toNamed(MyPetsScreen.routeName);
                  },
                )
              ],
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
