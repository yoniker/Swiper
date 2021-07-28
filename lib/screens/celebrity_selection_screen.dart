import 'dart:async';

import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/data_models/celeb.dart';
import 'package:betabeta/models/celebs_info_model.dart';
import 'package:betabeta/widgets/celeb_widget.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ScreenCelebritySelection extends StatefulWidget {
  static const String routeName = '/celebrity_select_screen';
  final int msCelebsDebounce = 200;
  @override
  _ScreenCelebritySelectionState createState() =>
      _ScreenCelebritySelectionState();
}

class _ScreenCelebritySelectionState extends State<ScreenCelebritySelection> {
  Timer
      _debounce; //Define debounce, see https://stackoverflow.com/questions/51791501/how-to-debounce-textfield-onchange-in-dart
  TextEditingController _controller = TextEditingController();

  _onSearchChanged(String query, CelebsInfo celebInfo) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer( Duration(milliseconds: widget.msCelebsDebounce), () {
      celebInfo.sortListByKeywords(query);
    });
  }

  FocusNode textFieldFocus;

  // Used to determine wether or not the searchbox is focused.
  //
  // We need this so that we can change the color of the ""clear-button"" accordingly.
  bool searchBoxIsFocused = false;
  ScrollController _listController = ScrollController();
  DateTime _lastCelebInfoChange = DateTime.now();

  @override
  void initState() {
    super.initState();
    _lastCelebInfoChange = DateTime.now();
    textFieldFocus = FocusNode();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    textFieldFocus.dispose();
    _listController.dispose();
    super.dispose();
  }

  void unfocus() {
    FocusScopeNode currentFocus = FocusScope.of(
        context); //Dismiss the keyboard, see https://flutterigniter.com/dismiss-keyboard-form-lose-focus/

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    // make sure we update the state of the "searchBoxIsFocused" variable
    // when the searchBox is no longer in focus.
    setState(() {
      searchBoxIsFocused = false;
    });
  }

  void toggleFocus() {
    if (textFieldFocus.hasFocus) {
      textFieldFocus.unfocus();
    } else {
      textFieldFocus.requestFocus();
    }

    // make sure we update the state of the "searchBoxIsFocused" variable
    // when the searchBox is no longer in focus or the other way round.
    setState(() {
      // don't understand why this has to be inverted. Normally, it is expected that "hasFocus" returns
      // a boolean value of true if it has focus but this behaves otherwise returning true when it has no foucs
      // and false when it doesn't.
      searchBoxIsFocused = !textFieldFocus.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CelebsInfo>(
      builder: (context, celebInfo, child) {
        int _numCelebsToShow = 0;
        if (celebInfo.infoLoadedFromDatabase()) {
          _numCelebsToShow = celebInfo.entireCelebsList.length;
        }

        if (_listController.hasClients && celebInfo.lastChangeTime.difference(_lastCelebInfoChange)>Duration(milliseconds: 0))
        {
          _listController.jumpTo(0);
          print(celebInfo.lastChangeTime);
          _lastCelebInfoChange = celebInfo.lastChangeTime;
        }
        return Scaffold(
          backgroundColor: whiteCardColor,
          appBar: CustomAppBar(
            title: 'Search Celeb',
            hasTopPadding: true,
            showAppLogo: false,
            trailing: FaIcon(FontAwesomeIcons.addressCard),
          ),
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 12.50,
                  horizontal: 7.5,
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: textFieldFocus,
                  cursorColor: colorBlend02,
                  decoration: InputDecoration(
                    fillColor: lightCardColor,
                    filled: true,
                    prefixIcon: GlobalWidgets.assetImageToIcon(
                      BetaIconPaths.inactiveMatchTabIconPath,
                      onTap: toggleFocus,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: searchBoxIsFocused
                            ? colorBlend02
                            : darkTextColor.withOpacity(0.5),
                      ),
                      onPressed: () {
                        _controller.clear();
                        _onSearchChanged('', celebInfo);
                      },
                      iconSize: 24.0,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: lightCardColor),
                      borderRadius: BorderRadius.circular(12.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: lightCardColor),
                      borderRadius: BorderRadius.circular(12.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: lightCardColor),
                      borderRadius: BorderRadius.circular(12.5),
                    ),
                    hintText: 'Enter Celeb Name Here',
                  ),
                  onTap: () {
                    // here we will set "searchBoxIsFocused" to true and this will
                    // cause the color of the "clear-button" to change to the color want.
                    setState(() {
                      searchBoxIsFocused = true;
                    });
                  },
                  onChanged: (String newText) {
                    _onSearchChanged(newText, celebInfo);
                  },
                  onEditingComplete: () {
                    // remove focus form the Text Field.
                    unfocus();
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    controller: _listController,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 15.0);
                    },
                    itemCount: _numCelebsToShow,
                    itemBuilder: (BuildContext context, int index) {
                      Celeb currentCeleb = celebInfo.entireCelebsList[index];
                      return CelebWidget(
                        theCeleb: currentCeleb,
                        celebsInfo: celebInfo,
                        celebIndex : index,
                        onTap: () {
                          Navigator.pop(context, currentCeleb);
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
