import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/lists_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/questionnaire_widget.dart';
import 'package:flutter/material.dart';

class PronounsEditScreen extends StatefulWidget {
  static const String routeName = '/pronouns_edit_screen';
  const PronounsEditScreen({Key? key}) : super(key: key);

  @override
  _PronounsEditScreenState createState() => _PronounsEditScreenState();
}

class _PronounsEditScreenState extends State<PronounsEditScreen> {
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
            resizeToAvoidBottomInset: true,
            backgroundColor: backgroundThemeColor,
            appBar: CustomAppBar(
              hasTopPadding: true,
              hasBackButton: true,
              title: 'My gender',
            ),
            body: Column(
              children: [
                Expanded(
                  child: QuestionnaireWidget(
                    choices: kGenderChoices,
                    alwaysPressed: true,
                    bottomPadding: false,
                    initialChoice: SettingsData.instance.userGender,
                    extraUserChoice: true,
                    onValueChanged: (newGender) {
                      SettingsData.instance.userGender = newGender;
                    },
                    onSave: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.black87),
                    child: CheckboxListTile(
                        title: const Text(
                          'Visible',
                          style: boldTextStyle,
                        ),
                        controlAffinity: ListTileControlAffinity.trailing,
                        contentPadding: EdgeInsets.zero,
                        checkColor: Colors.white,
                        activeColor: Colors.black87,
                        tristate: false,
                        value: SettingsData.instance.showUserGender,
                        onChanged: (value) {
                          if (value != null) {
                            SettingsData.instance.showUserGender = value;
                          }
                        }),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
