import 'package:betabeta/models/profile.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:flutter/material.dart';



class ProfileDisplay extends StatelessWidget {
  const ProfileDisplay(this.userInfo,{this.minRadius,this.maxRadius,this.radius,this.onTap,Key? key,this.direction=Axis.vertical}) : super(key: key);
  final Profile userInfo;
  final GestureTapCallback? onTap;
  final Axis direction;
  final double? radius;
  final double? minRadius;
  final double? maxRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap?.call();
      },
      child: Container(
          margin: EdgeInsets.all(5.0),
          child: direction == Axis.vertical?Column(
              children:
              [Container(margin:EdgeInsets.all(2.0),child: ProfileImageAvatar.network(url:userInfo.imageUrls![0],radius: radius,minRadius: minRadius,maxRadius: maxRadius,)),
                Text(userInfo.username)
              ]
          ):
          Row(
              children:
              [

                Container(margin: EdgeInsets.all(2.0),
                    child: ProfileImageAvatar.network(url:userInfo.imageUrls![0],radius:radius,minRadius: minRadius,maxRadius: maxRadius,)),
                Text(userInfo.username)
              ])
      ),
    );
  }
}
