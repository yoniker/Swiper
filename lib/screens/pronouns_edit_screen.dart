import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/screen_size.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/onboarding/choice_button.dart';
import 'package:betabeta/widgets/onboarding/conditional_parent_widget.dart';
import 'package:betabeta/widgets/onboarding/input_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Gender { male, female, other }

class PronounsEditScreen extends StatefulWidget {
  static const String routeName = '/pronouns_edit_screen';
  const PronounsEditScreen({Key? key}) : super(key: key);

  @override
  _PronounsEditScreenState createState() => _PronounsEditScreenState();
}

class _PronounsEditScreenState extends State<PronounsEditScreen> {
  bool? _openOtherGender = false;
  String? elseGender; //TODO save it to SettingsData

  void UnFocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    //height (with SafeArea)
    double height = MediaQuery.of(context).size.height;
    // Height (without SafeArea)
    var padding = MediaQuery.of(context).viewPadding;
    double heightWithoutSafeArea = height - padding.top - padding.bottom;

    return ListenerWidget(
        notifier: SettingsData.instance,
        builder: (context) {
          return Scaffold(
            backgroundColor: backgroundThemeColor,
            appBar: CustomAppBar(
              hasTopPadding: true,
              hasBackButton: true,
              showAppLogo: false,
              title: 'My gender',
            ),
            body: SafeArea(
              child: RawScrollbar(
                isAlwaysShown: true,
                thumbColor: Colors.black54,
                thickness: 5,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    height: heightWithoutSafeArea - 38,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                            SettingsData.instance.userGender =
                                                Gender.female.name;
                                          });
                                        },
                                        pressed:
                                            SettingsData.instance.userGender ==
                                                Gender.female.name),
                                    const SizedBox(height: 20),
                                    ChoiceButton(
                                        name: 'Man',
                                        onTap: () {
                                          UnFocus();
                                          SettingsData.instance.userGender =
                                              Gender.male.name;
                                        },
                                        pressed:
                                            SettingsData.instance.userGender ==
                                                Gender.male.name),
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
                                        _openOtherGender == false
                                            ? _openOtherGender = true
                                            : _openOtherGender = false;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'More options',
                                          style: kButtonText,
                                        ),
                                        const SizedBox(width: 5),
                                        Icon(
                                          _openOtherGender == false
                                              ? FontAwesomeIcons.chevronDown
                                              : FontAwesomeIcons.chevronUp,
                                          color: kIconColor,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 100),
                                height: _openOtherGender == false ? 0 : 63,
                                child: SingleChildScrollView(
                                  child: InputField(
                                      onTap: () {
                                        SettingsData.instance.userGender =
                                            Gender.other.name;
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
                                        SettingsData.instance.userGender =
                                            Gender.other.name;
                                      },
                                      pressed:
                                          SettingsData.instance.userGender ==
                                              Gender.other.name),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Theme(
                                data: ThemeData(
                                    unselectedWidgetColor: Colors.black87),
                                child: CheckboxListTile(
                                    title: const Text(
                                      'Show my gender on my profile',
                                      style: boldTextStyle,
                                    ),
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    checkColor: Colors.white,
                                    activeColor: Colors.black87,
                                    tristate: false,
                                    value: SettingsData.instance.showUserGender,
                                    onChanged: (value) {
                                      if (value != null) {
                                        SettingsData.instance.showUserGender =
                                            value;
                                      }
                                    }),
                              ),
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
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
