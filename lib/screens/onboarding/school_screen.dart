import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/setting_edit_block.dart';
import 'package:flutter/material.dart';

class SchoolScreen extends StatefulWidget {
  const SchoolScreen({Key? key}) : super(key: key);
  static const String routeName = '/school_screen';

  @override
  State<SchoolScreen> createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  TextEditingController schoolController =
      TextEditingController(text: SettingsData.instance.school);

  @override
  Widget build(BuildContext context) {
    return ListenerWidget(
      notifier: SettingsData.instance,
      builder: (context) {
        return Scaffold(
          backgroundColor: backgroundThemeColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                    child: Text(
                      'Where did you go to school?',
                      style: titleStyle,
                    ),
                  ),
                  TextEditBlock(
                    hideTitle: true,
                    showCursor: true,
                    title: 'School/University',
                    maxLines: 1,
                    maxCharacters: 25,
                    controller: schoolController,
                    onType: (val) {
                      SettingsData.instance.school = val;
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
