import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/data_models/celeb.dart';
import 'package:betabeta/screens/profile_screen.dart';
import 'package:betabeta/screens/swipe_settings_screen.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/screens/celebrity_selection_screen.dart';
import 'package:betabeta/screens/face_selection_screen.dart';
import 'package:betabeta/services/networking.dart';
import 'package:betabeta/widgets/advance_filter_card_widget.dart';
import 'package:betabeta/widgets/circular_user_avatar.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/gradient_text_widget.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tuple/tuple.dart';

class VoilaPage extends StatefulWidget {
  static const String routeName = '/voila_page';

  @override
  State<VoilaPage> createState() => _VoilaPageState();
}

class _VoilaPageState extends State<VoilaPage> {
  bool isLoading = false;
  bool isPressed = false;

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
  Widget build(BuildContext context){


  return ListenerWidget(notifier: SettingsData.instance, builder: (BuildContext context) {
    bool customImageExists = SettingsData.instance.filterDisplayImageUrl.length > 0;
    Celeb _selectedCeleb = Celeb(
        celebName: SettingsData.instance.celebId,
        imagesUrls: [
          SettingsData.instance.filterDisplayImageUrl
        ]);
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (customImageExists)
                      CircularUserAvatar(imageProvider:NetworkImage(SettingsData.instance.filterDisplayImageUrl),),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GradientText(
                        'Voilà-dating',
                        style: TextStyle(
                            overflow: TextOverflow.fade,
                            color: goldColorish,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        gradient: LinearGradient(colors: [
                          Color(0XFFFBCE32),
                          Color(0XFFD2AB54),
                          Color(0XFFC3932F),
                        ]),
                      ),
                    ),
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
                  onTap: () async {
                    var value =
                        await Get.toNamed(SwipeSettingsScreen.routeName);
                  },
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
                              width: SettingsData.instance.filterType != FilterType.NONE
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
                                      SettingsData.instance.filterType = FilterType.NONE;
                                      SettingsData.instance.filterDisplayImageUrl = '';
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
                                  isActive: SettingsData.instance.filterType == FilterType.CUSTOM_IMAGE,
                                  image:
                                      AssetImage('assets/images/picture5.jpg'),
                                  title: Text(
                                    FilterType.CUSTOM_IMAGE.description,
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
                                      SettingsData.instance.filterType= FilterType.CUSTOM_IMAGE;
                                    });
                                    await GlobalWidgets.showImagePickerDialogue(
                                      context: context,
                                      onImagePicked: (imageFile) async {
                                        if (imageFile != null) {
                                          postCustomImageToNetwork(imageFile);

                                            SettingsData.instance.filterType = FilterType.CUSTOM_IMAGE;
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
                                  isActive: SettingsData.instance.filterType == FilterType.CELEB_IMAGE,
                                  onTap: () async {
                                    var selectedCeleb = await Get.toNamed(
                                        ScreenCelebritySelection.routeName);
                                      SettingsData.instance.filterType = FilterType.CELEB_IMAGE;
                                      // Set the `_selectedCeleb` variable to the newly selected
                                      // celebrity from the [CelebritySelectionScreen] page given that it is not null.
                                      if (selectedCeleb != null) {
                                        _selectedCeleb = selectedCeleb as Celeb;
                                        SettingsData.instance.celebId =
                                            _selectedCeleb.celebName;
                                        SettingsData.instance.filterType = FilterType.CELEB_IMAGE;
                                        if(_selectedCeleb.imagesUrls!=null && _selectedCeleb.imagesUrls!.length>0)
                                          {
                                          SettingsData.instance.filterDisplayImageUrl = NetworkHelper.serverCelebImageUrl(_selectedCeleb.imagesUrls![0]);
                                          }
                                        else {
                                          SettingsData.instance.filterDisplayImageUrl = '';
                                        }
                                        
                                      }
                                      else {
                                        SettingsData.instance.filterDisplayImageUrl = '';
                                        SettingsData.instance.celebId = '';
                                        SettingsData.instance.filterType = FilterType.NONE;
                                        //No celebrity selected
                                      }

                                  },
                                  title: Text(
                                    FilterType.CELEB_IMAGE.description,
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
                            image: AssetImage('assets/images/textsearch2.jpg'),
                            comingSoon: true,
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
                                  image: AssetImage('assets/images/taste2.jpg'),
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
  });}
}
