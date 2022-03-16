import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/services/screen_size.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/onboarding/choice_button.dart';
import 'package:betabeta/widgets/onboarding/conditional_parent_widget.dart';
import 'package:flutter/material.dart';

enum Fitness { Active, Occasionally, Never }

class FitnessScreen extends StatefulWidget {
  static const String routeName = '/fitness_screen';
  const FitnessScreen({Key? key}) : super(key: key);

  @override
  _FitnessScreen createState() => _FitnessScreen();
}

class _FitnessScreen extends State<FitnessScreen> {
  String? fitLevel;

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
              title: 'Fitness',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'How active are you?',
                                      style: titleStyle,
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    ChoiceButton(
                                        name: 'Active',
                                        onTap: () {
                                          setState(() {
                                            UnFocus();
                                            fitLevel != Fitness.Active.name
                                                ? fitLevel = Fitness.Active.name
                                                : fitLevel = null;
                                          });
                                        },
                                        pressed:
                                            fitLevel == Fitness.Active.name),
                                    const SizedBox(height: 20),
                                    ChoiceButton(
                                        name: 'Occasionally',
                                        onTap: () {
                                          setState(() {
                                            UnFocus();
                                            fitLevel !=
                                                    Fitness.Occasionally.name
                                                ? fitLevel =
                                                    Fitness.Occasionally.name
                                                : fitLevel = null;
                                          });
                                        },
                                        pressed: fitLevel ==
                                            Fitness.Occasionally.name),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ChoiceButton(
                                      name: 'Never',
                                      onTap: () {
                                        setState(() {
                                          UnFocus();
                                          fitLevel != Fitness.Never.name
                                              ? fitLevel = Fitness.Never.name
                                              : fitLevel = null;
                                        });
                                      },
                                      pressed: fitLevel == Fitness.Never.name,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
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
