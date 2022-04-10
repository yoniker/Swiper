import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/services/onboarding_flow_controller.dart';
import 'package:betabeta/services/screen_size.dart';
import 'package:betabeta/widgets/onboarding/choice_button.dart';
import 'package:betabeta/widgets/onboarding/conditional_parent_widget.dart';
import 'package:betabeta/widgets/onboarding/input_field.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class PronounScreen extends StatefulWidget {
  static const String routeName = '/pronounScreen';

  const PronounScreen({Key? key}) : super(key: key);

  @override
  _PronounScreenState createState() => _PronounScreenState();
}

class _PronounScreenState extends State<PronounScreen> {
  Gender? selectedGender;
  bool? _checked = false;
  bool _showGender = true;
  String? elseGender;

  void UnFocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void saveSelectedGender() {
    if (selectedGender == null ||
        (selectedGender == Gender.other && elseGender == null)) {
      return;
    }
    SettingsData.instance.showUserGender = _showGender;
    if (selectedGender != Gender.other) {
      SettingsData.instance.userGender = selectedGender!.name;
    } else {
      SettingsData.instance.userGender = elseGender!;
    }
  }

  @override
  Widget build(BuildContext context) {
    //height (with SafeArea)
    double height = MediaQuery.of(context).size.height;
    // Height (without SafeArea)
    var padding = MediaQuery.of(context).viewPadding;
    double heightWithoutSafeArea = height - padding.top - padding.bottom;

    return Scaffold(
      backgroundColor: kBackroundThemeColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: RawScrollbar(
          isAlwaysShown: true,
          thumbColor: Colors.black54,
          thickness: 5,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              height: heightWithoutSafeArea,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: ProgressBar(
                            page: 3,
                          ),
                        ),
                        const Text('How do you identify?', style: kTitleStyle),
                        const SizedBox(height: 10),
                        const Text('We welcome everyone on Voilà!',
                            style: kSmallInfoStyle),
                        const SizedBox(height: 30),
                        ConditionalParentWidget(
                          condition: ScreenSize.getSize(context) ==
                              ScreenSizeCategory.small,
                          conditionalBuilder: (Widget child) => FittedBox(
                            child: child,
                          ),
                          child: Column(
                            children: [
                              ChoiceButton(
                                name: 'Woman',
                                onTap: () {
                                  UnFocus();
                                  setState(() {
                                    selectedGender = Gender.female;
                                  });
                                },
                                pressed: selectedGender == Gender.female
                                    ? true
                                    : false,
                              ),
                              const SizedBox(height: 20),
                              ChoiceButton(
                                name: 'Man',
                                onTap: () {
                                  UnFocus();
                                  setState(() {
                                    selectedGender = Gender.male;
                                  });
                                },
                                pressed: selectedGender == Gender.male
                                    ? true
                                    : false,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: TextButton(
                              onPressed: () {
                                UnFocus();
                                setState(() {
                                  _checked == false
                                      ? _checked = true
                                      : _checked = false;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Other',
                                    style: kButtonText,
                                  ),
                                  const SizedBox(width: 5),
                                  AnimatedRotation(
                                    curve: Curves.fastOutSlowIn,
                                    turns: _checked == true ? -0.5 : 0,
                                    duration: Duration(milliseconds: 400),
                                    child: Icon(
                                      FontAwesomeIcons.chevronDown,
                                      color: kIconColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          height: _checked == false ? 0 : 63,
                          child: SingleChildScrollView(
                            child: InputField(
                              onTap: () {
                                setState(() {
                                  selectedGender = Gender.other;
                                });
                              },
                              maxCharacters: 20,
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 20),
                              hintText: 'For other gender type here',
                              onType: (value) {
                                setState(() {
                                  value.isEmpty
                                      ? elseGender = null
                                      : elseGender = value;
                                });
                              },
                              onTapIcon: () {
                                setState(() {
                                  selectedGender = Gender.other;
                                });
                              },
                              pressed:
                                  selectedGender == Gender.other ? true : false,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Theme(
                          data:
                              ThemeData(unselectedWidgetColor: Colors.black87),
                          child: CheckboxListTile(
                              title: const Text(
                                'Show my gender on my profile',
                                style: kSmallInfoStyle,
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                              checkColor: Colors.white,
                              activeColor: Colors.black87,
                              tristate: false,
                              value: _showGender,
                              onChanged: (value) {
                                setState(() {
                                  _showGender = value!;
                                });
                              }),
                        ),
                        RoundedButton(
                            name: 'CONTINUE',
                            onTap: selectedGender == null ||
                                    selectedGender == Gender.other &&
                                        elseGender == null
                                ? null
                                : () {
                                    saveSelectedGender();
                                    Get.offAllNamed(OnboardingFlowController
                                        .instance
                                        .nextRoute(PronounScreen.routeName));
                                  })
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
