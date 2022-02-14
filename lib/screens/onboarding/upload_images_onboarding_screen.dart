import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/onboarding/finish_onboarding_screen.dart';
import 'package:betabeta/screens/onboarding/onboarding_flow_controller.dart';
import 'package:betabeta/widgets/onboarding/onboarding_column.dart';
import 'package:betabeta/widgets/onboarding/profile_image_widget.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class UploadImagesOnboardingScreen extends StatefulWidget {
  static const String routeName = '/uploadPicturesScreen';

  const UploadImagesOnboardingScreen({Key? key}) : super(key: key);

  @override
  _UploadImagesOnboardingScreenState createState() => _UploadImagesOnboardingScreenState();
}

class _UploadImagesOnboardingScreenState extends State<UploadImagesOnboardingScreen> {
  String imageUrl = '';
  String imageUrl2 = '';

  void getFilePath(PickedFile? imagePicked) {
    if(imagePicked==null){return;}
    if (imageUrl.isEmpty) {
      imageUrl = imagePicked.path;
    } else {
      imageUrl2 = imagePicked.path;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: OnboardingColumn(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                ProgressBar(
                  page: 8,
                ),
                const Text(
                  'Add two photos of yourself',
                  style: kTitleStyle,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                    'Let\'s start with your first photos. You can change and add more later.',
                    style: kSmallInfoStyle),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ProfileImageWidget(
                      /// This is set to save pictures locally for now instead of online
                      loadingImage: false,
                      onImagePicked: getFilePath,
                      imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
                      onDelete: () {
                        setState(() {
                          imageUrl = '';
                        });
                      },
                    ),
                    ProfileImageWidget(
                      /// This is set to save pictures locally for now instead of online
                      loadingImage: false,
                      onImagePicked: getFilePath,
                      imageUrl: imageUrl2.isNotEmpty ? imageUrl2 : null,
                      onDelete: () {
                        setState(() {
                          imageUrl2 = '';
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                RoundedButton(
                    name: 'Add from Facebook',
                    icon: Icons.facebook,
                    color: const Color(0xFF0060DB),
                    onTap: () {})
              ],
            ),
            RoundedButton(
              name: 'NEXT',
              onTap: () {
                Get.offAllNamed(OnboardingFlowController.nextRoute(UploadImagesOnboardingScreen.routeName));
              },
            )
          ],
        ),
      ),
    );
  }
}
