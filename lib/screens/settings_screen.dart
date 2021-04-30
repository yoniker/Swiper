import 'dart:math' as math;

import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/models/settings_model.dart';
import 'package:betabeta/widgets/cupertino_range_slider.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/dropdown_form_field.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DropdownButtonFormField;

import 'advanced_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key, this.onPop}) : super(key: key);
  static const String routeName = '/settings_screen';
  static const minAge = 18;
  static const maxAge = 100;

  final void Function() onPop;

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _currentLocation = 'Somewhere, Earth';

  Gender _currentGenderSelected = Gender.values
      .firstWhere((e) => e.toShortString() == SettingsData().preferredGender);
  RangeValues _selectedAges = RangeValues(
      SettingsData().minAge.toDouble(), SettingsData().maxAge.toDouble());
  bool _showInDiscovery =
      false; //TODO change SettingsData to support visibility
  double _maxDistance = SettingsData().radius;

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
        style: defaultTextStyle,
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

  //

  String _simpleDashAgeRangeString(double start, double end) {
    if (end < SettingsScreen.maxAge) {
      return ' ${start.round()}-${end.round()} ';
    } else {
      return ' ${start.round()}-${SettingsScreen.maxAge}+ ';
    }
  }

  String produceAgesRangeText(RangeValues _ages) {
    String agesRangeText;

    if (_ages.start.toInt() <= SettingsScreen.minAge) {
      if (_ages.end.toInt() >= SettingsScreen.maxAge) {
        agesRangeText = 'Any Age';
      } else {
        agesRangeText = '${_ages.end.toInt()} or younger';
      }
    } else {
      if (_ages.end.toInt() >= SettingsScreen.maxAge) {
        agesRangeText = '${_ages.start.toInt()} or older';
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
      appBar: CustomAppBar(
        title: 'Settings',
        hasTopPadding: true,
        icon:
            Icon(Icons.settings), //iconURI: 'assets/images/settings_icon.png',
        onPop: widget.onPop,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                GlobalWidgets.buildSettingsBlock(
                  title: 'Visibility'.toUpperCase(),
                  description:
                      'With this enabled your profile will be visible to other people using this App',
                  child: Padding(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 8.0),
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
                        margin: EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 8.0),
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
                                          SettingsData().radius = _maxDistance;
                                          // Add to the `_editionCount` variable.
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
                  child: Padding(
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
                                color: Colors.grey[200],
                                width: 100,
                                child: DropdownButtonFormFieldModified<Gender>(
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'My Preferred Gender',
                                    hintStyle: defaultTextStyle.copyWith(
                                      color: darkTextColor,
                                    ),
                                  ),
                                  isExpanded: false,
                                  onChanged: (newGender) {
                                    setState(() {
                                      SettingsData().preferredGender =
                                          newGender.toShortString();
                                      _currentGenderSelected = newGender;
                                    });
                                  },
                                  style: defaultTextStyle,
                                  value: _currentGenderSelected,
                                  items: Gender.values.map(
                                    (gender) {
                                      return _buildGenderDropDownMenuItem(
                                          gender);
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                        min: SettingsScreen.minAge.toDouble(),
                                        max: SettingsScreen.maxAge.toDouble(),
                                        onChanged: (newRangevalues) {
                                          setState(
                                            () {
                                              _selectedAges = RangeValues(
                                                newRangevalues.start
                                                    .roundToDouble(),
                                                newRangevalues.end
                                                    .roundToDouble(),
                                              );
                                              SettingsData().minAge =
                                                  _selectedAges.start.toInt();
                                              SettingsData().maxAge =
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
                  child: TextButton(
                    onPressed: () {
                      // Direct user to the Advanced filters Page.

                      Navigator.pushNamed(
                          context, AdvancedSettingsScreen.routeName);
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
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          colorBlend01.withOpacity(0.2)),
                    ),
                    child: Text(
                      'Done',
                      style: boldTextStyle.copyWith(
                        color: colorBlend02,
                      ),
                    ),
                    onPressed: widget.onPop ??
                        () {
                          //savePreferencesMethod();

                          // Pop current context.
                          Navigator.of(context).pop();
                        },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
