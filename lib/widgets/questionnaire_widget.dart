import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/services/screen_size.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/onboarding/choice_button.dart';
import 'package:betabeta/widgets/onboarding/conditional_parent_widget.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';

class QuestionnaireWidget extends StatefulWidget {
  QuestionnaireWidget({required this.choices, this.headline});
  final List<String> choices;
  final String? headline;
  String? choice;

  @override
  State<QuestionnaireWidget> createState() => _QuestionnaireWidgetState();
}

class _QuestionnaireWidgetState extends State<QuestionnaireWidget> {
  @override
  Widget build(BuildContext context) {
    //height (with SafeArea)
    double height = MediaQuery.of(context).size.height;
    // Height (without SafeArea)
    var padding = MediaQuery.of(context).viewPadding;
    double heightWithoutSafeArea = height - padding.top - padding.bottom;

    return SafeArea(
      child: RawScrollbar(
        isAlwaysShown: true,
        thumbColor: Colors.black54,
        thickness: 5,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            height: heightWithoutSafeArea - 38,
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
                              .map((h) => Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: ChoiceButton(
                                      name: '$h',
                                      onTap: () {
                                        setState(() {
                                          widget.choice = h;
                                        });
                                      },
                                      pressed: widget.choice == h,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
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
    );
  }
}
