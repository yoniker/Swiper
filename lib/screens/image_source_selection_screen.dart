// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:http_parser/src/media_type.dart' as media;

import 'face_selection_screen.dart';

class ImageSourceSelectionScreen extends StatefulWidget {
  ImageSourceSelectionScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ImageSourceSelectionScreenState createState() => _ImageSourceSelectionScreenState();
}

class _ImageSourceSelectionScreenState extends State<ImageSourceSelectionScreen> {
  PickedFile _imageFile;
  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();
  String _retrieveDataError;
  bool isVideo = false;


  Future<void> postImage(File imageFile)async{
    const SERVER_ADDR='192.116.48.67:8082';
    const MAX_IMAGE_SIZE = 800;
    const userId = '1234567';
    img.Image theImage = img.decodeImage(imageFile.readAsBytesSync());
    if(max(theImage.height, theImage.width)>MAX_IMAGE_SIZE){
      double resizeFactor = MAX_IMAGE_SIZE/max(theImage.height, theImage.width);
      theImage = img.copyResize(theImage, width: (theImage.width*resizeFactor).round(),height: (theImage.height*resizeFactor).round());
    }

    String fileName = 'custom_face_search_${DateTime.now()}.jpg';
    http.MultipartRequest request = http.MultipartRequest(
      'POST',
      Uri.http(SERVER_ADDR, '/upload/$userId'),
    );
    var multipartFile = new http.MultipartFile.fromBytes(
      'file',
      img.encodeJpg(theImage),
      filename: fileName,
      contentType: media.MediaType.parse('image/jpeg'),
    );
    request.files.add(multipartFile);
    var response = await request.send(); //TODO something if response wasn't 200
    Navigator.push(context,MaterialPageRoute(builder: (context)=>FaceSelectionScreen(imageFile: imageFile, imageFileName: fileName)));
    return;
  }

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
    print('dor?');
    print('lol');
    return Image.file(File(_imageFile.path));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
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
                _imageFile==null?Text('No Image was selected'):showImage(),
                TextButton(onPressed: (){
                  if(_imageFile!=null){postImage(File(_imageFile.path));}}, child: Text('Send to server')),



              ],
            ),
          ),
        )
    );
  }

}
