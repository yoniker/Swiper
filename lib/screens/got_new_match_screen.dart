import 'package:betabeta/models/profile.dart';
import 'package:betabeta/widgets/chat_profile_display_widget.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GotNewMatchScreen extends StatefulWidget {
  const GotNewMatchScreen({Key? key}) : super(key: key);
  static const String routeName = '/gotNewMatch';

  @override
  _GotNewMatchScreenState createState() => _GotNewMatchScreenState();
}

class _GotNewMatchScreenState extends State<GotNewMatchScreen> {
  late Profile theUser;


  @override
  void initState() {
    theUser = Get.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
        hasTopPadding: true,
        hasBackButton: true,
        customTitle: ProfileDisplay(theUser,minRadius: 10,maxRadius: 20,direction: Axis.horizontal,),
    ),
    body: Center(child: Text('You got a new match with ${theUser.username}')),
    );
  }
}
