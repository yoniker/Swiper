import 'package:betabeta/screens/onboarding/welcome_screen.dart';
import 'package:flutter/material.dart';

class OnboardingPageView extends StatefulWidget {
  const OnboardingPageView({Key? key}) : super(key: key);

  @override
  State<OnboardingPageView> createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends State<OnboardingPageView> {
  List<Widget> pages = <Widget>[WelcomeScreen()];
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
