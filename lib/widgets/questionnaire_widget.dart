import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/screen_size.dart';
import 'package:betabeta/widgets/onboarding/choice_button.dart';
import 'package:betabeta/widgets/onboarding/conditional_parent_widget.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionnaireWidget extends StatefulWidget {
  QuestionnaireWidget(
      {required this.choices,
      this.initialChoice,
      this.onValueChanged,
      this.onSave,
      this.headline,
      this.promotes,
      this.alwaysPressed = false});
  final List<String> choices;
  final String? headline;
  final void Function(String)? onValueChanged;
  final void Function()? onSave;
  final bool alwaysPressed;
  final String? initialChoice;

  final List<String>? promotes;

  @override
  State<QuestionnaireWidget> createState() => _QuestionnaireWidgetState();
}

class _QuestionnaireWidgetState extends State<QuestionnaireWidget> {
  String? currentUserChoice;
  String promote = '';

  @override
  void initState() {
    currentUserChoice = widget.initialChoice;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //height (with SafeArea)
    double height = MediaQuery.of(context).size.height;
    // Height (without SafeArea)
    var padding = MediaQuery.of(context).viewPadding;
    double heightWithoutSafeArea = height - padding.top - padding.bottom;

    return SafeArea(
      child: ConditionalParentWidget(
        condition: ScreenSize.getSize(context) == ScreenSizeCategory.small,
        conditionalBuilder: (Widget child) => RawScrollbar(
          isAlwaysShown: true,
          thumbColor: Colors.black54,
          thickness: 5,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              height: height * 0.92,
              child: child,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConditionalParentWidget(
                condition:
                    ScreenSize.getSize(context) == ScreenSizeCategory.small,
                conditionalBuilder: (Widget child) => FittedBox(
                  child: child,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.headline != null)
                      Text(
                        widget.headline!,
                        style: titleStyle,
                      ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: widget.choices
                          .map((choiceTitle) => Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: ChoiceButton(
                                  name: '$choiceTitle',
                                  onTap: () {
                                    widget.alwaysPressed != true
                                        ? setState(() {
                                            if (currentUserChoice !=
                                                choiceTitle) {
                                              currentUserChoice = choiceTitle;
                                            } else {
                                              currentUserChoice = '';
                                            }
                                            ;
                                          })
                                        : setState(() {
                                            (currentUserChoice = choiceTitle);
                                            promote = widget.promotes![widget
                                                .choices
                                                .indexOf(choiceTitle)];
                                          });

                                    if (currentUserChoice != null) {
                                      widget.onValueChanged
                                          ?.call(currentUserChoice!);
                                    }
                                  },
                                  pressed: currentUserChoice == choiceTitle,
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  RoundedButton(
                    name: 'Save',
                    onTap: () {
                      if (widget.onSave != null) {
                        widget.onSave!.call();
                      } else {
                        Get.back();
                      }
                    },
                  ),
                  if (promote != '')
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: FittedBox(
                        child: Row(
                          children: [
                            const Icon(Icons.remove_red_eye_rounded,
                                color: Colors.black54),
                            const SizedBox(width: 10),
                            Text(promote, style: kSmallInfoStyle),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
