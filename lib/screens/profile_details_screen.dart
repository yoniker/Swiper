import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/screens/orientation_edit_screen.dart';
import 'package:betabeta/screens/pronouns_edit_screen.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/utils/mixins.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/images_upload_widget.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/onboarding/input_field.dart';
import 'package:betabeta/widgets/setting_edit_block.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'package:reorderables/reorderables.dart';
import 'package:extended_image/extended_image.dart';

enum HeightUnit { ft, cm }

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
  bool _incognitoMode = false;

  String? _aboutMe;

  String? _jobTitle;

  String? _school = 'Gordon';

  String? _gender = 'Male';

  String? _orientation = 'Straight';

  bool _uploadingImage =
      false; //Is image in the process of being uploaded? give user a visual cue

  @override
  initState() {
    super.initState();

    // this makes sure that if the state is not yet mounted, we don't end up calling setState
    // but instead push the function forward to the addPostFrameCallback function.
    _aboutMe = SettingsData.instance.userDescription;
    _jobTitle = SettingsData.instance.userDescription;

    _syncProfileImagesFromServer();
  }

  @override
  void dispose() {
    // make sure these are properly disposed after use.
    super.dispose();
  }

  HeightUnit selectedUnit = HeightUnit.ft;
  TextEditingController heightController = TextEditingController();
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

  void checkHeightUnit() {
    if (selectedUnit == HeightUnit.ft) {
      setState(() {
        int inchess = (double.parse(heightController.text) ~/ 2.54).toInt();
        cmToFeet(inchess);
        heightController.text = '$ft\' $inches"';
      });
    } else if (selectedUnit == HeightUnit.cm) {
      setState(() {
        print(heightController.text);
        inchesToCm();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenerWidget(
      notifier: SettingsData.instance,
      builder: (context) {
        String? _mainProfileImage;
        List<String> _profileImagesUrls =
            SettingsData.instance.profileImagesUrls;

        if (_profileImagesUrls.isNotEmpty) {
          _mainProfileImage = _profileImagesUrls.first;
        }

        final ImageProvider _profileImage = (_mainProfileImage == null
            ? AssetImage(
                BetaIconPaths.defaultProfileImagePath01,
              )
            : ExtendedNetworkImageProvider(
                NewNetworkService.getProfileImageUrl(_mainProfileImage),
                cache: true,
              )) as ImageProvider<Object>;

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
                  showCursor: true,
                  title: 'About me',
                  maxLines: 4,
                  initialValue: _aboutMe,
                  onType: (value) {
                    SettingsData.instance.userDescription = value;
                  },
                ),
                TextEditBlock2(
                  title: 'Gender',
                  icon: FontAwesomeIcons.chevronRight,
                  readOnly: true,
                  initialValue: _gender,
                  onTap: () {
                    Navigator.pushNamed(context, PronounsEditScreen.routeName);
                  },
                ),
                TextEditBlock2(
                  title: 'Orientation',
                  icon: FontAwesomeIcons.chevronRight,
                  readOnly: true,
                  initialValue: _orientation,
                  onTap: () {
                    Navigator.pushNamed(
                        context, OrientationEditScreen.routeName);
                  },
                ),
                TextEditBlock2(
                  showCursor: true,
                  title: 'Job title',
                  placeholder: 'Job title',
                  initialValue: _jobTitle,
                  onType: (val) {
                    SettingsData.instance.userDescription = val;
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
                        showCursor: false,
                        controller: heightController,
                        keyboardType: TextInputType.number,
                        hintText:
                            selectedUnit == HeightUnit.ft ? "__' __\"" : '__',
                        formatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                        ],
                        onTap: selectedUnit == HeightUnit.ft
                            ? () {
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
                                                child: CupertinoPicker(
                                                  scrollController:
                                                      FixedExtentScrollController(
                                                          initialItem: 63),
                                                  itemExtent: 50.0,
                                                  onSelectedItemChanged:
                                                      (int index) {
                                                    setState(() {
                                                      cm = (index + 91)
                                                          .toString();
                                                      heightController.text =
                                                          "$cm cm (${cmToFeet(index + 91)} ft)";
                                                    });
                                                  },
                                                  children: List.generate(129,
                                                      (index) {
                                                    return Center(
                                                      child: Text(
                                                          '${index + 91} cm (${cmToFeet(index + 91)})'),
                                                    );
                                                    return SizedBox();
                                                  }),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 25),
                Theme(
                  data: ThemeData(
                    unselectedWidgetColor: Colors.black87,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CheckboxListTile(
                        title: Text(
                          ' Hide my profile',
                          style: boldTextStyle,
                        ),
                        value: _incognitoMode,
                        controlAffinity: ListTileControlAffinity.trailing,
                        contentPadding: EdgeInsets.zero,
                        checkColor: Colors.white,
                        activeColor: Colors.black87,
                        tristate: false,
                        onChanged: (val) {
                          setState(() {
                            _incognitoMode = val!;
                          });
                        }),
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
