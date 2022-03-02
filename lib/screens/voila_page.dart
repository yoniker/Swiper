import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/data_models/celeb.dart';
import 'package:betabeta/screens/profile_screen.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/screens/celebrity_selection_screen.dart';
import 'package:betabeta/screens/face_selection_screen.dart';
import 'package:betabeta/services/networking.dart';
import 'package:betabeta/widgets/advance_filter_card_widget.dart';
import 'package:betabeta/widgets/circular_user_avatar.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tuple/tuple.dart';

enum activeCard { customImage, celebImage, normalMode }

class VoilaPage extends StatefulWidget {
  static const String routeName = '/voila_page';

  @override
  State<VoilaPage> createState() => _VoilaPageState();
}

class _VoilaPageState extends State<VoilaPage> {
  Celeb _selectedCeleb = Celeb(
      celebName: SettingsData.instance.celebId,
      imagesUrls: [
        SettingsData.instance.filterDisplayImageUrl
      ]); //TODO support Celeb fetching from SettingsData
  int _chosenAuditionCount = SettingsData.instance.auditionCount;

  bool customImageExists =
      SettingsData.instance.filterDisplayImageUrl != null &&
          SettingsData.instance.filterDisplayImageUrl.length > 0;
  bool isLoading = false;
  bool isPressed = false;
  ImageType? currentChoice;
  String flagName = 'Normal mode';

  activeCard selectedCard = activeCard.normalMode;

  /// Here is where the custom-picked image is being Posted and sent over Network.
  void postCustomImageToNetwork(PickedFile chosenImage) async {
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

  String getCardName() {
    if (currentChoice == activeCard.celebImage) {
      return 'Celeb mode';
    } else if (currentChoice == activeCard.customImage) {
      return 'Image mode';
    } else {
      return 'Normal mode';
    }
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
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: MediaQuery.of(context).padding,
        child: Column(
          children: [
            CustomAppBar(
              titleTextColor: Colors.black,
              customTitle: Container(
                padding: EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(ProfileScreen.routeName);
                        },
                        child: CircularUserAvatar(
                          backgroundColor: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              centerWidget: Center(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Image.asset(
                      'assets/images/flag2.png',
                      height: 45,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        flagName,
                        style: titleStyleWhite.copyWith(shadows: [Shadow()]),
                      ),
                    )
                  ],
                ),
              ),
              showAppLogo: false,
              hasBackButton: false,
              trailing: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  child: Icon(
                    FontAwesomeIcons.slidersH,
                    size: 25,
                    color: Colors.black87,
                  ),
                  onTap: () {},
                ),
              ),
            ),
            Container(
              child: Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Voilà Features',
                              style: boldTextStyle,
                            ),
                            AnimatedContainer(
                              width: selectedCard != activeCard.normalMode
                                  ? 200
                                  : 0,
                              duration: Duration(milliseconds: 500),
                              child: SizedBox(
                                width: 100,
                                height: 40,
                                child: RoundedButton(
                                  elevation: 4,
                                  name: 'Deactivate filters',
                                  onTap: () {
                                    setState(() {
                                      selectedCard = activeCard.normalMode;
                                      flagName = 'Normal mode';
                                    });
                                  },
                                  withPadding: false,
                                  color: Colors.red[800],
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider(
                          color: lightCardColor,
                          thickness: 2.0,
                          indent: 24.0,
                          endIndent: 24.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: AdvanceFilterCard(
                                  isActive:
                                      selectedCard == activeCard.customImage
                                          ? true
                                          : false,
                                  image:
                                      AssetImage('assets/images/picture5.jpg'),
                                  title: Text(
                                    'Custom Image',
                                    style: titleStyleWhite,
                                  ),
                                  onTap: () async {
                                    // Direct user to the custom Selection Page.
                                    // await Navigator.pushNamed(context,
                                    //     ImageSourceSelectionScreen.routeName);
                                    // setState(() { //Make flutter rebuild the widget, as the image might have changed

                                    // });

                                    // Display an image picker Dilaogue.
                                    setState(() {
                                      currentChoice = ImageType.Custom;
                                      flagName = 'Image mode';
                                    });
                                    await GlobalWidgets.showImagePickerDialogue(
                                      context: context,
                                      onImagePicked: (imageFile) async {
                                        if (imageFile != null) {
                                          postCustomImageToNetwork(imageFile);
                                          setState(() {
                                            selectedCard =
                                                activeCard.customImage;
                                          });
                                        }
                                      },
                                    );
                                  },
                                  info: 'Discover picture \nlook-a-likes.'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: AdvanceFilterCard(
                                  image: AssetImage('assets/images/celeb3.jpg'),
                                  isActive:
                                      selectedCard == activeCard.celebImage
                                          ? true
                                          : false,
                                  onTap: () async {
                                    var selectedCeleb = await Get.toNamed(
                                        ScreenCelebritySelection.routeName);
                                    setState(() {
                                      currentChoice = ImageType.Celeb;
                                      // Set the `_selectedCeleb` variable to the newly selected
                                      // celebrity from the [CelebritySelectionScreen] page given that it is not null.
                                      if (selectedCeleb != null) {
                                        _selectedCeleb = selectedCeleb as Celeb;
                                        SettingsData.instance.celebId =
                                            _selectedCeleb.celebName;
                                        selectedCard = activeCard.celebImage;
                                        flagName = 'Celeb Mode';
                                      } else {
                                        //No celebrity selected
                                      }
                                    });
                                  },
                                  title: Text(
                                    'Celeb Filter',
                                    style: titleStyleWhite,
                                  ),
                                  info: 'Discover celebrity \nlook-a-likes.'),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AdvanceFilterCard(
                            onTap: () {
                              inDevelopmentPopUp();
                            },
                            image: AssetImage('assets/images/textsearch.jpg'),
                            comingSoon: true,
                            showAI: false,
                            title: Row(
                              children: [
                                Text(
                                  'Text Search',
                                  style: LargeTitleStyleWhite,
                                ),
                                DefaultTextStyle(
                                  style: LargeTitleStyle,
                                  child: AnimatedTextKit(
                                    pause: Duration(seconds: 2),
                                    repeatForever: true,
                                    animatedTexts: [
                                      TyperAnimatedText(
                                        '   Dog lover?...',
                                        speed: Duration(milliseconds: 100),
                                      ),
                                      TyperAnimatedText(
                                        '   Vegan?...',
                                        speed: Duration(milliseconds: 100),
                                      ),
                                      TyperAnimatedText(
                                        '   Outdoors?...',
                                        speed: Duration(milliseconds: 100),
                                      ),
                                      TyperAnimatedText(
                                        '   Sushi?...',
                                        speed: Duration(milliseconds: 100),
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
                                  onTap: () {
                                    inDevelopmentPopUp();
                                  },
                                  comingSoon: true,
                                  image: AssetImage('assets/images/taste5.jpg'),
                                  title: Text(
                                    'Your Taste',
                                    style: titleStyleWhite,
                                  ),
                                  info: 'Show me people \nwho are my taste'),
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
                                  image: AssetImage('assets/images/taste9.jpg'),
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
  }
}
