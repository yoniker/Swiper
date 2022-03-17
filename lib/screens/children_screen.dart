import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/services/screen_size.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/onboarding/choice_button.dart';
import 'package:betabeta/widgets/onboarding/conditional_parent_widget.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';

enum kids { NoKids, HaveKids, WantSomeday, DontWant, NotSure }

class KidsScreen extends StatefulWidget {
  static const String routeName = '/kids_screen';
  const KidsScreen({Key? key}) : super(key: key);

  @override
  _KidsScreen createState() => _KidsScreen();
}

class _KidsScreen extends State<KidsScreen> {
  String? kidsChoice;

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
              title: 'Children',
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
                      padding: const EdgeInsets.all(20),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Do you have plans for children?',
                                      style: titleStyle,
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    ChoiceButton(
                                        name: 'Have & no more',
                                        onTap: () {
                                          setState(() {
                                            UnFocus();
                                            kidsChoice != kids.NoKids.name
                                                ? kidsChoice = kids.NoKids.name
                                                : kidsChoice = null;
                                          });
                                        },
                                        pressed:
                                            kidsChoice == kids.NoKids.name),
                                    const SizedBox(height: 20),
                                    ChoiceButton(
                                        name: 'Have & want more',
                                        onTap: () {
                                          setState(() {
                                            UnFocus();
                                            kidsChoice != kids.HaveKids.name
                                                ? kidsChoice =
                                                    kids.HaveKids.name
                                                : kidsChoice = null;
                                          });
                                        },
                                        pressed:
                                            kidsChoice == kids.HaveKids.name),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ChoiceButton(
                                      name: 'Want someday',
                                      onTap: () {
                                        setState(() {
                                          UnFocus();
                                          kidsChoice != kids.WantSomeday.name
                                              ? kidsChoice =
                                                  kids.WantSomeday.name
                                              : kidsChoice = null;
                                        });
                                      },
                                      pressed:
                                          kidsChoice == kids.WantSomeday.name,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ChoiceButton(
                                      name: "Don't want",
                                      onTap: () {
                                        setState(() {
                                          UnFocus();
                                          kidsChoice != kids.DontWant.name
                                              ? kidsChoice = kids.DontWant.name
                                              : kidsChoice = null;
                                        });
                                      },
                                      pressed: kidsChoice == kids.DontWant.name,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ChoiceButton(
                                      name: 'Not sure',
                                      onTap: () {
                                        setState(() {
                                          UnFocus();
                                          kidsChoice != kids.NotSure.name
                                              ? kidsChoice = kids.NotSure.name
                                              : kidsChoice = null;
                                        });
                                      },
                                      pressed: kidsChoice == kids.NotSure.name,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                          RoundedButton(
                              name: 'Save',
                              onTap: () {
                                Navigator.pop(context);
                              })
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
