import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/data_models/celeb.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/screens/celebrity_selection_screen.dart';
import 'package:betabeta/screens/face_selection_screen.dart';
import 'package:betabeta/services/networking.dart';
import 'package:betabeta/widgets/advance_filter_card_widget.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/onboarding/input_field.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tuple/tuple.dart';

class VoilaPage extends StatefulWidget {
  static const String routeName = '/voila_page';

  @override
  State<VoilaPage> createState() => _VoilaPageState();
}

class _VoilaPageState extends State<VoilaPage>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = false;
  bool isPressed = false;
  String textSearchTyped = SettingsData.instance.textSearch;

  /// Here is where the custom-picked image is being Posted and sent over Network.
  Future<void> postCustomImageToNetwork(XFile chosenImage) async {
    // block the UI
    setState(() {
      isLoading = true;
    });

    try {
      Tuple2<img.Image, String> imageFileDetails =
          await NetworkHelper().preparedFaceSearchImageFileDetails(chosenImage);

      //
      await NetworkHelper().postFaceSearchImage(imageFileDetails);

      //

      await Get.toNamed(
        FaceSelectionScreen.routeName,
        arguments: FaceSelectionScreenArguments(
          imageFile: File(chosenImage.path),
          imageFileName: imageFileDetails.item2,
        ),
      );
      print(SettingsData.instance.filterType);
      print(SettingsData.instance.filterDisplayImageUrl);
      print('dor');
    } catch (exception) {
      print(exception);

      // show an alert dialogue saying that an error occurred.
      GlobalWidgets.showAlertDialogue(
        context,
        message: 'An error occurred, please try again later!',
      );
    }

    // un-block the UI.
    setState(() {
      isLoading = false;
    });
  }

  void inDevelopmentPopUp() {
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text(
                "Coming Soon!",
              ),
              content: Text('Coming in 2022. Stay Toned!'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Colors.red),
                    ))
              ],
            ));
  }

  @override
  void initState() {
    print(SettingsData.instance.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Advance Search',
        hasTopPadding: true,
        hasBackButton: true,
      ),
      backgroundColor: Colors.white,
      body: ListenerWidget(
          notifier: SettingsData.instance,
          builder: (BuildContext context) {
            bool customImageExists =
                SettingsData.instance.filterDisplayImageUrl.length > 0;
            Celeb _selectedCeleb = Celeb(
                celebName: SettingsData.instance.celebId,
                imagesUrls: [SettingsData.instance.filterDisplayImageUrl]);
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                child: Column(
                  children: [
                    Container(
                      child: Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: AnimatedContainer(
                                        margin:
                                            SettingsData.instance.filterType !=
                                                    FilterType.NONE
                                                ? EdgeInsets.only(bottom: 10)
                                                : EdgeInsets.zero,
                                        height:
                                            SettingsData.instance.filterType !=
                                                    FilterType.NONE
                                                ? 40
                                                : 0,
                                        width:
                                            SettingsData.instance.filterType !=
                                                    FilterType.NONE
                                                ? 1000
                                                : 0,
                                        duration: Duration(milliseconds: 500),
                                        child: SizedBox(
                                          width: 100,
                                          child: RoundedButton(
                                            elevation: 4,
                                            name: 'Deactivate filters',
                                            onTap: () {
                                              SettingsData.instance.filterType =
                                                  FilterType.NONE;
                                              SettingsData.instance
                                                  .filterDisplayImageUrl = '';
                                            },
                                            withPadding: false,
                                            color: Colors.red[800],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                AdvanceFilterCard(
                                    onTap: () {
                                      setState(
                                        () {
                                          SettingsData.instance.filterType =
                                              FilterType.TEXT_SEARCH;
                                          SettingsData.instance
                                              .filterDisplayImageUrl = '';
                                        },
                                      );
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: AnimatedContainer(
                                      width: 400,
                                      height:
                                          SettingsData.instance.filterType !=
                                                  FilterType.TEXT_SEARCH
                                              ? 0
                                              : 54,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: SingleChildScrollView(
                                        child: InputField(
                                          borderColor: appMainColor,
                                          onFocusChange: (hasFocus) {
                                            if (!hasFocus) {
                                              SettingsData.instance.textSearch =
                                                  textSearchTyped;
                                              print(SettingsData
                                                      .instance.textSearch +
                                                  ' testing if changed');
                                              for (int i = 0; i < 4; ++i)
                                                print(
                                                    'finished typing $textSearchTyped');
                                              if (SettingsData.instance
                                                      .textSearch.length !=
                                                  0) Get.back();
                                              if (SettingsData.instance
                                                      .textSearch.length ==
                                                  0)
                                                SettingsData
                                                        .instance.filterType =
                                                    FilterType.NONE;
                                              SettingsData.instance
                                                  .filterDisplayImageUrl = '';
                                            }
                                          },
                                          onType: (value) {
                                            setState(() {
                                              textSearchTyped = value;
                                            });
                                          },
                                          onTapIcon: textSearchTyped.length > 0
                                              ? () {
                                                  print(
                                                      'move to match screen?');
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                }
                                              : null,
                                          hintText: ' Search...',
                                          maxLines: 1,
                                          maxCharacters: 20,
                                          icon: Icons.search,
                                          iconSize: 30,
                                          initialvalue: textSearchTyped,
                                        ),
                                      ),
                                    ),
                                    isActive:
                                        SettingsData.instance.filterType ==
                                            FilterType.TEXT_SEARCH,
                                    image: AssetImage(
                                        'assets/images/textsearch2.jpg'),
                                    comingSoon: false,
                                    showAI: false,
                                    title: Row(
                                      children: [
                                        Text(
                                          'Text Search',
                                          style: LargeTitleStyleWhite,
                                        ),
                                        DefaultTextStyle(
                                          style: LargeTitleStyleWhite,
                                          child: AnimatedTextKit(
                                            pause: Duration(seconds: 2),
                                            repeatForever: true,
                                            animatedTexts: [
                                              TyperAnimatedText(
                                                '   Dog lover?...',
                                                speed:
                                                    Duration(milliseconds: 100),
                                              ),
                                              TyperAnimatedText(
                                                '   Vegan?...',
                                                speed:
                                                    Duration(milliseconds: 100),
                                              ),
                                              TyperAnimatedText(
                                                '   Outdoors?...',
                                                speed:
                                                    Duration(milliseconds: 100),
                                              ),
                                              TyperAnimatedText(
                                                '   Sushi?...',
                                                speed:
                                                    Duration(milliseconds: 100),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    info: 'Search by a simple word or text'),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AdvanceFilterCard(
                                          isActive: SettingsData
                                                  .instance.filterType ==
                                              FilterType.CUSTOM_IMAGE,
                                          image: AssetImage(
                                              'assets/images/picture5.jpg'),
                                          title: Text(
                                            FilterType.CUSTOM_IMAGE.description,
                                            style: titleStyleWhite,
                                          ),
                                          onTap: () async {
                                            SettingsData.instance
                                                .filterDisplayImageUrl = '';
                                            bool imagePicked = false;
                                            await GlobalWidgets
                                                .showImagePickerDialogue(
                                              context: context,
                                              onImagePicked: (imageFile) async {
                                                imagePicked = true;
                                                if (imageFile != null) {
                                                  await postCustomImageToNetwork(
                                                      imageFile);
                                                  SettingsData
                                                          .instance.filterType =
                                                      FilterType.CUSTOM_IMAGE;
                                                  Get.back();
                                                } else {
                                                  SettingsData
                                                          .instance.filterType =
                                                      FilterType.NONE;
                                                }
                                              },
                                            );
                                            if (!imagePicked) {
                                              SettingsData.instance.filterType =
                                                  FilterType.NONE;
                                            }
                                          },
                                          info:
                                              'Discover picture \nlook-a-likes.'),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: AdvanceFilterCard(
                                          image: AssetImage(
                                              'assets/images/celeb3.jpg'),
                                          isActive: SettingsData
                                                  .instance.filterType ==
                                              FilterType.CELEB_IMAGE,
                                          onTap: () async {
                                            var selectedCeleb =
                                                await Get.toNamed(
                                                    ScreenCelebritySelection
                                                        .routeName);
                                            SettingsData.instance.filterType =
                                                FilterType.CELEB_IMAGE;
                                            // Set the `_selectedCeleb` variable to the newly selected
                                            // celebrity from the [CelebritySelectionScreen] page given that it is not null.
                                            if (selectedCeleb != null) {
                                              _selectedCeleb =
                                                  selectedCeleb as Celeb;
                                              SettingsData.instance.celebId =
                                                  _selectedCeleb.celebName;
                                              SettingsData.instance.filterType =
                                                  FilterType.CELEB_IMAGE;
                                              if (_selectedCeleb.imagesUrls !=
                                                      null &&
                                                  _selectedCeleb
                                                          .imagesUrls!.length >
                                                      0) {
                                                SettingsData.instance
                                                        .filterDisplayImageUrl =
                                                    _selectedCeleb
                                                        .imagesUrls![0];
                                                Get.back();
                                              } else {
                                                SettingsData.instance
                                                    .filterDisplayImageUrl = '';
                                              }
                                            } else {
                                              SettingsData.instance
                                                  .filterDisplayImageUrl = '';
                                              SettingsData.instance.celebId =
                                                  '';
                                              SettingsData.instance.filterType =
                                                  FilterType.NONE;
                                              //No celebrity selected
                                            }
                                          },
                                          title: Text(
                                            FilterType.CELEB_IMAGE.description,
                                            style: titleStyleWhite,
                                          ),
                                          info:
                                              'Discover celebrity \nlook-a-likes.'),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AdvanceFilterCard(
                                          onTap: () {
                                            inDevelopmentPopUp();
                                          },
                                          comingSoon: true,
                                          image: AssetImage(
                                              'assets/images/taste5.jpg'),
                                          title: Text(
                                            'Your Taste',
                                            style: titleStyleWhite,
                                          ),
                                          info:
                                              'Show me people \nwho are my taste'),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: AdvanceFilterCard(
                                          onTap: () {
                                            inDevelopmentPopUp();
                                          },
                                          comingSoon: true,
                                          image: AssetImage(
                                              'assets/images/taste2.jpg'),
                                          title: Text(
                                            'Their Taste',
                                            style: titleStyleWhite,
                                          ),
                                          info:
                                              'Show me people who are more likely to like me'),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                AdvanceFilterCard(
                                    image: AssetImage('assets/images/bar3.jpg'),
                                    title: Text(
                                      'Local Bar.',
                                      style: LargeTitleStyleWhite,
                                    ),
                                    onTap: () {
                                      inDevelopmentPopUp();
                                    },
                                    comingSoon: true,
                                    info:
                                        'Join the local bar and meet people around you!')
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
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
