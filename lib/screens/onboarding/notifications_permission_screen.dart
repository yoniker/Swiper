import 'dart:io';

import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/notifications_controller.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';

class NotificationsPermissionScreen extends StatefulWidget {
  static const String routeName = '/notifications_permission';
  final void Function()? onNext;
  NotificationsPermissionScreen({Key? key, this.onNext});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<NotificationsPermissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackroundThemeColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(
                child: Column(
                  children: [
                    SizedBox(
                      height: 140,
                      child:
                          Image.asset('assets/onboarding/images/pushnote.gif'),
                    ),
                    Text(
                      'Enable notifications',
                      style: kTitleStyle,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Enable notifications so you will know when \nyou get new matches and messages.',
                      style: kSmallInfoStyle,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  RoundedButton(
                    name: 'Enable notifications',
                    onTap: () async {
                      if (Platform.isIOS) {
                        var result = await NotificationsController.instance
                            .requestIOSPermissions();
                        print(
                            'RESULT OF GETTING NOTIFICATIONS PERMISSIONS IS $result');
                      }
                      widget.onNext?.call();
                    },
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      //TODO user refused notifications,save if needed
                      widget.onNext?.call();
                    },
                    child: Text(
                      'Not now',
                      textAlign: TextAlign.center,
                      style: kButtonText,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
