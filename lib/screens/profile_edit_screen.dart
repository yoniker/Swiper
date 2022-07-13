import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/lists_consts.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/user_edit/kids_screen.dart';
import 'package:betabeta/screens/user_edit/covid_screen.dart';
import 'package:betabeta/screens/user_edit/drinking_screen.dart';
import 'package:betabeta/screens/user_edit/education_screen.dart';
import 'package:betabeta/screens/user_edit/fitness_screen.dart';
import 'package:betabeta/screens/user_edit/looking_for_screen.dart';
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
    NewNetworkService.instance.syncCurrentProfileImagesUrls();
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
    // if value is 0, delete religion
    value != 0
        ? SettingsData.instance.religion = kReligionsList[value]
        : SettingsData.instance.religion = '';
  }

  void updateZodiac(int value) {
    // if value is 0, delete religion
    value != 0
        ? SettingsData.instance.zodiac = kZodiacsList[value]
        : SettingsData.instance.zodiac = '';
  }

  choicesPopUp(List<String> choices, Function(int)? onChange, int initialItem,
      String title, Function()? onDelete) {
    FocusScope.of(context).requestFocus(new FocusNode());
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            height: 350,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      title,
                      style: smallBoldedTitleBlack,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                            initialItem: initialItem),
                        itemExtent: 50.0,
                        onSelectedItemChanged: (onChange),
                        children:
                            choices.map((e) => Center(child: Text(e))).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: onDelete,
                    child: Text(
                      'Remove',
                      style: kButtonText.copyWith(color: appMainColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                    child: RoundedButton(
                        name: 'Save',
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

  IconData ReligionIcon() {
    switch (SettingsData.instance.religion) {
      case 'Jewish':
        return FontAwesomeIcons.starOfDavid;
        ;
      case 'Muslim':
        return FontAwesomeIcons.starAndCrescent;

      case 'Christian':
        return FontAwesomeIcons.cross;

      case 'Buddhist':
        return FontAwesomeIcons.vihara;
      default:
        FontAwesomeIcons.handsPraying;
    }
    return FontAwesomeIcons.handsPraying;
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
                      choicesPopUp(
                        kHeightList,
                        updateHeight,
                        SettingsData.instance.heightInCm != 0
                            ? kHeightList.indexOf(
                                '${SettingsData.instance.heightInCm} cm (${cmToFeet(SettingsData.instance.heightInCm)} ft)')
                            : (kHeightList.length * 0.5).toInt(),
                        'What is your height?',
                        () {
                          SettingsData.instance.heightInCm = 0;
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                  ProfileEditBlock(
                    title: 'Religion',
                    icon: ReligionIcon(),
                    value: SettingsData.instance.religion,
                    onTap: () {
                      choicesPopUp(
                        kReligionsList,
                        updateReligion,
                        kReligionsList.contains(SettingsData.instance.religion)
                            ? kReligionsList
                                .indexOf(SettingsData.instance.religion)
                            : 0,
                        'What religion do you practice?',
                        () {
                          SettingsData.instance.religion = '';
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                  ProfileEditBlock(
                    title: 'Zodiac',
                    icon: FontAwesomeIcons.galacticRepublic,
                    value: SettingsData.instance.zodiac,
                    onTap: () {
                      choicesPopUp(
                        kZodiacsList,
                        updateZodiac,
                        kZodiacsList.contains(SettingsData.instance.zodiac)
                            ? kZodiacsList.indexOf(SettingsData.instance.zodiac)
                            : 0,
                        'What is your Zodiac sign?',
                        () {
                          SettingsData.instance.zodiac = '';
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                  Divider(),
                  TextEditBlock(
                    showCursor: true,
                    title: 'Job title',
                    maxLines: 1,
                    maxCharacters: 25,
                    controller: jobTitleController,
                    onType: (val) {
                      SettingsData.instance.jobTitle = val;
                    },
                  ),
                  Divider(),
                  TextEditBlock(
                    showCursor: true,
                    title: 'University',
                    maxCharacters: 25,
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
                    title: 'Covid',
                    icon: FontAwesomeIcons.syringe,
                    value: SettingsData.instance.covid_vaccine,
                    onTap: () {
                      Get.toNamed(CovidScreen.routeName);
                    },
                  ),
                  Divider(),
                  BubbleBlockViewer(
                    title: 'My hobbies',
                    bubbles: SettingsData.instance.hobbies,
                    onTap: () {
                      Get.toNamed(MyHobbiesScreen.routeName);
                    },
                  ),
                  BubbleBlockViewer(
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
                    icon: FontAwesomeIcons.userPen,
                    value: SettingsData.instance.userGender.capitalizeFirst,
                    onTap: () {
                      Get.toNamed(PronounsEditScreen.routeName);
                    },
                  ),

                  /// Do we really need that? users should not be able to change it.
                  ProfileEditBlock(
                    title: 'Into',
                    icon: FontAwesomeIcons.personCircleQuestion,
                    value: SettingsData.instance.preferredGender,
                    onTap: () {
                      Get.toNamed(OrientationEditScreen.routeName);
                    },
                  ),
                  ProfileEditBlock(
                    title: 'Looking for',
                    icon: FontAwesomeIcons.magnifyingGlass,
                    value: SettingsData.instance.relationshipType,
                    onTap: () {
                      Get.toNamed(LookingForScreen.routeName);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RoundedButton(
                        name: 'Done',
                        onTap: () {
                          Get.back();
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
}
