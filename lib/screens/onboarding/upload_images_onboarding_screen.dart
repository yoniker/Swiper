import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/onboarding_flow_controller.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/images_upload_widget.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadImagesOnboardingScreen extends StatefulWidget {
  static const String routeName = '/uploadPicturesScreen';

  const UploadImagesOnboardingScreen({Key? key}) : super(key: key);

  @override
  _UploadImagesOnboardingScreenState createState() =>
      _UploadImagesOnboardingScreenState();
}

class _UploadImagesOnboardingScreenState
    extends State<UploadImagesOnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.75,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ProgressBar(
                        totalProgressBarPages: kTotalProgressBarPages,
                        page: 8,
                      ),
                      const Text(
                        'Add photos of yourself',
                        style: kTitleStyle,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Let\'s start with your first photos. Add at least one photo. You can change and add more later.',
                        style: kSmallInfoStyle,
                        maxLines: 3,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: ImagesUploadwidget(),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      // RoundedButton(
                      //     name: 'Add from Facebook',
                      //     icon: Icons.facebook,
                      //     color: const Color(0xFF0060DB),
                      //     onTap: null) //TODO add option to upload from facebook
                    ],
                  ),
                ),
              ),
              ListenerWidget(
                notifier: SettingsData.instance,
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => CupertinoAlertDialog(
                          title: Text('Please add a profile picture'),
                          content: Text(
                              'At least one picture of yourself is required in order to set up your profile.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Close',
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    child: RoundedButton(
                      name: 'NEXT',
                      onTap: SettingsData.instance.profileImagesUrls.length != 0
                          ? () {
                              Get.offAllNamed(OnboardingFlowController.instance
                                  .nextRoute(
                                      UploadImagesOnboardingScreen.routeName));
                            }
                          : null,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
