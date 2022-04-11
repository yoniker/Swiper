import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/screen_size.dart';
import 'package:betabeta/widgets/onboarding/choice_button.dart';
import 'package:betabeta/widgets/onboarding/conditional_parent_widget.dart';
import 'package:betabeta/widgets/onboarding/input_field.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class QuestionnaireWidget extends StatefulWidget {
  QuestionnaireWidget(
      {required this.choices,
      this.initialChoice,
      this.onValueChanged,
      this.onSave,
      this.headline,
      this.promotes,
      this.saveButtonName = 'Save',
      this.extraUserChoice = false,
      this.bottomPadding = true,
      this.alwaysPressed = false});
  final List<String> choices;
  final String? headline;
  final void Function(String)? onValueChanged;
  final void Function()? onSave;
  final bool alwaysPressed;
  final String? initialChoice;
  final String saveButtonName;
  final bool extraUserChoice;
  final bool bottomPadding;

  final List<String>? promotes;

  @override
  State<QuestionnaireWidget> createState() => _QuestionnaireWidgetState();
}

class _QuestionnaireWidgetState extends State<QuestionnaireWidget> {
  String? currentUserChoice;
  String promote = '';
  bool? _checked = false;
  String otherChoice = '';

  void UnFocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  void initState() {
    currentUserChoice = widget.initialChoice;
    if (widget.choices.contains(currentUserChoice) != true &&
        widget.initialChoice != null &&
        widget.initialChoice != '')
      setState(() {
        _checked = true;
      });
    if (widget.promotes != null && widget.initialChoice != null)
      setState(() {
        promote =
            widget.promotes![widget.choices.indexOf(widget.initialChoice!)];
      });

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
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, widget.bottomPadding == true ? 20 : 0),
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
                                    print(promote);
                                    UnFocus();
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
                                            if (promote != '')
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
                    if (widget.extraUserChoice == true)
                      Column(
                        children: [
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
                                      duration: Duration(milliseconds: 400),
                                      turns: _checked == true ? -0.5 : 0,
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
                                    if (currentUserChoice != null) {
                                      widget.onValueChanged
                                          ?.call(currentUserChoice!);
                                    }
                                  },
                                  maxCharacters: 20,
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 20),
                                  hintText: 'For other gender type here',
                                  initialvalue: _checked == true
                                      ? currentUserChoice
                                      : null,
                                  onType: (value) {
                                    setState(
                                      () {
                                        value.isEmpty
                                            ? currentUserChoice =
                                                widget.initialChoice
                                            : currentUserChoice = value;
                                        otherChoice = value;
                                      },
                                    );
                                    if (currentUserChoice != null) {
                                      if (currentUserChoice!.length > 2)
                                        widget.onValueChanged
                                            ?.call(currentUserChoice!);
                                    }
                                    print(widget.initialChoice);
                                  },
                                  pressed: widget.choices
                                          .contains(currentUserChoice) !=
                                      true),
                            ),
                          ),
                        ],
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
              ),
              RoundedButton(
                name: widget.saveButtonName,
                onTap: widget.onSave != null
                    ? () {
                        widget.onSave!.call();
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
