import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/profile.dart';
import 'package:betabeta/services/aws_networking.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:flutter/material.dart';

class ProfileDisplay extends StatelessWidget {
  const ProfileDisplay(this.profile,
      {this.minRadius,
      this.maxRadius,
      this.radius,
      this.onTap,
      Key? key,
      this.direction = Axis.vertical})
      : super(key: key);
  final Profile profile;
  final GestureTapCallback? onTap;
  final Axis direction;
  final double? radius;
  final double? minRadius;
  final double? maxRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
          margin: EdgeInsets.all(5.0),
          child: direction == Axis.vertical
              ? Column(children: [
                  Container(
                      margin: EdgeInsets.all(2.0),
                      child: ProfileImageAvatar.network(
                        url: profile.profileImage,
                        radius: radius,
                        minRadius: minRadius,
                        maxRadius: maxRadius,
                      )),
                  Text(profile.username)
                ])
              : Row(children: [
                  Container(
                      margin: EdgeInsets.all(2.0),
                      child: ProfileImageAvatar.network(
                        url: AWSServer.getProfileImageUrl(
                            profile.profileImage),
                        radius: radius,
                        minRadius: minRadius,
                        maxRadius: maxRadius,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Text(profile.username, style: titleStyle)
                ])),
    );
  }
}
