import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/chatData.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/screens/splash_screen.dart';
import 'package:betabeta/screens/swipe_settings_screen.dart';
import 'package:betabeta/services/chat_networking.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

import '../constants/enums.dart';
import '../widgets/cupertino_range_slider.dart';
import '../widgets/dropdown_form_field.dart';
import 'advanced_settings_screen.dart';

/// The implementation for the Notification screen.
class AccountSettingsScreen extends StatefulWidget {
  static const String routeName = '/account_settings';

  AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Save name, id and picture url to persistent storage, and move on to the next screen
    await prefs.remove('name');
    await prefs.remove('facebook_id');
    await prefs.remove('facebook_profile_image_url');
    await prefs.remove('preferredGender');
    SettingsData.instance.name = '';
    await ChatData().cancelSubscriptions();
    SettingsData.instance.uid = '';
    await ChatData().deleteDB();
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(SplashScreen.routeName);
  }

  RangeValues _selectedAges = RangeValues(
      SettingsData.instance.minAge.toDouble(),
      SettingsData.instance.maxAge.toDouble());
  PreferredGender _currentGenderSelected = PreferredGender.values
      .firstWhere((e) => e.name == SettingsData.instance.preferredGender);
  String _currentLocation = 'Somewhere, Earth';
  bool _showInDiscovery =
      false; //TODO change SettingsData to support visibility
  double _maxDistance = SettingsData.instance.radius;

  DropdownMenuItem<PreferredGender> _buildGenderDropDownMenuItem(
      PreferredGender selectedGender) {
    //
    return DropdownMenuItem<PreferredGender>(
      child: Text(
        selectedGender.name,
        style: defaultTextStyle,
      ),
      value: selectedGender,
      onTap: () {
        setState(() {
          SettingsData.instance.preferredGender = selectedGender.name;
          _currentGenderSelected = selectedGender;
        });
      },
    );
  }

  String produceAgesRangeText(RangeValues _ages) {
    String agesRangeText;

    if (_ages.start.toInt() <= SwipeSettingsScreen.minAge) {
      if (_ages.end.toInt() >= SwipeSettingsScreen.maxAge) {
        agesRangeText = 'Any Age';
      } else {
        agesRangeText = '${_ages.end.toInt()} or younger';
      }
    } else {
      if (_ages.end.toInt() >= SwipeSettingsScreen.maxAge) {
        agesRangeText = 'Between ${_ages.start.toInt()} and 65+';
      } else {
        agesRangeText =
            'Between ${_ages.start.toInt()} and ${_ages.end.toInt()}';
      }
    }
    return agesRangeText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightCardColor,
      appBar: CustomAppBar(
        title: 'General Settings',
        hasTopPadding: true,
        showAppLogo: false,
        trailing: PrecachedImage.asset(
          imageURI: BetaIconPaths.settingsBarIcon,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GlobalWidgets.buildSettingsBlock(
                title: 'Visibility'.toUpperCase(),
                description: 'Show your profile to other people using this App',
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Show me in Discovery',
                        style: boldTextStyle,
                      ),
                      CupertinoSwitch(
                        value: _showInDiscovery,
                        activeColor: colorBlend01,
                        onChanged: (value) {
                          setState(
                            () {
                              // TODO:// Add required Function.
                              // Alert user to make sure he is intentionally changing his visibiliry status.

                              // set "_showInDiscovery" to the currrent switch value.
                              _showInDiscovery = value;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              GlobalWidgets.buildSettingsBlock(
                title: 'Where'.toUpperCase(),
                description: '',
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Location',
                            style: boldTextStyle,
                          ),
                          TextButton(
                            child: Row(children: [
                              Text(_currentLocation),
                              SizedBox(
                                width: 4.0,
                              ),
                              Icon(Icons.arrow_forward_ios, size: 16)
                            ]),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Max. Distance',
                                style: boldTextStyle,
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.symmetric(vertical: 6.0),
                                child: RichText(
                                  text: TextSpan(
                                    style: defaultTextStyle,
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text:
                                            ' ${_maxDistance.round().toString()} km away',
                                        style: defaultTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(math.pi),
                                child: Icon(
                                  Icons.directions_bike_rounded,
                                  size: 24.0,
                                  color: colorBlend01,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.0),
                                  child: CupertinoSlider(
                                    activeColor: colorBlend01,
                                    value: _maxDistance,
                                    min: 0,
                                    max: 200,
                                    onChanged: (value) {
                                      setState(() {
                                        _maxDistance = value;
                                        SettingsData.instance.radius =
                                            _maxDistance;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Transform.rotate(
                                alignment: Alignment.center,
                                angle: math.pi / 2,
                                child: Icon(
                                  Icons.local_airport_rounded,
                                  size: 24.0,
                                  color: colorBlend01,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GlobalWidgets.buildSettingsBlock(
                title: 'Who'.toUpperCase(),
                description: '',
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Gender',
                              style: boldTextStyle,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              width: 100,
                              child: DropdownButtonFormFieldModified<
                                  PreferredGender>(
                                decoration: InputDecoration.collapsed(
                                  hintText: 'My Preferred Gender',
                                  hintStyle: defaultTextStyle.copyWith(
                                    color: darkTextColor,
                                  ),
                                ),
                                isExpanded: false,
                                onChanged: (PreferredGender? newGender) {
                                  setState(() {
                                    String gonnaGender = newGender?.name ??
                                        PreferredGender.Everyone.toString();
                                    print(
                                        'Going to change gender to $gonnaGender');
                                    SettingsData.instance.preferredGender =
                                        gonnaGender;
                                    _currentGenderSelected =
                                        newGender ?? PreferredGender.Everyone;
                                  });
                                },
                                style: defaultTextStyle,
                                value: _currentGenderSelected,
                                items: PreferredGender.values.map(
                                  (gender) {
                                    return _buildGenderDropDownMenuItem(gender);
                                  },
                                ).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Age',
                                  style: boldTextStyle,
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 0.0),
                                  child: RichText(
                                    text: TextSpan(
                                      style: defaultTextStyle,
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: produceAgesRangeText(
                                              _selectedAges),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(math.pi),
                                  child: Icon(
                                    Icons.child_friendly_outlined,
                                    size: 24.0,
                                    color: colorBlend01,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 6.0),
                                    child: CupertinoRangeSlider(
                                      activeColor: colorBlend01,
                                      values: _selectedAges,
                                      min:
                                          SwipeSettingsScreen.minAge.toDouble(),
                                      max:
                                          SwipeSettingsScreen.maxAge.toDouble(),
                                      onChanged: (newRangevalues) {
                                        setState(
                                          () {
                                            _selectedAges = RangeValues(
                                              newRangevalues.start
                                                  .roundToDouble(),
                                              newRangevalues.end
                                                  .roundToDouble(),
                                            );
                                            SettingsData.instance.minAge =
                                                _selectedAges.start.toInt();
                                            SettingsData.instance.maxAge =
                                                _selectedAges.end.toInt();
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.elderly_rounded,
                                  size: 24.0,
                                  color: colorBlend01,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GlobalWidgets.buildSettingsBlock(
                title: 'Advanced'.toUpperCase(),
                description: '',
                body: TextButton(
                  onPressed: () {
                    // Direct user to the Advanced filters Page.

                    Get.toNamed(AdvancedSettingsScreen.routeName);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Artificial Intelligence Filters',
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Icon(
                            Icons.psychology_outlined,
                            color: colorBlend01,
                            size: 34.0,
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black54,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.black),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TextButton(
                    child: Text(
                      'Done',
                      style: boldTextStyle.copyWith(fontSize: 20),
                    ),
                    onPressed: () {
                      // close the settings screen.
                      Get.back();
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  'Swiper V 1.0.2',
                  style: mediumBoldedCharStyle,
                ),
              ),
              SizedBox(height: 12.0),
              ActionBox(
                message: 'Matching Settings',
                messageStyle: mediumBoldedCharStyle,
                margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                trailing: Icon(
                  Icons.settings,
                ),
                onTap: () {
                  // move to swiping-preference screen.
                  Get.toNamed(SwipeSettingsScreen.routeName);
                },
              ),
              ActionBox(
                message: 'Facebook Logout',
                messageStyle: mediumBoldedCharStyle.copyWith(color: blue),
                margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                trailing: PrecachedImage.asset(
                  imageURI: BetaIconPaths.facebookLogo,
                ),
                onTap: () {
                  _logout();
                },
              ),
              SizedBox(height: 12.0),
              ActionBox(
                message: 'Delete account',
                messageStyle: mediumBoldedCharStyle,
                margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                trailing: Icon(
                  Icons.delete,
                ),
                onTap: () async {
                  // move to swiping-preference screen.
                  await ChatNetworkHelper
                      .deleteAccount(); //TODO at the very least verify with the user that that's what she wants (in order to minimize accidental deleting of accounts)
                  await _logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
