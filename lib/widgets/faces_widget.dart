import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/services/aws_networking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FacesWidget extends StatefulWidget {
  final List<String>? facesUrls;
  final Function(int) onClickIndex;
  final int selectedIndex;
  FacesWidget(this.facesUrls,this.onClickIndex,this.selectedIndex);
  @override
  _FacesWidgetState createState() => _FacesWidgetState();
}

class _FacesWidgetState extends State<FacesWidget> {
  List<Image>? facesImages;
  @override
  Widget build(BuildContext context) {
    Widget imagesWidget;
    List<Image> facesImages=[];
    if (widget.facesUrls == null){
      imagesWidget = CupertinoActivityIndicator();
    }
    else{
      for(int imageIndex = 0 ; imageIndex<widget.facesUrls!.length; imageIndex++){
        String url = AWSServer.instance.CustomFaceLinkToFullUrl(widget.facesUrls![imageIndex]);
        Image img = Image.network(url,height: 75.0,width: 75.0,fit:BoxFit.cover);
        precacheImage(img.image, context);
        facesImages.add(img);


      }

      if(widget.facesUrls!.length==0){
        imagesWidget = Center(child: Text('No face was detected!',style:boldTextStyle.copyWith(color: Colors.red)));
      } else{

      imagesWidget = ListView.separated(
        shrinkWrap: true,
        //physics:BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal, itemBuilder: (BuildContext context, int index) {
        return

          GestureDetector(
            onTap: (){
              widget.onClickIndex(index);
            },
            child: Container(
                height: 75.0,
                width: 75.0,
                decoration: BoxDecoration(shape: BoxShape.circle,
                    border: Border.all(width: 2.0,color: index==widget.selectedIndex? colorBlend01:disabledColor)),
                child: ClipOval(child: facesImages[index])),
          );
      },
        itemCount: facesImages.length, separatorBuilder: (BuildContext context, int index) {
        return SizedBox(width: 25.0,);
      },

      );}

    }

    return Container(
        height: 75.0,
        margin: EdgeInsets.symmetric(vertical: 5.0),
        child:imagesWidget
    );
  }
}
