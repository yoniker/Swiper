import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/services/aws_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircularUserAvatar extends StatelessWidget {
  ///Optional image provider to use for this avatar(otherwise it will be the current user image)
  final ImageProvider? imageProvider;

  /// The widget to display above the avatar.
  final Widget? child;

  final double? radius;

  /// The minimum size of the avatar, expressed as the radius (half the
  /// diameter).
  ///
  /// If [minRadius] is specified, then [radius] must not also be specified.
  ///
  /// Defaults to zero.
  ///
  /// Constraint changes are animated, but size changes due to the environment
  /// itself changing are not. For example, changing the [minRadius] from 10 to
  /// 20 when the [CircleAvatar] is in an unconstrained environment will cause
  /// the avatar to animate from a 20 pixel diameter to a 40 pixel diameter.
  /// However, if the [minRadius] is 40 and the [CircleAvatar] has a parent
  /// [SizedBox] whose size changes instantaneously from 20 pixels to 40 pixels,
  /// the size will snap to 40 pixels instantly.
  final double? minRadius;

  /// The maximum size of the avatar, expressed as the radius (half the
  /// diameter).
  ///
  /// If [maxRadius] is specified, then [radius] must not also be specified.
  ///
  /// Defaults to [double.infinity].
  ///
  /// Constraint changes are animated, but size changes due to the environment
  /// itself changing are not. For example, changing the [maxRadius] from 10 to
  /// 20 when the [CircleAvatar] is in an unconstrained environment will cause
  /// the avatar to animate from a 20 pixel diameter to a 40 pixel diameter.
  /// However, if the [maxRadius] is 40 and the [CircleAvatar] has a parent
  /// [SizedBox] whose size changes instantaneously from 20 pixels to 40 pixels,
  /// the size will snap to 40 pixels instantly.
  final double? maxRadius;

  final Color backgroundColor;

  final Color borderColor;

  /// The decoration with which to decorate the [ProfileImageAvatar].
  final Decoration? decoration;

  const CircularUserAvatar(
      {Key? key,
      this.imageProvider,
      this.backgroundColor = const Color(0xFFE0E0E0),
      this.decoration,
      this.child,
      this.radius,
      this.minRadius,
      this.maxRadius,
      this.borderColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListenerWidget(
      notifier: SettingsData.instance,
      builder: (context) {
        String? _profileImageToShow;
        List<String> _profileImagesUrls =
            SettingsData.instance.profileImagesUrls;

        if (_profileImagesUrls.isNotEmpty) {
          _profileImageToShow = _profileImagesUrls.first;
        }

        ImageProvider toUseImageProvider = imageProvider != null
            ? imageProvider!
            : _profileImageToShow == null
                ? ExtendedAssetImageProvider(
                    BetaIconPaths.defaultProfileImagePath01,
                    cacheRawData: true)
                : ExtendedNetworkImageProvider(
                    AWSServer.getProfileImageUrl(_profileImageToShow),
                    cache: true) as ImageProvider;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              shape: CircleBorder(),
              color: borderColor,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  backgroundColor: backgroundColor,
                  backgroundImage: toUseImageProvider,
                  radius: radius,
                  minRadius: minRadius,
                  maxRadius: maxRadius,
                  child: child,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 2.w),
              child: SizedBox(
                height: 10.h,
                width: 10.w,
                child: Material(
                  shape: CircleBorder(),
                  color: appMainColor,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
