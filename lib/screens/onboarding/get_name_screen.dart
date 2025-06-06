import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/onboarding/input_field.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';

class GetNameScreen extends StatefulWidget {
  static const String routeName = '/get_name';
  final void Function()? onNext;
  GetNameScreen({this.onNext});

  @override
  _GetNameScreenState createState() => _GetNameScreenState();
}

class _GetNameScreenState extends State<GetNameScreen> {
  String userName = SettingsData.instance.name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackroundThemeColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FittedBox(
                    child: Text(
                      "What's your first name?",
                      style: kTitleStyle,
                    ),
                  ),
                  const SizedBox(height: 30),
                  InputField(
                    initialvalue: userName,
                    onTapIcon: () {
                      SettingsData.instance.name = userName;
                      widget.onNext?.call();
                    },
                    icon: userName.length == 0 ? null : Icons.send,
                    hintText: ' Enter your first name here.',
                    onType: (value) {
                      setState(() {
                        userName = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Icon(Icons.remove_red_eye_rounded, color: Colors.black54),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'This will be shown on your profile.',
                          style: kSmallInfoStyle,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              RoundedButton(
                name: 'NEXT',
                onTap: userName.isEmpty
                    ? null
                    : () {
                        SettingsData.instance.name = userName;
                        widget.onNext?.call();
                      },
              )
            ],
          ),
        ),
      ),
    );
  }
}
