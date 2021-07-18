import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/profile.dart';
import 'package:betabeta/services/networking.dart';
import 'package:betabeta/utils/mixins.dart';
import 'package:betabeta/widgets/clickable.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/draggable.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// The default boxShadow List used in painting clickable items.
const List<BoxShadow> _shadowList = [
  BoxShadow(
    color: defaultShadowColor,
    offset: Offset(0.0, 2.0),
    spreadRadius: 0.0,
    blurRadius: 14.0,
  ),
];

/// The default box-decoration used for decoration the [ProfieImageAvatar].
const BoxDecoration _kElevationDecoration = BoxDecoration(
  shape: BoxShape.circle,
  boxShadow: _shadowList,
);

/// The implementation for the Notification screen.
class ViewChildrenScreen extends StatefulWidget {
  static const String routeName = '/app/view_children';

  ViewChildrenScreen({Key key, @required this.matchProfile}) : super(key: key);

  final Profile matchProfile;

  @override
  _ViewChildrenScreenState createState() => _ViewChildrenScreenState();
}

class _ViewChildrenScreenState extends State<ViewChildrenScreen>
    with MountedStateMixin {
  final GlobalKey _scrollKey = GlobalKey();

  CarouselController _carouselController;

  ScrollController _scrollController;

  NetworkHelper _networkHelper;

  int _userProfileIndex = 0;
  int _matchProfileIndex = 0;
  int _childrenImageIndex = 0;

  // double _offset = 0;
  // double _page = 0;

  List<String> matchProfileImages = [];
  List<String> userProfileImages = [];

  final List<String> mockImages = [
    'assets/mock_images/child_0.jpg',
    'assets/mock_images/child_1.jpg',
    'assets/mock_images/child_2.jpg',
    'assets/mock_images/child_3.jpg',
    'assets/mock_images/child_4.jpg',
    'assets/mock_images/child_5.jpg',
  ];

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _carouselController = CarouselController();

    _networkHelper = NetworkHelper();
    // this has to be called after initialising the "_networkHelper" variable.
    populate();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // _childrenController.dispose();

    super.dispose();
  }

  void populate() async {
    // populate match image urls.
    mountedLoader(() {
      final _macthImgUrls = widget.matchProfile.imageUrls;
      // print(_macthImgUrls);
      if (_macthImgUrls != null && _macthImgUrls.isNotEmpty) {
        for (int i = 0; i < _macthImgUrls.length; i++) {
          final _url = matchBaseUrlToNetwork(_macthImgUrls[i]);
          matchProfileImages.add(_url);
        }
      }
    });

    var _userImgUrls = await _networkHelper.getProfileImages();
    _userImgUrls.removeWhere((u) => u == null);
    // print(_userImgUrls);
    if (_userImgUrls != null && _userImgUrls.isNotEmpty) {
      for (int i = 0; i < _userImgUrls.length; i++) {
        final _url = _networkHelper.getProfileImageUrl(_userImgUrls[i]);
        userProfileImages.add(_url);
      }
    }
    setStateIfMounted(() {/**/});
  }

  @override
  Widget build(BuildContext context) {
    // the device's screen specs.
    final Size _sizeConfig = MediaQuery.of(context).size;
    // the absolute size of the children image.
    final Size childrenCardSize = Size(256, 256);

    final double childrenVertCardPadding = 20.0;

    return Scaffold(
      backgroundColor: darkCardColor,
      appBar: CustomAppBar.subPage(
        subPageTitle: 'View Children',
        hasTopPadding: true,
        showAppLogo: false,
      ),
      body: SingleChildScrollView(
        key: _scrollKey,
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 20.0),
            SizedBox(
              height: _sizeConfig.height * 0.37,
              width: _sizeConfig.width,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(0.0, 0.0),
                    child: FractionallySizedBox(
                      heightFactor: 0.6,
                      widthFactor: 0.6,
                      child: PrecachedImage.asset(
                        imageURI: BetaIconPaths.viewChildrenBackgroundImagePath,
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
                                  Clickable(
                                    onTap: () {
                                      // setStateIfMounted(() {
                                      //   final _newIndex = userProfileIndex + 1;
                                      //   if (_newIndex <
                                      //       userProfileImages.length) {
                                      //     // add to the index if the current index does not
                                      //     // exceed th imageUrls length.
                                      //     userProfileIndex = _newIndex;
                                      //   } else {
                                      //     // otherwise set the value to zero
                                      //     // therby resetting its position.
                                      //     userProfileIndex = 0;
                                      //   }
                                      // });
                                    },
                                    child: PofileImageAvatar.mutable(
                                      actualImage: userProfileImages.isEmpty
                                          ? null
                                          : NetworkImage(userProfileImages[
                                              _userProfileIndex]),
                                      minRadius: 28.50,
                                      maxRadius: 35.5,
                                      placeholderImage: AssetImage(
                                        BetaIconPaths.defaultProfileImagePath01,
                                      ),
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
                                  Clickable(
                                    onTap: () {
                                      // setStateIfMounted(() {
                                      //   final _newIndex = matchProfileIndex + 1;
                                      //   if (_newIndex <
                                      //       matchProfileImages.length) {
                                      //     // add to the index if the current index does not
                                      //     // exceed th imageUrls length.
                                      //     matchProfileIndex = _newIndex;
                                      //   } else {
                                      //     // otherwise set the value to zero
                                      //     // therby resetting its position.
                                      //     matchProfileIndex = 0;
                                      //   }
                                      // });
                                    },
                                    child: PofileImageAvatar.mutable(
                                      actualImage: matchProfileImages.isEmpty
                                          ? null
                                          : NetworkImage(matchProfileImages[
                                              _matchProfileIndex]),
                                      minRadius: 28.50,
                                      maxRadius: 35.5,
                                      placeholderImage: AssetImage(
                                        BetaIconPaths.defaultProfileImagePath01,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Container(
                            child: DecoratedBox(
                              decoration: _kElevationDecoration,
                              child: PofileImageAvatar.mutable(
                                actualImage: AssetImage(
                                  // Todo; Change to Image.network when linking with backend.
                                  mockImages[_childrenImageIndex],
                                ),
                                minRadius: 65.0,
                                maxRadius: 85.5,
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
            SizedBox(height: 20.0),
            SizedBox(
              height: childrenCardSize.height + childrenVertCardPadding,
              child: CarouselSlider.builder(
                carouselController: _carouselController,
                options: CarouselOptions(
                  autoPlay: false,
                  enableInfiniteScroll: false,
                  height: childrenCardSize.height,
                  enlargeCenterPage: true,
                  viewportFraction: 0.6,
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  onPageChanged: (index, changeReason) {
                    setStateIfMounted(() {
                      _childrenImageIndex = index;
                    });
                  },
                ),
                itemCount: mockImages.length,
                itemBuilder: (context, _index, realIndex) {
                  final _currentImageUrl = mockImages[realIndex];

                  return GestureDetector(
                    onTap: () {
                      _carouselController.animateToPage(
                        realIndex,
                        duration: Duration(milliseconds: 800),
                        curve: Curves.decelerate,
                      );

                      setStateIfMounted(() {
                        _childrenImageIndex = realIndex;
                      });
                    },
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: childrenCardSize.height,
                        maxHeight: childrenCardSize.height,
                        minWidth: childrenCardSize.width,
                        maxWidth: childrenCardSize.width,
                      ),
                      child: Container(
                        width: childrenCardSize.width,
                        height: childrenCardSize.height,
                        margin: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: kElevationToShadow[2],
                          image: DecorationImage(
                            image: AssetImage(_currentImageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  textStyle: smallBoldedCharStyle.copyWith(
                    color: colorBlend02,
                    decorationColor: colorBlend02,
                    decoration: TextDecoration.underline,
                  ),
                  primary: colorBlend02,
                  backgroundColor: Colors.transparent,
                ),
                onPressed: () {/*Do something*/},
                label: Text(
                  'See more',
                  style: smallBoldedCharStyle.copyWith(
                    color: colorBlend02,
                    decorationColor: colorBlend02,
                    decoration: TextDecoration.underline,
                  ),
                ),
                icon: Icon(
                  Icons.add_rounded,
                  color: blue,
                  size: 18.0,
                ),
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
                color: blue,
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
            Center(
              child: Material(
                clipBehavior: Clip.antiAlias,
                color: Colors.white,
                shape: CircleBorder(),
                elevation: 2.0,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).maybePop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: GlobalWidgets.assetImageToIcon(
                      BetaIconPaths.cancelIconPath,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

/// A Widget for creating circle Profile Avatars.
///
/// The constructor [PofileImageAvatar.mutable] is specially adapted for situations where the expected image
/// may not be available at hand.
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
  /// depending on whether the [actualImage] is `null` or not and replaced by another placholder imageProvider,
  /// [placeholderImage].
  ///
  /// The [placeholderImage] should be an image that is readily available like an [AssetImage] or a [MemoryImage]
  /// since it will be considered as a placeholder.
  ///
  /// Note that if the value [actualImageIsAvailable] is set to `false`, the [placeholderImage] will be rendered
  /// whether or not the [actualImage] is non-null.
  /// For this cause [actualImageIsAvailable] is set to `true` by default meaning without providing the [actualImage]
  /// value the [placeholderImage] will be loaded instead when and only when the [actualImage] is null.
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

  /// The widget to display above the avatar.
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
      decoration: decoration ?? _kElevationDecoration,
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
