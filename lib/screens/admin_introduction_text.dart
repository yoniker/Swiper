import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/profile.dart';
import 'package:betabeta/services/aws_networking.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminIntroductionTextScreen extends StatefulWidget {
  static const String routeName = '/admin_introduce_text';
  const AdminIntroductionTextScreen({Key? key}) : super(key: key);

  @override
  State<AdminIntroductionTextScreen> createState() => _AdminIntroductionTextScreenState();
}

class _AdminIntroductionTextScreenState extends State<AdminIntroductionTextScreen> {
  final Profile profile = Get.arguments;

  TextEditingController _textController = TextEditingController(
  );

  @override
  void initState() {
    _textController.text = "Hi ${profile.username}! I'm a manager here at Voilà, and I just wanted to welcome you personally to our community! If you have any questions, please ask me anything :)";
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
          return Scaffold(
            backgroundColor: backgroundThemeColor,
            appBar: CustomAppBar(
              title: 'Admin Text',
              hasTopPadding: true,
              trailing: PrecachedImage.asset(
                imageURI: BetaIconPaths.settingsBarIcon,
                color: Colors.black,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    maxLines: 5,
                    controller: _textController,


                  ),
                  TextButton(onPressed: (){
                    AWSServer.instance.adminIntroduce(introductionText: _textController.text, userUid: profile.uid);
                    Get.back();

                  }, child: Text('Send'))
                ],
              ),
            ),
          );
        ;
}
}
