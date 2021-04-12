import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/models/settings_model.dart';
import 'package:betabeta/widgets/cupertino_range_slider.dart';
import 'package:betabeta/widgets/dropdown_form_field.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DropdownButtonFormField;

import 'advanced_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _currentLocation = 'Somewhere, Earth';
  
  Gender _currentGenderSelected = Gender.values.firstWhere((e) => e.toShortString() == SettingsData().preferredGender);
  RangeValues _selectedAges = RangeValues(SettingsData().minAge.toDouble(), SettingsData().maxAge.toDouble());
  bool _showInDiscovery = false;
  double _maxDistance = 6.0; //TODO change SettingsData to support distance

  @override
  void initState() {
    super.initState();

    // call the `initializePreferences` method to initialize all important
    // user configurations.
  }

  //
  DropdownMenuItem<Gender> _buildGenderDropDownMenuItem(Gender selectedGender) {

    //
    return DropdownMenuItem<Gender>(
      child: Text(
        selectedGender.toShortString(),
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      value: selectedGender,
      onTap: () {
        setState(() {
          SettingsData().preferredGender = selectedGender.toShortString();
          _currentGenderSelected = selectedGender;
        });
      },
    );
  }

  String _resolveAgeRangeDescriptionString(double start, double end) {
    if (end < 75) {
      return ' ${start.round()}-${end.round()} ';
    } else {
      return ' ${start.round()}-75+ ';
    }
  }

  //
  var _defaultTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'Nunito',
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  var _varryingTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'Nunito',
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
        MediaQuery.of(context).padding.copyWith(left: 12.0, right: 12.0),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GlobalWidgets.buildSettingsBlock(
                      description:
                      'With this enabled your profile will be visible to other people using this App',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Show me in Discovery',
                            style: _varryingTextStyle,
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
                    GlobalWidgets.buildSettingsBlock(
                      catchPhrase: 'Where',
                      description:
                      'Your current Location. Used to find great matches that can go with your profile.',
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
                                  'Location',
                                  style: _varryingTextStyle,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 12.0),
                                    child:
                                    Text(_currentLocation),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 6.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Max. Distance',
                                  style: _varryingTextStyle,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.directions_bike_rounded,
                                      size: 24.0,
                                      color: colorBlend01,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: CupertinoSlider(
                                          activeColor: colorBlend01,
                                          value: _maxDistance,
                                          min: 0,
                                          max: 200,
                                          onChanged: (value) {
                                            setState(() {
                                              _maxDistance = value;
                                              // Add to the `_editionCount` variable.
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.local_airport_rounded,
                                      size: 24.0,
                                      color: colorBlend01,
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 12.0),
                                  child: RichText(
                                    text: TextSpan(
                                      style: _defaultTextStyle,
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text:
                                          ' ${_maxDistance.toStringAsFixed(2)} ',
                                        ),
                                        TextSpan(
                                          text: '"km away"',
                                          style: _varryingTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GlobalWidgets.buildSettingsBlock(
                      catchPhrase: 'Who',
                      description:
                      'The type of Gender you prefer to date. Used to find great matches that can go with your profile.',
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
                                  style: _varryingTextStyle,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 12.0),
                                    child:
                                    DropdownButtonFormFieldModified<Gender>(
                                      decoration: InputDecoration.collapsed(
                                        hintText: 'pick your Gender',
                                        hintStyle: _defaultTextStyle.copyWith(
                                          color: darkTextColor,
                                        ),
                                      ),
                                      isExpanded: false,
                                      onChanged: (newGender) {
                                        setState(() {
                                          SettingsData().preferredGender = newGender.toShortString();
                                          _currentGenderSelected = newGender;
                                          
                                        });
                                      },
                                      style: _defaultTextStyle,
                                      value: _currentGenderSelected,
                                      items: Gender.values.map(
                                            (gender) {
                                          return _buildGenderDropDownMenuItem(
                                              gender);
                                        },
                                      ).toList(),
                                    ),
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
                                Text(
                                  'Age Range',
                                  style: _varryingTextStyle,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.child_friendly_rounded,
                                      size: 24.0,
                                      color: colorBlend01,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                        EdgeInsets.symmetric(vertical: 6.0),
                                        child: CupertinoRangeSlider(
                                          activeColor: colorBlend01,
                                          values: _selectedAges,
                                          min: 18,
                                          max: 76,
                                          // divisions: 59,
                                          onChanged: (newRangevalues) {
                                            setState(
                                                  () {
                                                _selectedAges = RangeValues(
                                                  newRangevalues.start
                                                      .roundToDouble(),
                                                  newRangevalues.end
                                                      .roundToDouble(),
                                                );
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
                                Container(
                                  alignment: Alignment.centerRight,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 12.0),
                                  child: RichText(
                                    text: TextSpan(
                                      style: _defaultTextStyle,
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text:
                                          _resolveAgeRangeDescriptionString(
                                            _selectedAges.start,
                                            _selectedAges.end,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '"years"',
                                          style: _varryingTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GlobalWidgets.buildSettingsBlock(
                      description:
                      'With this enabled your profile will be visible to other people using this App',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Go to Advanced filters',
                            style: _varryingTextStyle,
                          ),
                          TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                  colorBlend01.withOpacity(0.2)),
                            ),
                            child: GlobalWidgets.imageToIcon(
                              'assets/images/forward_arrow.png',
                            ),
                            onPressed: () {


                              // Direct user to the Advanced filters Page.
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) {
                                    return AdvancedSettingsScreen();
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                              colorBlend01.withOpacity(0.2)),
                        ),
                        child: Text(
                          'Done',
                          style: _varryingTextStyle.copyWith(
                            color: colorBlend02,
                          ),
                        ),
                        onPressed: () {

                          //savePreferencesMethod();

                          // Pop current context.
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: CustomAppBar(
                title: 'Settings',
                iconURI: 'assets/images/settings_icon.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}