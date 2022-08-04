import 'package:betabeta/constants/assets_paths.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/location_service.dart';
import 'package:betabeta/widgets/onboarding/onboarding_column.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:betabeta/widgets/onboarding/text_button.dart';
import 'package:flutter/material.dart';

class LocationPermissionScreen extends StatefulWidget {
  static const String routeName = '/location_permission_screen';
  final void Function()? onNext;

  const LocationPermissionScreen({Key? key, this.onNext}) : super(key: key);

  @override
  _LocationPermissionScreenState createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  Future<void> enableLocation() async {
    var status = await LocationService.instance.requestLocationCapability();
    if (status == LocationServiceStatus.enabled) {
      LocationService.instance.onInit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackroundThemeColor,
      resizeToAvoidBottomInset: false,
      body: OnboardingColumn(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                height: 160,
                child: Image.asset(AssetsPaths.locationGif),
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
          Column(
            children: [
              RoundedButton(
                color: Colors.white,
                name: 'Enable location',
                onTap: () async {
                  await enableLocation();
                  widget.onNext?.call();
                },
              ),
              const SizedBox(height: 20),
              TextButtonOnly(
                label: 'Not now',
                onClick: () {
                  print('clicked');
                  widget.onNext?.call();
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
