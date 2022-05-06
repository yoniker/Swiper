import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/setting_edit_block.dart';
import 'package:flutter/material.dart';

class JobTitleScreen extends StatefulWidget {
  const JobTitleScreen({Key? key}) : super(key: key);
  static const String routeName = '/job_title_screen';

  @override
  State<JobTitleScreen> createState() => _JobTitleScreenState();
}

TextEditingController jobTitleController =
    TextEditingController(text: SettingsData.instance.jobTitle);

class _JobTitleScreenState extends State<JobTitleScreen> {
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
                      'What is your job title?',
                      style: titleStyle,
                    ),
                  ),
                  TextEditBlock(
                    hideTitle: true,
                    showCursor: true,
                    title: 'Job title',
                    maxLines: 1,
                    maxCharacters: 25,
                    controller: jobTitleController,
                    onType: (val) {
                      SettingsData.instance.jobTitle = val;
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
