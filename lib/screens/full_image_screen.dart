import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';


class FullImageScreen extends StatelessWidget {
  static const String routeName = '/main_messages_screen';
  final String? imageUrl;
  FullImageScreen({Key? key}) : imageUrl = (Get.arguments as String),super(key: key){
    print('Dor and only dor?');
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: GestureDetector(
        onTap: (){
          Get.back();
        },
        child: Container(
            child: PhotoView(
            imageProvider: NetworkImage(imageUrl!),
        )
        ),
      ),
    );
  }
}
