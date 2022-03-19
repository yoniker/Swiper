import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/questionnaire_widget.dart';
import 'package:flutter/material.dart';

class KidsScreen extends StatefulWidget {
  static const String routeName = '/kids_screen';
  const KidsScreen({Key? key}) : super(key: key);

  @override
  _KidsScreen createState() => _KidsScreen();
}

class _KidsScreen extends State<KidsScreen> {
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
            body: QuestionnaireWidget(
              headline: 'Do you have plans for children?',
              choices: [
                'Have & no more',
                'Have & want more',
                'Want someday',
                "Don't want",
                'Not sure'
              ],
              choice: SettingsData.instance.children,
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
