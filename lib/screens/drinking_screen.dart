import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/services/screen_size.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/onboarding/choice_button.dart';
import 'package:betabeta/widgets/onboarding/conditional_parent_widget.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';

enum Drinking { Frequently, Socially, Never }

class DrinkingScreen extends StatefulWidget {
  static const String routeName = '/drinking_screen';
  const DrinkingScreen({Key? key}) : super(key: key);

  @override
  _DrinkingScreen createState() => _DrinkingScreen();
}

class _DrinkingScreen extends State<DrinkingScreen> {
  String? drinkingLevel;

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
              title: 'Drinking',
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
                                      'Do you smoke?',
                                      style: titleStyle,
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    ChoiceButton(
                                        name: 'Frequently',
                                        onTap: () {
                                          setState(() {
                                            UnFocus();
                                            drinkingLevel !=
                                                    Drinking.Frequently.name
                                                ? drinkingLevel =
                                                    Drinking.Frequently.name
                                                : drinkingLevel = null;
                                          });
                                        },
                                        pressed: drinkingLevel ==
                                            Drinking.Frequently.name),
                                    const SizedBox(height: 20),
                                    ChoiceButton(
                                        name: 'Socially',
                                        onTap: () {
                                          setState(() {
                                            UnFocus();
                                            drinkingLevel !=
                                                    Drinking.Socially.name
                                                ? drinkingLevel =
                                                    Drinking.Socially.name
                                                : drinkingLevel = null;
                                          });
                                        },
                                        pressed: drinkingLevel ==
                                            Drinking.Socially.name),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ChoiceButton(
                                      name: 'Never',
                                      onTap: () {
                                        setState(() {
                                          UnFocus();
                                          drinkingLevel != Drinking.Never.name
                                              ? drinkingLevel =
                                                  Drinking.Never.name
                                              : drinkingLevel = null;
                                        });
                                      },
                                      pressed:
                                          drinkingLevel == Drinking.Never.name,
                                    )
                                  ],
                                ),
                              ),
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
