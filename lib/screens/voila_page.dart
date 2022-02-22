import 'dart:io';

import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/data_models/celeb.dart';
import 'package:betabeta/screens/profile_screen.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/screens/celebrity_selection_screen.dart';
import 'package:betabeta/screens/face_selection_screen.dart';
import 'package:betabeta/services/networking.dart';
import 'package:betabeta/widgets/advance_filter_card_widget.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/onboarding/choice_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tuple/tuple.dart';

import 'advanced_settings_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      onTap: (){
                        Get.toNamed(ProfileScreen.routeName);
                      },
                      child: ProfileImageAvatar.network(
                          backgroundColor: Colors.grey,
                          url:
                              'https://d2qp0siotla746.cloudfront.net/img/use-cases/profile-picture/template_3.jpg'),
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
                      Text(
                        'Voilà Features',
                        style: boldTextStyle,
                      ),
                      Text('Explore...'),
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
                                image: AssetImage('assets/images/custom1.jpg'),
                                title: 'Custom Image',
                                onTap: () async {
                                  // Direct user to the custom Selection Page.
                                  // await Navigator.pushNamed(context,
                                  //     ImageSourceSelectionScreen.routeName);
                                  // setState(() { //Make flutter rebuild the widget, as the image might have changed

                                  // });

                                  // Display an image picker Dilaogue.
                                  setState(() {
                                    currentChoice = ImageType.Custom;
                                  });
                                  await GlobalWidgets.showImagePickerDialogue(
                                    context: context,
                                    onImagePicked: (imageFile) async {
                                      if (imageFile != null) {
                                        postCustomImageToNetwork(imageFile);
                                      }
                                    },
                                  );
                                },
                                info:
                                    'Search for people who\nlook similar to anyone you choose.'),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: AdvanceFilterCard(
                                image: AssetImage('assets/images/celeb3.jpg'),
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
                                    } else {
                                      //No celebrity selected
                                    }
                                  });
                                },
                                title: 'Celeb Filter',
                                info:
                                    'Search for people who\nlook similar to a celebrity of your choice.'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      AdvanceFilterCard(
                          image: AssetImage('assets/images/bar3.jpg'),
                          title: 'Local Bar. ',
                          info:
                              'Join the local bar and meet people around you!'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
