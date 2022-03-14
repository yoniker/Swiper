import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/screens/my_hobbies_screen.dart';
import 'package:betabeta/screens/orientation_edit_screen.dart';
import 'package:betabeta/screens/pronouns_edit_screen.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/utils/mixins.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/images_upload_widget.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/onboarding/input_field.dart';
import 'package:betabeta/widgets/setting_edit_block.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';

/// The Implemntation of the Profile-screen
class ProfileDetailsScreen extends StatefulWidget {
  static const String routeName = '/profile_details';

  ProfileDetailsScreen({Key? key}) : super(key: key);

  @override
  _ProfileDetailsScreenState createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen>
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
                TextEditBlock2(
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
                TextEditBlock2(
                  title: 'Gender',
                  controller: genderController,
                  icon: FontAwesomeIcons.chevronRight,
                  readOnly: true,
                  onTap: () async {
                    await Get.toNamed(PronounsEditScreen.routeName);
                    genderController.text = SettingsData.instance.userGender;
                  },
                ),
                TextEditBlock2(
                  title: 'Interested in',
                  icon: FontAwesomeIcons.chevronRight,
                  readOnly: true,
                  controller: orientationController,
                  onTap: () async {
                    await Get.toNamed(OrientationEditScreen.routeName);
                    orientationController.text =
                        SettingsData.instance.preferredGender;
                  },
                ),
                TextEditBlock2(
                  showCursor: true,
                  title: 'Job title',
                  initialValue: _jobTitle,
                  onType: (val) {
                    _jobTitle = val;
                  },
                ),
                TextEditBlock2(
                  showCursor: true,
                  title: 'School',
                  initialValue: _school,
                  onType: (val) {
                    _school = val;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          ' Height',
                          style: smallBoldedTitleBlack,
                        ),
                      ),
                      InputField(
                          icon: FontAwesomeIcons.chevronDown,
                          readonly: true,
                          showCursor: false,
                          controller: heightController,
                          hintText: 'Height',
                          formatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                          ],
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            showCupertinoModalPopup(
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
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
                                                onSelectedItemChanged:
                                                    (int index) {
                                                  setState(() {
                                                    cm =
                                                        (index + 91).toString();
                                                    heightController.text =
                                                        "$cm cm (${cmToFeet(index + 91)} ft)";
                                                  });
                                                },
                                                children:
                                                    List.generate(129, (index) {
                                                  return Center(
                                                    child: Text(
                                                        '${index + 91} cm (${cmToFeet(index + 91)})'),
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
                          }),
                    ],
                  ),
                ),
                TextEditBlock2(
                  title: 'My hobbies',
                  readOnly: true,
                  onTap: () {
                    Get.toNamed(MyHobbiesScreen.routeName);
                  },
                ),
                SizedBox(height: 20),
                Theme(
                  data: ThemeData(
                    unselectedWidgetColor: Colors.black87,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[350],
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Show my profile',
                              style: smallBoldedTitleBlack,
                            ),
                            CupertinoSwitch(
                              value: _incognitoMode,
                              activeColor: colorBlend01,
                              onChanged: (value) {
                                setState(
                                  () {
                                    // TODO:// Add required Function.
                                    // Alert user to make sure he is intentionally changing his visibiliry status.

                                    // set "_showInDiscovery" to the currrent switch value.
                                    _incognitoMode = value;
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
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

  Future<void> _syncProfileImagesFromServer() async {
    var profileImagesUrls =
        await NewNetworkService.instance.getCurrentProfileImagesUrls();
    if (profileImagesUrls != null) {
      SettingsData.instance.profileImagesUrls = profileImagesUrls;
    }
  }
}
