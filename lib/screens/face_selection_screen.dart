import 'dart:collection';
import 'dart:io';

import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/screens/advanced_settings_screen.dart';
import 'package:betabeta/services/networking.dart';
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
    HashMap<String, dynamic> facesData = await NetworkHelper().getFacesCustomImageSearchLinks(
        imageFileName: widget.imageFileName);
    String? status = facesData['status'];
    while (status == 'incomplete') {
      facesData = await NetworkHelper().getFacesCustomImageSearchLinks(
          imageFileName: widget.imageFileName);
      status = facesData[
          'status']; //TODO make sure we don't fuck the server with lots of requests

    }

    setState(() {
      _facesLinks = List<String>.from(facesData['faces_links']);
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

                      child: TextButton(
                    onPressed: _indexSelected == _notSelected
                        ? null
                        : () {
                            SettingsData.instance.filterDisplayImageUrl =
                                _facesLinks![_indexSelected];
                            navigator!.popUntil( (route) {
                              return route.settings.name ==
                                  AdvancedSettingsScreen.routeName;
                            }); //ModalRoute.withName(AdvancedSettingsScreen.routeName));
                          },
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
                  )),
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
