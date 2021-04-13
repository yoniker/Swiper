import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/data_models/celeb.dart';
import 'package:betabeta/screens/celebrity_selection_screen.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdvancedSettingsScreen extends StatefulWidget {
  AdvancedSettingsScreen({Key key}) : super(key: key);

  @override
  _AdvancedSettingsScreenState createState() => _AdvancedSettingsScreenState();
}

class _AdvancedSettingsScreenState extends State<AdvancedSettingsScreen> {
  // Create a new instance of the SettingsService class.

  //
  bool _applyFilter = false;

  // The index of the selected filter.
  int _filterIndex = 0;

  //
  int _availableFilters = 1;

  //
  Celeb _selectedCeleb=Celeb(celebName:'Dor',name:'Dor'); //TODO support Celeb fetching from SettingsData

  //
  int _auditionCount = 50; //TODO support audition count at SettingsData

  Widget _buildFilterWidget({
    String title,
    String description,
    List<Widget> children,
    int index,
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
                child: (index != _filterIndex)
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
    value: index == _filterIndex,
    activeColor: colorBlend01,
    onChanged: (value) {
      setState(() {
        if (value == true){
        _filterIndex = index;}
        else{
          _filterIndex = -1;
        }
      });
    },
              )),
            ],
          ),
        ],
      ),
        child:AnimatedContainer(
        duration: Duration(milliseconds: 500),
    height: (_filterIndex != index)?0:175,
    child:(_filterIndex != index)
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
    _filterIndex>=0 ? _availableFilters=0 : _availableFilters = 1;
    resolveIntToString() {
      if (_availableFilters == 1) {
        return 'one';
      } else {
        return 'no';
      }
    }

    return Scaffold(
      backgroundColor: whiteCardColor,
      body: Padding(
        padding:
        MediaQuery.of(context).padding.copyWith(left: 12.0, right: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomAppBar(
              title: 'A.I. Filters',
               icon: Icon(Icons.psychology_outlined,size:34.0),
            ),
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
                        index: 1,
                        children: [
                                Row(
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
                                            '${_selectedCeleb?.celebName}',
                                            style: _defaultTextStyle,
                                          ),
                                        ),
                                        TextButton(
                                          style: ButtonStyle(
                                            overlayColor:
                                            MaterialStateProperty.all(
                                                colorBlend01
                                                    .withOpacity(0.2)),
                                          ),
                                          child: GlobalWidgets.imageToIcon(
                                            'assets/images/forward_arrow.png',
                                          ),
                                          onPressed: () {
                                            // Direct user to the Celebrity Selection Page.
                                            Navigator.of(context).push<Celeb>(
                                              CupertinoPageRoute<Celeb>(
                                                builder: (context) {
                                                  return ScreenCelebritySelection();
                                                },
                                              ),
                                            ).then((selectedCeleb) {
                                              setState(() {
                                                // Set the `_selectedCeleb` variable to the newly selected
                                                // celebrity from the [CelebritySelectionScreen] page given that it is not null.
                                                if (selectedCeleb != null) {
                                                  _selectedCeleb =
                                                      selectedCeleb;
                                                } else {
                                                  //
                                                  print(
                                                      'No Celebrity Selected!');
                                                }
                                              });
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
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
                                                        'Audition $_auditionCount ',
                                                        style:
                                                        _defaultTextStyle,
                                                      ),
                                                      TextSpan(
                                                        text: 'People ',
                                                        style:
                                                        _boldTextStyle,
                                                      ),
                                                      WidgetSpan(
                                                        child: GestureDetector(
                                                          child: Text(
                                                            "  what's this?",
                                                            style:
                                                            _defaultTextStyle
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
                                                            print(
                                                                "what's this");
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
                                              Icons.person_outline,
                                              size: 24.0,
                                              color: colorBlend01,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12.0),
                                                child: CupertinoSlider(
                                                  activeColor: colorBlend01,
                                                  value: _auditionCount
                                                      .roundToDouble(),
                                                  min: 21,
                                                  max: 100,
                                                  divisions: 80,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _auditionCount =
                                                          value.toInt();
                                                      // print the current value of `_auditionCount` to console.
                                                      //<debug>
                                                      print(_auditionCount);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.people_alt_outlined,
                                              size: 24.0,
                                              color: colorBlend01,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],

                        ),
                      _buildFilterWidget(
                        description:
                        ' Find Matches Based On Your Taste',
                        title: 'Learnt Taste',
                        index: 2,
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
                                                  'Audition $_auditionCount ',
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
                                        Icons.person_outline,
                                        size: 24.0,
                                        color: colorBlend01,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: CupertinoSlider(
                                            activeColor: colorBlend01,
                                            value: _auditionCount
                                                .roundToDouble(),
                                            min: 21,
                                            max: 100,
                                            divisions: 80,
                                            onChanged: (value) {
                                              setState(() {
                                                _auditionCount =
                                                    value.toInt();
                                                // print the current value of `_auditionCount` to console.
                                                //<debug>
                                                print(_auditionCount);
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
                              ],

                      ),
                      // build the [done] button.
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                (!_applyFilter)
                                    ? Colors.grey[350]
                                    : colorBlend01.withOpacity(0.2)),
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