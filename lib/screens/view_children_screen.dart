import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The constant box-decoration used for decoration the [ProfieImageAvatar].
const BoxDecoration _elevationDecoration = BoxDecoration(
  shape: BoxShape.circle,
  boxShadow: [
    BoxShadow(
      color: defaultShadowColor,
      offset: Offset(0.0, 2.0),
      spreadRadius: 0.0,
      blurRadius: 14.0,
    ),
  ],
);

/// The implementation for the Notification screen.
class ViewChildrenScreen extends StatefulWidget {
  static const String routeName = '/app/view_children';

  ViewChildrenScreen({Key key}) : super(key: key);

  @override
  _ViewChildrenScreenState createState() => _ViewChildrenScreenState();
}

class _ViewChildrenScreenState extends State<ViewChildrenScreen> {
  final ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // the device's screen specs.
    final Size _sizeConfig = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: darkCardColor,
      appBar: CustomAppBar.subPage(
        subPageTitle: 'View Children',
        hasTopPadding: true,
        showAppLogo: false,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 20.0),
            SizedBox(
              height: _sizeConfig.height * 0.3,
              width: _sizeConfig.width,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(0.0, 0.0),
                    child: FractionallySizedBox(
                      heightFactor: 0.6,
                      // TODO: change this later to fit exactly.
                      widthFactor: 0.6,
                      child: PrecachedImage.asset(
                        imageURI: BetaIconPaths.progeneyTreeDividerPath,
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: 1.0,
                    widthFactor: 1.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'You',
                                    style: smallBoldedCharStyle,
                                  ),
                                  SizedBox(height: 2.0),
                                  PofileImageAvatar.mutable(
                                    actualImage: null,
                                    minRadius: 24.0,
                                    maxRadius: 30.5,
                                    placeholderImage: AssetImage(
                                      BetaIconPaths.defaultProfileImagePath01,
                                    ),
                                  ),
                                ],
                              ),
                              PrecachedImage.asset(
                                imageURI: BetaIconPaths.heartsUnitedIconPath_01,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Abbie',
                                    style: smallBoldedCharStyle,
                                  ),
                                  SizedBox(height: 2.0),
                                  PofileImageAvatar.mutable(
                                    actualImage: null,
                                    minRadius: 24.0,
                                    maxRadius: 30.5,
                                    placeholderImage: AssetImage(
                                      BetaIconPaths.defaultProfileImagePath01,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            child: DecoratedBox(
                              decoration: _elevationDecoration,
                              child: PofileImageAvatar.mutable(
                                actualImage: null,
                                minRadius: 45.0,
                                maxRadius: 55.5,
                                placeholderImage: AssetImage(
                                  BetaIconPaths.defaultProfileImagePath01,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.0),
            ActionBox(
              message: 'Mark as Like',
              messageStyle: smallBoldedCharStyle.copyWith(color: colorBlend02),
              margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              trailing: PrecachedImage.asset(
                imageURI: BetaIconPaths.heartIconFilled01,
              ),
              onTap: () {
                // TODO: mark the current match as "Like" and close the ViewChildren screen.
              },
            ),
            ActionBox(
              message: 'Mark as Dislike',
              messageStyle: smallBoldedCharStyle.copyWith(color: blue),
              margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              trailing: PrecachedImage.asset(
                imageURI: BetaIconPaths.dislikeMatchIcon,
              ),
              onTap: () {
                // TODO: mark the current match as "Dislike" and close the ViewChildren screen.
              },
            ),
            SizedBox(height: 12.0),
            ActionBox(
              message: 'Say Hi',
              messageStyle:
                  smallBoldedCharStyle.copyWith(color: yellowishOrange),
              margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              trailing: PrecachedImage.asset(
                imageURI: BetaIconPaths.messageIcon,
              ),
              onTap: () {
                // TODO: open junk-message folder and close the ViewChildren screen.
              },
            ),
            SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }
}

///
class PofileImageAvatar extends StatelessWidget {
  /// The default private constructor for the [PofileImageAvatar] widget.
  PofileImageAvatar({
    Key key,
    @required this.imageProvider,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.decoration,
    this.child,
    this.radius,
    this.minRadius,
    this.maxRadius,
  })  : assert(imageProvider != null,
            'The parameter, "imageProvider" must be provided'),
        assert(radius == null || (minRadius == null && maxRadius == null)),
        super(key: key);

  /// Create a [PofileImageAvatar] widget from a network source.
  PofileImageAvatar.network({
    Key key,
    @required String url,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.decoration,
    this.child,
    this.radius,
    this.minRadius,
    this.maxRadius,
    BoxFit fit = BoxFit.cover,
    double height,
    double width,
    double scale = 1.0,
    Color color,
    WidgetBuilder placholderBuilder,
    WidgetBuilder errorBuilder,
    void Function() onError,
  })  : assert(url != null, 'The value of "url" cannot be null!'),
        assert(radius == null || (minRadius == null && maxRadius == null)),
        imageProvider = Image.network(
          url,
          fit: fit,
          width: width,
          height: height,
          scale: scale,
          color: color,
          errorBuilder: errorBuilder == null
              ? null
              : (BuildContext context, Object object, StackTrace stackTrace) {
                  onError();
                  return errorBuilder(context);
                },
          loadingBuilder: placholderBuilder == null
              ? null
              : (BuildContext context, Widget child,
                  ImageChunkEvent chunkEvent) {
                  return placholderBuilder(context);
                },
        ).image,
        super(key: key);

  /// Create a [PofileImageAvatar] widget from the asset.
  PofileImageAvatar.asset({
    Key key,
    @required String uri,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.decoration,
    this.child,
    this.radius,
    this.minRadius,
    this.maxRadius,
    BoxFit fit = BoxFit.cover,
    double height,
    double width,
    double scale = 1.0,
    Color color,
    WidgetBuilder errorBuilder,
    void Function() onError,
  })  : assert(uri != null, 'The value of "uri" cannot be null!'),
        assert(radius == null || (minRadius == null && maxRadius == null)),
        imageProvider = Image.asset(
          uri,
          fit: fit,
          width: width,
          height: height,
          scale: scale,
          color: color,
          errorBuilder: errorBuilder == null
              ? null
              : (BuildContext context, Object object, StackTrace stackTrace) {
                  onError();
                  return errorBuilder(context);
                },
        ).image,
        super(key: key);

  /// A Factory constructor for creating a [PofileImageAvatar] whose imageProvider can be swpped out
  /// depending on whether or not the [actualImage] is null or not and replaced by another placholder imageProvider,
  /// [placeholderImage].
  ///
  /// Note that if the value [actualImageIsAvailable] is set to `false`, the [placeholderImage] will be rendered
  /// whether or not the [actualImage] is non-null.
  /// For this cause [actualImageIsAvailable] is set to `true` by default meaning without providing the value
  /// the [placeholderImage] will be loaded instead when and only when the [actualImage] is null.
  factory PofileImageAvatar.mutable({
    @required ImageProvider actualImage,
    @required ImageProvider placeholderImage,
    bool actualImageIsAvailable = true,
    Color backgroundColor = const Color(0xFFFFFFFF),
    Decoration decoration,
    Widget child,
    double radius,
    double minRadius,
    double maxRadius,
  }) {
    assert(placeholderImage != null,
        'The parameter, "placeholderImage" must be provided!');
    assert(radius == null || (minRadius == null && maxRadius == null));

    final bool _isAvialble = actualImage != null && actualImageIsAvailable;
    final _imageProvider = _isAvialble ? actualImage : placeholderImage;

    return PofileImageAvatar(
      imageProvider: _imageProvider,
      backgroundColor: backgroundColor,
      decoration: decoration,
      child: child,
      radius: radius,
      minRadius: minRadius,
      maxRadius: maxRadius,
    );
  }

  final ImageProvider imageProvider;

  final Widget child;

  final double radius;

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
  final double minRadius;

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
  final double maxRadius;

  final Color backgroundColor;

  /// The decoration with which to decorate the [ProfileImageAvatar].
  final Decoration decoration;

  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: decoration ?? _elevationDecoration,
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        backgroundImage: imageProvider,
        radius: radius,
        minRadius: minRadius,
        maxRadius: maxRadius,
        child: child,
      ),
    );
  }
}
