import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/onboarding/onboarding_flow_controller.dart';
import 'package:betabeta/services/location_service.dart';
import 'package:betabeta/widgets/onboarding/onboarding_column.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:betabeta/widgets/onboarding/text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationPermissionScreen extends StatefulWidget {
  static const String routeName = '/location_permission_screen';

  const LocationPermissionScreen({Key? key}) : super(key: key);

  @override
  _LocationPermissionScreenState createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  void enableLocation() async {
    var status = await LocationService.requestLocationCapability();
    if (status == LocationServiceStatus.enabled) {
      LocationService.instance.onInit();
      Get.offAllNamed(OnboardingFlowController.nextRoute(
          LocationPermissionScreen.routeName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: OnboardingColumn(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 160,
                  child: Image.asset('assets/onboarding/images/location.gif'),
                ),
                const Text(
                  'Enable location',
                  style: kTitleStyle,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enable location to see potential \nmatches within your area.',
                  style: kSmallInfoStyle,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          Column(
            children: [
              RoundedButton(
                color: Colors.white,
                name: 'Enable location',
                onTap: () {
                  enableLocation();
                },
              ),
              const SizedBox(height: 20),
              TextButtonOnly(
                label: 'Not now',
                onClick: () {
                  showDialog(
                      context: context,
                      builder: (_) => CupertinoAlertDialog(
                            title: Text(
                              "In order to see other users, Location services must be used.",
                            ),
                            content: Text('Please activate Location services.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  enableLocation();
                                },
                                child: Text(
                                  'Enable location',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              )
                            ],
                          ));
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
