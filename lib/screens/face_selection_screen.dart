import 'dart:collection';
import 'dart:io';

import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/screens/main_navigation_screen.dart';
import 'package:betabeta/screens/voila_page.dart';
import 'package:betabeta/services/aws_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/screens/advanced_settings_screen.dart';
import 'package:betabeta/services/networking.dart';
import 'package:betabeta/widgets/bouncing_button.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/faces_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_bubble/speech_bubble.dart';

class FaceSelectionScreenArguments {
  final File? imageFile;
  final String? imageFileName;

  FaceSelectionScreenArguments({this.imageFile, this.imageFileName});
}

class FaceSelectionScreen extends StatefulWidget {
  static const String routeName = '/face_selection_screen';
  final File? imageFile;
  final String? imageFileName;
  FaceSelectionScreen():imageFile = (Get.arguments as FaceSelectionScreenArguments).imageFile,imageFileName = (Get.arguments as FaceSelectionScreenArguments).imageFileName;

  @override
  _FaceSelectionScreenState createState() => _FaceSelectionScreenState();
}


class _FaceSelectionScreenState extends State<FaceSelectionScreen> {
  static final int _notSelected = -1;
  List<String>? _facesLinks;
  int _indexSelected = _notSelected;

  @override
  void initState() {
    getFacesLinks();
    super.initState();
  }

  void getFacesLinks() async {
    if(widget.imageFileName==null){return;}
    List<String> facesLinks = await AWSServer.instance.getFaceSearchAnalysis(widget.imageFileName!);
    setState(() {
      _facesLinks = facesLinks;
      print('dor');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Pick a face',
        hasTopPadding: true,
        trailing: Icon(Icons.person_pin_outlined),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: Image.file(
                widget.imageFile!,
                fit: BoxFit.scaleDown,
              )),
          Column(children: [
            Stack(
              children: [
                Center(
                  child: SpeechBubble(
                      nipLocation: NipLocation.BOTTOM,
                      color: colorBlend01,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Pick a face!',
                          style: defaultTextStyle.copyWith(color: Colors.white),
                        ),
                      )),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      //padding: EdgeInsets.all(10),

                      child: BouncingButton(
                        onTap: _indexSelected == _notSelected
                            ? null
                            : () {
                          SettingsData.instance.filterDisplayImageUrl =
                          _facesLinks![_indexSelected];
                          print('set image to ${SettingsData.instance.filterDisplayImageUrl}');
                          navigator!.popUntil( (route) {
                            return route.settings.name ==
                                VoilaPage.routeName || route.settings.name == MainNavigationScreen.routeName;
                          }); //ModalRoute.withName(AdvancedSettingsScreen.routeName));
                        } ,
                        gradientColors: [Colors.white,Colors.white],
                        duration: Duration(seconds: 1),
                        isActive: !(_indexSelected == _notSelected),
                        shouldBounce: !(_indexSelected == _notSelected),
                        height: 45,
                        width: 100,

                        child: Column(
                          children: [
                            Text(
                              'Accept',
                              style: TextStyle(
                                  color: _indexSelected == _notSelected
                                      ? disabledColor
                                      : linkColor),
                            ),
                            Icon(
                              Icons.check,
                              color: _indexSelected == _notSelected
                                  ? disabledColor
                                  : Colors.green,
                            )
                          ],
                        ),
                      )


                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            FacesWidget(_facesLinks, (int indexClicked) {
              setState(() {
                _indexSelected = indexClicked;
              });
            }, _indexSelected)
          ]),
        ],
      ),
    );
  }
}
