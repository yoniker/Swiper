import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';


class FullImageScreen extends StatelessWidget {
  static const String routeName = '/main_messages_screen';
  final String? imageUrl;

  const FullImageScreen({Key? key, this.imageUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: GestureDetector(
        onTap: (){
          navigator!.pop(context);
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
