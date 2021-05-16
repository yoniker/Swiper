// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';
import 'package:betabeta/services/networking.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tuple/tuple.dart';

import 'face_selection_screen.dart';
import 'package:image/image.dart' as img;

class ImageSourceSelectionScreen extends StatefulWidget {
  ImageSourceSelectionScreen({Key key}) : super(key: key);
  static const String routeName = '/image_source_selection_screen';

  @override
  _ImageSourceSelectionScreenState createState() => _ImageSourceSelectionScreenState();
}

class _ImageSourceSelectionScreenState extends State<ImageSourceSelectionScreen> {
  PickedFile _imageFile;
  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();
  String _retrieveDataError;
  bool isVideo = false;




  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        return;
      } else {
        setState(() {
          _imageFile = response.file;
        });
      }
    } else {
      _retrieveDataError = response.exception.code;
    }
  }


  void _onImageButtonPressed(ImageSource source) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      if(pickedFile!=null){
        _imageFile = pickedFile;
        Tuple2<img.Image, String> imageFileDetails = NetworkHelper().preparedImageFileDetails(File(_imageFile.path));
        await NetworkHelper().postImage(imageFileDetails);
        Navigator.pushNamed(context,FaceSelectionScreen.routeName,arguments: FaceSelectionScreenArguments(imageFile: File(_imageFile.path), imageFileName: imageFileDetails.item2));
        //Navigator.push(context,MaterialPageRoute(builder: (context)=>FaceSelectionScreen(imageFile: File(_imageFile.path), imageFileName: imageFileDetails.item2)));
        }
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }



  Widget showImage(){
    return Image.file(File(_imageFile.path));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Pick an image',
          trailing:Icon(Icons.image),//iconURI: 'assets/images/settings_icon.png',
          hasTopPadding: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: (){
                  _onImageButtonPressed(ImageSource.camera);
                }, child:
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:[Container(height:100.0,width: 100.0,child: SvgPicture.asset('assets/camera.svg')),Text('Camera',style: TextStyle(
                      fontSize: 35.0,fontWeight: FontWeight.w700,letterSpacing: 2.0
                  ),)],)),
                SizedBox(height: 30.0,),
                ElevatedButton(onPressed: (){
                  _onImageButtonPressed(ImageSource.gallery);
                }, child:
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:[Container(height:100.0,width: 100.0,child: SvgPicture.asset('assets/gallery.svg')),Text('Gallery',style: TextStyle(
                      fontSize: 35.0,fontWeight: FontWeight.w700,letterSpacing: 2.0
                  ),)],)
                ),



              ],
            ),
          ),
        )
    );
  }

}
