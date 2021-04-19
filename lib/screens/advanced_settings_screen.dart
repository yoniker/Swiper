import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/data_models/celeb.dart';
import 'package:betabeta/models/settings_model.dart';
import 'package:betabeta/screens/celebrity_selection_screen.dart';
import 'package:betabeta/screens/image_source_selection_screen.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdvancedSettingsScreen extends StatefulWidget {
  AdvancedSettingsScreen({Key key}) : super(key: key);
  static const String routeName = '/advanced_settings_screen';
  static const String CELEB_FILTER='celeb_filter';
  static const String CUSTOM_FACE_FILTER = 'custom_face_filter';
  static const String TASTE_FILTER='taste_filter';
  static const minAuditionValue = 0.0;
  static const maxAuditionValue = 4.0;
  static const List<String> similarityDescriptions = [
    'Remotely',
    'Somewhat',
    '',
    'Very',
    'Extremely'

  ];

  @override
  _AdvancedSettingsScreenState createState() => _AdvancedSettingsScreenState();
}

class _AdvancedSettingsScreenState extends State<AdvancedSettingsScreen> {
  
  int _availableFilters = 1;
  Celeb _selectedCeleb=Celeb(celebName:SettingsData().celebId,imagesUrls: [SettingsData().filterDisplayImageUrl]); //TODO support Celeb fetching from SettingsData
  String _currentChosenFilterName = SettingsData().filterName;
  int _chosenAuditionCount = SettingsData().auditionCount;

  Widget _buildFilterWidget({
    String title,
    String description,
    List<Widget> children,
    String filterName,
  }) {
    return GlobalWidgets.buildSettingsBlock(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: (filterName != _currentChosenFilterName)
                    ? Text(
                  '$title ',
                  style: _boldTextStyle,
                )
                    : RichText(
                  text: TextSpan(
                    style: _defaultTextStyle,
                    children: <InlineSpan>[
                      TextSpan(
                        text: '$title ',
                        style: _boldTextStyle,
                      ),
                      TextSpan(
                        text: '$description ',
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child:CupertinoSwitch(
    value: filterName == _currentChosenFilterName,
    activeColor: colorBlend01,
    onChanged: (value) {
      setState(() {
        if (value == true){
          _currentChosenFilterName = filterName;}
        else{
          _currentChosenFilterName='';
        }
        SettingsData().filterName = _currentChosenFilterName;
      });
    },
              )),
            ],
          ),
        ],
      ),
        child:AnimatedContainer(
        duration: Duration(milliseconds: 500),
    height: (_currentChosenFilterName != filterName)?0:175,
    child:(_currentChosenFilterName != filterName)
    ? SizedBox.shrink()
        : Container(
    child: SingleChildScrollView(
    child: Column(
    mainAxisAlignment:
    MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.center,
    children:children,
    )))));
  }

  //
  var _defaultTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'Nunito',
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  var _boldTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'Nunito',
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  @override
  Widget build(BuildContext context) {
    //
    _currentChosenFilterName.length>0 ? _availableFilters=0 : _availableFilters = 1;
    resolveIntToString() {
      if (_availableFilters == 1) {
        return 'one';
      } else {
        return 'no';
      }
    }

    return Scaffold(
      backgroundColor: whiteCardColor,
      appBar: CustomAppBar(
        title: 'A.I. Filters',
        icon: Icon(Icons.psychology_outlined,size:34.0),
      ),
      body: Padding(
        padding:
        MediaQuery.of(context).padding.copyWith(left: 12.0, right: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: [
                  BoxShadow(
                    color: darkCardColor,
                    blurRadius: 12.0,
                  ),
                ],
              ),
              child: RichText(
                text: TextSpan(
                  style: _defaultTextStyle,
                  children: <InlineSpan>[
                    TextSpan(
                      style: _boldTextStyle,
                      text: ' ${resolveIntToString()} ',
                    ),
                    TextSpan(text: 'filter(s) left'),
                  ],
                ),
              ),
            ),
            Container(
              child: Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: _defaultTextStyle,
                          children: <InlineSpan>[
                            TextSpan(
                              text: 'You can pick from one of these ',
                            ),
                            TextSpan(
                              text: 'A.I. filters',
                              style: _boldTextStyle,
                            ),
                          ],
                        ),
                      ),
                      _buildFilterWidget(
                        description:
                        'Search for people who look similar to a celebrity of your choice',
                        title: 'Celeb Look-Alike',
                        filterName: AdvancedSettingsScreen.CELEB_FILTER,
                        children: [
                                TextButton(
                                      onPressed:() {
                                    // Direct user to the Celebrity Selection Page.
                                     Navigator.pushNamed(context,
                                      ScreenCelebritySelection.routeName
                                    ).then((selectedCeleb) {
                                      setState(() {
                                        // Set the `_selectedCeleb` variable to the newly selected
                                        // celebrity from the [CelebritySelectionScreen] page given that it is not null.
                                        if (selectedCeleb != null) {
                                          _selectedCeleb = selectedCeleb;
                                          SettingsData().celebId = _selectedCeleb.celebName;
                                        } else {
                                          //
                                          print(
                                              'No Celebrity Selected!');
                                        }
                                      });
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Search Celeb',
                                        style: _boldTextStyle,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 8.0),
                                            child: Text(
                                              '${_selectedCeleb.celebName}',
                                              style: _defaultTextStyle.copyWith(color: linkColor),
                                            ),
                                          ),


                                            GlobalWidgets.imageToIcon(
                                              'assets/images/forward_arrow.png',
                                            ),

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: darkCardColor,
                                  thickness: 2.0,
                                  indent: 24.0,
                                  endIndent: 24.0,
                                ),

                                // Build the Audition count tab.
                                Container(
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5.0,
                                          vertical: 5.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: RichText(
                                                  text: TextSpan(
                                                    style: _defaultTextStyle,
                                                    children: <InlineSpan>[
                                                      TextSpan(
                                                        text:
                                                        '${AdvancedSettingsScreen.similarityDescriptions[_chosenAuditionCount]} Similar',
                                                        style:
                                                        _defaultTextStyle,
                                                      ),


                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5.0,
                                          vertical: 5.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.group_outlined,
                                              size: 24.0,
                                              color: colorBlend01,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12.0),
                                                child: CupertinoSlider(
                                                  activeColor: CupertinoDynamicColor.resolve(CupertinoColors.systemFill, context),
                                                  value: _chosenAuditionCount.roundToDouble(),
                                                  min: AdvancedSettingsScreen.minAuditionValue.roundToDouble(),
                                                  max: AdvancedSettingsScreen.maxAuditionValue.roundToDouble(),
                                                  divisions: 4,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _chosenAuditionCount = value.round();
                                                      SettingsData().auditionCount = _chosenAuditionCount;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.person_outline,
                                              size: 24.0,
                                              color: colorBlend01,
                                            ),
                                          ],
                                        ),

                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [Text('More Matches'),Text('More Similar')],),
                                      )
                                    ],
                                  ),
                                ),
                            ],

                        ),
                      _buildFilterWidget(
                        description:
                        'Search for people who look similar to anyone of your choice',
                        title: 'Custom Look-Alike',
                        filterName: AdvancedSettingsScreen.CUSTOM_FACE_FILTER,
                        children: [
                          TextButton(
                            onPressed:() {
                              // Direct user to the custom Selection Page.
                              Navigator.of(context).pushNamed(ImageSourceSelectionScreen.routeName);
                            },
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Choose Image',
                                  style: _boldTextStyle,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        'Image Selection',
                                        style: _defaultTextStyle.copyWith(color:linkColor),
                                      ),
                                    ),


                                    GlobalWidgets.imageToIcon(
                                      'assets/images/forward_arrow.png',
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: darkCardColor,
                            thickness: 2.0,
                            indent: 24.0,
                            endIndent: 24.0,
                          ),

                          // Build the Audition count tab.
                          Container(
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.0,
                                    vertical: 5.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: RichText(
                                            text: TextSpan(
                                              style: _defaultTextStyle,
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  text:
                                                  '${AdvancedSettingsScreen.similarityDescriptions[_chosenAuditionCount]} Similar',
                                                  style:
                                                  _defaultTextStyle,
                                                ),


                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.0,
                                    vertical: 5.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.group_outlined,
                                        size: 24.0,
                                        color: colorBlend01,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: CupertinoSlider(
                                            activeColor: CupertinoDynamicColor.resolve(CupertinoColors.systemFill, context),
                                            value: _chosenAuditionCount.roundToDouble(),
                                            min: AdvancedSettingsScreen.minAuditionValue.roundToDouble(),
                                            max: AdvancedSettingsScreen.maxAuditionValue.roundToDouble(),
                                            divisions: 4,
                                            onChanged: (value) {
                                              setState(() {
                                                _chosenAuditionCount = value.round();
                                                SettingsData().auditionCount = _chosenAuditionCount;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.person_outline,
                                        size: 24.0,
                                        color: colorBlend01,
                                      ),
                                    ],
                                  ),

                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [Text('More Matches'),Text('More Similar')],),
                                )
                              ],
                            ),
                          ),
                        ],

                      ),//Filter custom face widget


                      _buildFilterWidget(
                        description:
                        ' Find matches based on your taste',
                        title: 'Learnt Taste',
                        filterName: AdvancedSettingsScreen.TASTE_FILTER,
                        children:[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.0,
                                    vertical: 5.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: RichText(
                                            text: TextSpan(
                                              style: _defaultTextStyle,
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  text:
                                                  'Choose one out of  $_chosenAuditionCount ',
                                                  style: _defaultTextStyle,
                                                ),
                                                TextSpan(
                                                  text: 'People ',
                                                  style: _boldTextStyle,
                                                ),
                                                WidgetSpan(
                                                  child: GestureDetector(
                                                    child: Text(
                                                      "  what's this?",
                                                      style: _defaultTextStyle
                                                          .copyWith(
                                                        color: linkColor,
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      // print "what's this" to console for now.
                                                      // TODO: Add Appropriate functionality.

                                                      // What's this Functionality.
                                                      GlobalWidgets
                                                          .showAlertDialogue(
                                                        context,
                                                        title:
                                                        'Audition Count',
                                                        message:
                                                        'This denotes the number of profiles to display, the highest you can select is 100',
                                                      );
                                                      //<debug>
                                                      //
                                                      print("what's this");
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.0,
                                    vertical: 5.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.group_outlined,
                                        size: 24.0,
                                        color: colorBlend01,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: CupertinoSlider(
                                            activeColor: colorBlend01,
                                            value: _chosenAuditionCount
                                                .roundToDouble(),
                                            min: AdvancedSettingsScreen.minAuditionValue.roundToDouble(),
                                            max: AdvancedSettingsScreen.maxAuditionValue.roundToDouble(),
                                            divisions: 5,
                                            onChanged: (value) {
                                              setState(() {
                                                _chosenAuditionCount =
                                                    value.round();
                                                SettingsData().auditionCount = _chosenAuditionCount;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.person_outline,
                                        size: 24.0,
                                        color: colorBlend01,
                                      ),
                                    ],
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('More Matches'),Text('More Accurate')],),
                              )],

                      ),
                      // build the [done] button.
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                 colorBlend01.withOpacity(0.2)),
                          ),
                          child: Text(
                            'Done',
                            style: _boldTextStyle.copyWith(
                              color: colorBlend02,
                            ),
                          ),
                          onPressed: () {
                            // call the `saveFilter` Function when the done button is clicked

                            // Pop current context.
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}