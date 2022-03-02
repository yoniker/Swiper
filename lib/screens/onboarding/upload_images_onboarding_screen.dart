import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/onboarding/onboarding_flow_controller.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/images_upload_widget.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/onboarding/onboarding_column.dart';
import 'package:betabeta/widgets/onboarding/profile_image_widget.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderables/reorderables.dart';

class UploadImagesOnboardingScreen extends StatefulWidget {
  static const String routeName = '/uploadPicturesScreen';

  const UploadImagesOnboardingScreen({Key? key}) : super(key: key);

  @override
  _UploadImagesOnboardingScreenState createState() =>
      _UploadImagesOnboardingScreenState();
}

class _UploadImagesOnboardingScreenState
    extends State<UploadImagesOnboardingScreen> {
  String imageUrl = '';
  String imageUrl2 = '';

  void getFilePath(PickedFile? imagePicked) {
    if (imagePicked == null) {
      return;
    }
    if (imageUrl.isEmpty) {
      imageUrl = imagePicked.path;
    } else {
      imageUrl2 = imagePicked.path;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: OnboardingColumn(
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
                Center(
                  child: ImagesUploadwidget(),
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
                Get.offAllNamed(OnboardingFlowController.nextRoute(
                    UploadImagesOnboardingScreen.routeName));
              },
            )
          ],
        ),
      ),
    );
  }
}
