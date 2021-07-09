import 'dart:io';

import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/data_models/celeb.dart';
import 'package:betabeta/models/settings_model.dart';
import 'package:betabeta/screens/celebrity_selection_screen.dart';
import 'package:betabeta/screens/face_selection_screen.dart';
import 'package:betabeta/services/networking.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tuple/tuple.dart';

class AdvancedSettingsScreen extends StatefulWidget {
  AdvancedSettingsScreen({Key key}) : super(key: key);
  static const String routeName = '/advanced_settings_screen';
  static const String CELEB_FILTER = 'celeb_filter';
  static const String CUSTOM_FACE_FILTER = 'custom_face_filter';
  static const String TASTE_FILTER = 'taste_filter';
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
  Celeb _selectedCeleb = Celeb(celebName: SettingsData().celebId, imagesUrls: [
    SettingsData().filterDisplayImageUrl
  ]); //TODO support Celeb fetching from SettingsData
  String _currentChosenFilterName = SettingsData().filterName;
  int _chosenAuditionCount = SettingsData().auditionCount;

  // THis enables us to block the UI why a process that demands that is going on.
  bool isLoading = false;

  /// Here is where the custom-picked image is being Posted and sent over Network.
  void postCustomImageToNetwork(PickedFile chosenImage) async {
    // block the UI
    setState(() {
      isLoading = true;
    });

    try {
      Tuple2<img.Image, String> imageFileDetails =
          NetworkHelper().preparedFaceSearchImageFileDetails(File(chosenImage.path));

      //
      await NetworkHelper().postFaceSearchImage(imageFileDetails);

      //
      print('Here!');
      await Navigator.pushNamed(
        context,
        FaceSelectionScreen.routeName,
        arguments: FaceSelectionScreenArguments(
          imageFile: File(chosenImage.path),
          imageFileName: imageFileDetails.item2,
        ),
      );
    } catch (exception) {
      print(exception);

      // show an alert dialogue saying that an error occured.
      GlobalWidgets.showAlertDialogue(
        context,
        message: 'An error occured, please try again later!',
      );
    }

    // un-block the UI.
    setState(() {
      isLoading = false;
    });
  }

  Widget _buildFilterWidget({
    String title,
    String description,
    List<Widget> children,
    String filterName,
    double height = 175.0,
  }) {
    return GlobalWidgets.buildSettingsBlock(
        top: Column(
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
                          style: boldTextStyle,
                        )
                      : RichText(
                          text: TextSpan(
                            style: defaultTextStyle,
                            children: <InlineSpan>[
                              TextSpan(
                                text: '$title ',
                                style: boldTextStyle,
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
                    child: CupertinoSwitch(
                      value: filterName == _currentChosenFilterName,
                      activeColor: colorBlend01,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _currentChosenFilterName = filterName;
                          } else {
                            _currentChosenFilterName = '';
                          }
                          SettingsData().filterName = _currentChosenFilterName;
                        });
                      },
                    )),
              ],
            ),
          ],
        ),
        body: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: (_currentChosenFilterName != filterName) ? 0 : height,
            child: (_currentChosenFilterName != filterName)
                ? SizedBox.shrink()
                : Container(
                    child: SingleChildScrollView(
                        child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  )))));
  }

  //

  @override
  Widget build(BuildContext context) {
    //
    _currentChosenFilterName.length > 0
        ? _availableFilters = 0
        : _availableFilters = 1;
    resolveIntToString() {
      if (_availableFilters == 1) {
        return 'one';
      } else {
        return 'no';
      }
    }

    bool customImageExists = SettingsData().filterDisplayImageUrl != null &&
        SettingsData().filterDisplayImageUrl.length > 0;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: whiteCardColor,
          appBar: CustomAppBar(
            title: 'A.I. Filters',
            trailing: Icon(Icons.psychology_outlined, size: 34.0),
            hasTopPadding: true,
          ),
          body: Padding(
            padding: MediaQuery.of(context)
                .padding
                .copyWith(left: 12.0, right: 12.0, top: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
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
                      style: defaultTextStyle,
                      children: <InlineSpan>[
                        TextSpan(
                          style: boldTextStyle,
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
                              style: defaultTextStyle,
                              children: <InlineSpan>[
                                TextSpan(
                                  text: 'You can pick from one of these ',
                                ),
                                TextSpan(
                                  text: 'A.I. filters',
                                  style: boldTextStyle,
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
                                onPressed: () {
                                  // Direct user to the Celebrity Selection Page.
                                  Navigator.pushNamed(context,
                                          ScreenCelebritySelection.routeName)
                                      .then((selectedCeleb) {
                                    setState(() {
                                      // Set the `_selectedCeleb` variable to the newly selected
                                      // celebrity from the [CelebritySelectionScreen] page given that it is not null.
                                      if (selectedCeleb != null) {
                                        _selectedCeleb = selectedCeleb;
                                        SettingsData().celebId =
                                            _selectedCeleb.celebName;
                                      } else {
                                        //
                                        print('No Celebrity Selected!');
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
                                      style: boldTextStyle,
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
                                            style: defaultTextStyle.copyWith(
                                                color: linkColor),
                                          ),
                                        ),
                                        GlobalWidgets.assetImageToIcon(
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                                  style: defaultTextStyle,
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text:
                                                          '${AdvancedSettingsScreen.similarityDescriptions[_chosenAuditionCount]} Similar',
                                                      style: defaultTextStyle,
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
                                                activeColor:
                                                    CupertinoDynamicColor
                                                        .resolve(
                                                            CupertinoColors
                                                                .systemFill,
                                                            context),
                                                value: _chosenAuditionCount
                                                    .roundToDouble(),
                                                min: AdvancedSettingsScreen
                                                    .minAuditionValue
                                                    .roundToDouble(),
                                                max: AdvancedSettingsScreen
                                                    .maxAuditionValue
                                                    .roundToDouble(),
                                                divisions: 4,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _chosenAuditionCount =
                                                        value.round();
                                                    SettingsData()
                                                            .auditionCount =
                                                        _chosenAuditionCount;
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('More Matches'),
                                          Text('More Similar')
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          _buildFilterWidget(
                            height: customImageExists ? 205 : 175,
                            description:
                                'Search for people who look similar to anyone of your choice',
                            title: 'Custom Look-Alike',
                            filterName:
                                AdvancedSettingsScreen.CUSTOM_FACE_FILTER,
                            children: [
                              customImageExists
                                  ? SizedBox()
                                  : TextButton(
                                      onPressed: () async {
                                        // Direct user to the custom Selection Page.
                                        // await Navigator.pushNamed(context,
                                        //     ImageSourceSelectionScreen.routeName);
                                        // setState(() { //Make flutter rebuild the widget, as the image might have changed

                                        // });

                                        // Display an image picker Dilaogue.
                                        await GlobalWidgets
                                            .showImagePickerDialogue(
                                          context: context,
                                          onImagePicked: (imageFile) async {
                                            print('Done!');
                                            if (imageFile != null) {
                                              print(imageFile?.path);
                                              postCustomImageToNetwork(
                                                  imageFile);
                                            }
                                          },
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Choose Image',
                                            style: boldTextStyle,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 8.0),
                                                child: Text(
                                                  'Image Selection',
                                                  style:
                                                      defaultTextStyle.copyWith(
                                                          color: linkColor),
                                                ),
                                              ),
                                              GlobalWidgets.assetImageToIcon(
                                                'assets/images/forward_arrow.png',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                              !customImageExists
                                  ? SizedBox()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.network(
                                            NetworkHelper.faceUrlToFullUrl(
                                                SettingsData()
                                                    .filterDisplayImageUrl),
                                            height: 75,
                                            width: 75,
                                            fit: BoxFit.scaleDown),
                                        TextButton(
                                          onPressed: () {
                                            SettingsData()
                                                .filterDisplayImageUrl = '';
                                            setState(() {});
                                          },
                                          child: Row(
                                            children: [
                                              Text('Remove image',
                                                  style:
                                                      defaultTextStyle.copyWith(
                                                          color: linkColor)),
                                              Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              )
                                            ],
                                          ),
                                        )
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                                  style: defaultTextStyle,
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text:
                                                          '${AdvancedSettingsScreen.similarityDescriptions[_chosenAuditionCount]} Similar',
                                                      style: defaultTextStyle,
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
                                                activeColor:
                                                    CupertinoDynamicColor
                                                        .resolve(
                                                            CupertinoColors
                                                                .systemFill,
                                                            context),
                                                value: _chosenAuditionCount
                                                    .roundToDouble(),
                                                min: AdvancedSettingsScreen
                                                    .minAuditionValue
                                                    .roundToDouble(),
                                                max: AdvancedSettingsScreen
                                                    .maxAuditionValue
                                                    .roundToDouble(),
                                                divisions: 4,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _chosenAuditionCount =
                                                        value.round();
                                                    SettingsData()
                                                            .auditionCount =
                                                        _chosenAuditionCount;
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('More Matches'),
                                          Text('More Similar')
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ), //Filter custom face widget

                          _buildFilterWidget(
                            description: ' Find matches based on your taste',
                            title: 'Learnt Taste',
                            filterName: AdvancedSettingsScreen.TASTE_FILTER,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                  vertical: 5.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: RichText(
                                          text: TextSpan(
                                            style: defaultTextStyle,
                                            children: <InlineSpan>[
                                              TextSpan(
                                                text:
                                                    'Choose one out of  $_chosenAuditionCount ',
                                                style: defaultTextStyle,
                                              ),
                                              TextSpan(
                                                text: 'People ',
                                                style: boldTextStyle,
                                              ),
                                              WidgetSpan(
                                                child: GestureDetector(
                                                  child: Text(
                                                    "  what's this?",
                                                    style: defaultTextStyle
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
                                                      title: 'Audition Count',
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                          min: AdvancedSettingsScreen
                                              .minAuditionValue
                                              .roundToDouble(),
                                          max: AdvancedSettingsScreen
                                              .maxAuditionValue
                                              .roundToDouble(),
                                          divisions: 5,
                                          onChanged: (value) {
                                            setState(() {
                                              _chosenAuditionCount =
                                                  value.round();
                                              SettingsData().auditionCount =
                                                  _chosenAuditionCount;
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('More Matches'),
                                    Text('More Accurate')
                                  ],
                                ),
                              )
                            ],
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
                                style: boldTextStyle.copyWith(
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
        ),
        if (isLoading)
          Material(
            color: Colors.grey.withOpacity(0.64),
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          ),
      ],
    );
  }
}
