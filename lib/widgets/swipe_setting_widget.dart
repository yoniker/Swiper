import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/services/chatData.dart';
import 'package:betabeta/screens/splash_screen.dart';
import 'package:betabeta/screens/swipe_settings_screen.dart';
import 'package:betabeta/services/chat_networking.dart';
import 'package:betabeta/services/match_engine.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/cupertino_range_slider.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/dropdown_form_field.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

class SwipeSettingWidget extends StatefulWidget {
  SwipeSettingWidget({this.showExtraSettings = false});

  final bool showExtraSettings;

  @override
  State<SwipeSettingWidget> createState() => _SwipeSettingWidgetState();
}

class _SwipeSettingWidgetState extends State<SwipeSettingWidget> {
  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Save name, id and picture url to persistent storage, and move on to the next screen
    await prefs.remove('name');
    await prefs.remove('facebook_id');
    await prefs.remove('facebook_profile_image_url');
    await prefs.remove('preferredGender');
    SettingsData.instance.name = '';
    await ChatData.instance.cancelSubscriptions();
    SettingsData.instance.uid = '';
    await ChatData.instance.deleteDB();
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(SplashScreen.routeName);
  }

  PreferredGender _currentGenderSelected = PreferredGender.values
      .firstWhere((e) => e.name == SettingsData.instance.preferredGender);
  bool _showInDiscovery = true; //TODO change SettingsData to support visibility
  double _maxDistance = SettingsData.instance.radius;

  RangeValues _selectedAges = RangeValues(
      SettingsData.instance.minAge.toDouble(),
      SettingsData.instance.maxAge.toDouble());

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
        agesRangeText = '${_ages.start.toInt()} - 65+';
      } else {
        agesRangeText = '${_ages.start.toInt()} - ${_ages.end.toInt()}';
      }
    }
    return agesRangeText;
  }

  Widget choiceOnRow(
      {required String name,
      bool pressed = false,
      Decoration? decoration,
      void Function()? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: decoration,
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: defaultTextStyle.copyWith(
                color: pressed != false ? appMainColor : Colors.black87),
          ),
        ),
      ),
    );
  }

  bool ageDealBreaker = false;

  ///ToDo need to create this on SettingsData
  double dividerThickness = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white38,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (SettingsData.instance.isTestUser)
                Text(
                  "Test user mode is active",
                  style: TextStyle(
                      color: appMainColor, fontWeight: FontWeight.bold),
                ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        "I'm interested in",
                        style: boldTextStyle,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        choiceOnRow(
                          onTap: () {
                            setState(() {
                              SettingsData.instance.preferredGender =
                                  PreferredGender.Men.name;
                              _currentGenderSelected = PreferredGender.Men;
                            });
                          },
                          pressed: _currentGenderSelected.name ==
                              PreferredGender.Men.name,
                          name: 'Men',
                          decoration: BoxDecoration(
                            color: _currentGenderSelected.name ==
                                    PreferredGender.Men.name
                                ? Colors.red[100]
                                : Colors.white,
                            boxShadow: kElevationToShadow[1],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                            ),
                          ),
                        ),
                        choiceOnRow(
                          name: 'Women',
                          pressed: _currentGenderSelected.name ==
                              PreferredGender.Women.name,
                          onTap: () {
                            setState(() {
                              SettingsData.instance.preferredGender =
                                  PreferredGender.Women.name;
                              _currentGenderSelected = PreferredGender.Women;
                            });
                          },
                          decoration: BoxDecoration(
                            color: _currentGenderSelected.name ==
                                    PreferredGender.Women.name
                                ? Colors.red[100]
                                : Colors.white,
                            boxShadow: kElevationToShadow[1],
                          ),
                        ),
                        choiceOnRow(
                          name: 'Everyone',
                          onTap: () {
                            setState(() {
                              SettingsData.instance.preferredGender =
                                  PreferredGender.Everyone.name;
                              _currentGenderSelected = PreferredGender.Everyone;
                            });
                          },
                          pressed: _currentGenderSelected.name ==
                              PreferredGender.Everyone.name,
                          decoration: BoxDecoration(
                            boxShadow: kElevationToShadow[1],
                            color: _currentGenderSelected.name ==
                                    PreferredGender.Everyone.name
                                ? Colors.red[100]
                                : Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Container(
                decoration: kSettingsBlockBoxDecor,
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Max distance',
                          style: boldTextStyle,
                        ),
                        Text(
                          '${_maxDistance.round()} km away',
                          style: boldTextStyle.copyWith(color: appMainColor),
                        ),
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
                            color: appMainColor,
                            size: 24.0,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: CupertinoSlider(
                              thumbColor: appMainColor,
                              activeColor: appSecondaryColor,
                              value: _maxDistance,
                              min: 0,
                              max: 200,
                              onChanged: (value) {
                                setState(() {
                                  _maxDistance = value;
                                  SettingsData.instance.radius = _maxDistance;
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
                            color: appMainColor,
                            size: 24.0,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Deal breaker',
                          style: boldTextStyle,
                        ),
                        Switch(
                          value: SettingsData.instance.searchDistanceEnabled,
                          activeColor: appMainColor,
                          onChanged: (value) {
                            SettingsData.instance.searchDistanceEnabled = value;
                          },
                        ),
                      ],
                    ),
                    if (SettingsData.instance.isTestUser)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Show Dummy Profiles',
                            style: boldTextStyle,
                          ),
                          Switch(
                            value: SettingsData.instance.showDummyProfiles,
                            activeColor: appMainColor,
                            onChanged: (value) {
                              SettingsData.instance.showDummyProfiles = value;
                            },
                          ),
                        ],
                      ),
                    if (SettingsData.instance.isTestUser)
                      TextButton(
                        child: Text(
                          'Clear all my likes',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () async {
                          await NewNetworkService.instance.clearLikes();
                          MatchEngine.instance.clear();
                          Get.snackbar(
                              'Development mode', 'cleared all user choices');
                        },
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: kSettingsBlockBoxDecor,
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Age range',
                          style: boldTextStyle,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: RichText(
                            text: TextSpan(
                              style:
                                  boldTextStyle.copyWith(color: appMainColor),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: produceAgesRangeText(_selectedAges),
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
                            color: appMainColor,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.0),
                            child: SliderTheme(
                              data: SliderThemeData(
                                  thumbColor: appMainColor,
                                  overlappingShapeStrokeColor: appMainColor,
                                  overlayColor: appMainColor),
                              child: CupertinoRangeSlider(
                                thumbColor: appMainColor,
                                activeColor: appSecondaryColor,
                                values: _selectedAges,
                                disabledThumbColor: appMainColor,
                                min: SwipeSettingsScreen.minAge.toDouble(),
                                max: SwipeSettingsScreen.maxAge.toDouble(),
                                onChanged: (newRangevalues) {
                                  setState(
                                    () {
                                      _selectedAges = RangeValues(
                                        newRangevalues.start.roundToDouble(),
                                        newRangevalues.end.roundToDouble(),
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
                        ),
                        Icon(
                          Icons.elderly_rounded,
                          size: 24.0,
                          color: appMainColor,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Deal breaker',
                          style: boldTextStyle,
                        ),
                        Switch(
                          value: ageDealBreaker,
                          activeColor: appMainColor,
                          onChanged: (value) {
                            setState(() {
                              ageDealBreaker = value;

                              ///ToDo add this to SettingsData
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: kSettingsBlockBoxDecor,
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Show me on Voilà',
                      style: boldTextStyle,
                    ),
                    Switch(
                      value: _showInDiscovery,
                      activeColor: appMainColor,
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/voila.png',
                        color: goldColorish,
                        scale: 7,
                      ),
                      Text(
                        'Voilà V 1.0.2',
                        style: mediumBoldedCharStyle,
                      ),
                    ],
                  ),
                ),
              ),
              //Text(SettingsData.instance.uid),

              if (widget.showExtraSettings != false)
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _logout();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: kSettingsBlockBoxDecor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Logout',
                              style: boldTextStyle,
                            ),
                            Icon(
                              Icons.logout,
                              color: appMainColor,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        // move to swiping-preference screen.
                        await NewNetworkService.instance
                            .deleteAccount(); //TODO at the very least verify with the user that that's what she wants (in order to minimize accidental deleting of accounts)
                        await _logout();
                      },
                      child: Container(
                        decoration: kSettingsBlockBoxDecor,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delete Account',
                              style: boldTextStyle,
                            ),
                            Icon(
                              Icons.delete_forever,
                              color: appMainColor,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
