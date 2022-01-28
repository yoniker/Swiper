import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/match_engine.dart';
import 'package:betabeta/models/profile.dart';
import 'package:betabeta/screens/full_image_screen.dart';
import 'package:betabeta/screens/view_children_screen.dart';
import 'package:betabeta/widgets/basic_detail.dart';
import 'package:betabeta/widgets/compatibility_scale.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/like_scale.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';


/// A widget to paint the various information of a
/// match unto the screen.
///
class MatchCard extends StatefulWidget {
  MatchCard({
    Key? key,
    this.profile,
    this.clickable = true,
    this.showCarousel = true,
  }) : super(key: key);

  /// The profile of the match.
  final Profile? profile;

  /// Whether or not the Match card can receive click gestures.
  final bool clickable;

  /// Whether to show the carousel or not.
  final bool showCarousel;

  @override
  _MatchCardState createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  ScrollController? _scrollController;

  /// This connotes the Widget to display as the background.
  /// This is typically a [PhotoView].
  Widget _buildBackground(BuildContext context) {
    final bool _isPotrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    // returns a [PhotoView] widget.
    return FractionallySizedBox(
      alignment: Alignment.center,
      heightFactor: 1.0,
      widthFactor: 1.0,
      child: PhotoView(
        isClickable: widget.clickable,
        initialPhotoIndex: 0,
        descriptionHeightFraction: _isPotrait ? 0.2 : 0.4,
        imageUrls: widget.profile!.imageUrls,
        showCarousel: widget.showCarousel,
        descriptionWidget: _descriptionWidget(),
        carouselInactiveDotColor: inactiveDot,
        carouselActiveDotColor: activeDot,
      ),
    );
  }

  Widget _buildDivider(){
    return Divider(
      color: lightCardColor,
      indent: 2.0,
      endIndent: 2.0,
      thickness: 2.8,
      height: 8.0,
    );
  }

  /// A widget to display the Description of the user.
  /// This will be passed as a the `descriptionWidget` Parameter of the [PhotoView] widget.
  Widget _descriptionWidget() {
    // get the relative fontSize for each Device Screen.
    //
    // This thus helps creates a kind of sizing effect to our text.
    double getRelativeTextSize(num baseValue) {
      // get the aspect Ratio of the Device i.e. the length dived by the breadth (something of that sort)
      double multiplicativeRatio = MediaQuery.of(context).size.height / 2;

      // clamp the value to a range between "0.0" and the supplied baseValue
      double clampedValue = (multiplicativeRatio).clamp(
            0.0,
            1.0,
          ) *
          baseValue.toDouble();

      return clampedValue;
    }

    // construct the Widget.
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.profile!.username}, ${widget.profile!.age}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: boldTextStyle.copyWith(
                color: Colors.white,
                fontSize: getRelativeTextSize(25),
              ),
            ),
            Expanded(
              child: Text(
                widget.profile!.headline ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: boldTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: getRelativeTextSize(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  List<Widget> buildMatchDetails(
    Profile profile, {
    required BuildContext context,
  }) {
    final _imageUrls = profile.imageUrls ?? <String>[];

    // builds the achivement items such as loves and stars.
    Widget _buildAchievementItem(String iconURI, String value) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.0),
        child: Row(
          children: [
            Text(
              value,
              style: smallCharStyle.copyWith(color: darkTextColor),
            ),
            SizedBox(width: 2.0),
            PrecachedImage.asset(
              imageURI: iconURI,
            ),
          ],
        ),
      );
    }

    // Return a List of Widgets.
    return [
      SizedBox(height: 16.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                '${profile.username}, ${profile.age}',
                textAlign: TextAlign.left,
                // overflow: TextOverflow.ellipsis,
                style: boldTextStyle.copyWith(fontSize: 18.0),
              ),
            ),
          ),
        ],
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Text(
          (profile.headline != null) ? profile.headline! : '',
          textAlign: TextAlign.left,
          style: defaultTextStyle,
        ),
      ),
      Text(
        'About me',
        style: subTitleStyle,
      ),
      _buildDivider(),
      Text(
        (profile.description != null)
            ? profile.description!
            : 'No Description available',
        style: mediumCharStyle,
      ),
      SizedBox(height:20),


      Text(
        'Profile Images',
        style: subTitleStyle,
      ),
      _buildDivider(),

      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(
          top: 8.0,
          bottom: 12.0,
          left: 5.0,
          right: 5.0,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 30.5,
            maxHeight: 100.5,
            minWidth: 250.0,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: !(_imageUrls.length > 0)
              ? Center(
            child: Text(
              'No Profile image Available for match',
              style: mediumBoldedCharStyle,
            ),
          )
              : ListView.separated(
            key: UniqueKey(),
            scrollDirection: Axis.horizontal,
            itemCount: _imageUrls.length,
            itemBuilder: (cntx, index) {
              final String _url =
                  'https://'+_imageUrls[index];
              return GestureDetector(
                onTap: () {
                  // pushToScreen(
                  //   context,
                  //   builder: (context) =>
                  //       FullImageScreen(imageUrl: _url),
                  // );
                  Get.toNamed(
                        FullImageScreen.routeName,arguments:_url,
                      );

                },
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 30.5,
                    maxHeight: 100.5,
                    minWidth: 30.5,
                    maxWidth: 100.5,
                  ),
                  // height: 80.5,
                  // width: 100.0,
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Card(
                      margin: EdgeInsets.all(6.0),
                      clipBehavior: Clip.antiAlias,
                      elevation: 2.1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: PrecachedImage.network(
                        imageURL: _url,
                        fadeIn: true,
                        shouldPrecache: false,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (cntx, index) {
              return SizedBox(width: 16.0);
            },
          ),
        ),
      ),


      Text(
        'Basic Info',
        style: subTitleStyle,
      ),
      _buildDivider(),
      if (profile.location!=null)
        BasicDetail(detailText: '${profile.location}',
          detailIcon: FaIcon(FontAwesomeIcons.mapMarkedAlt,color: Colors.red,)),
      if(profile.height!=null)
        BasicDetail(detailText: '${profile.height}',detailIcon: FaIcon(FontAwesomeIcons.ruler,color: Colors.yellow[700],),),
      if(profile.jobTitle!=null)
        BasicDetail(detailText: '${profile.jobTitle}',detailIcon: FaIcon(FontAwesomeIcons.userTie,color:Colors.black),),

      Text(
        'Artificial Intelligence',
        style: subTitleStyle,
      ),
      _buildDivider(),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(
          top: 8.0,
          bottom: 12.0,
          left: 5.0,
          right: 5.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DescriptionBanner(
              // TODO(Backend) Add a field "gender" to the profile Interface:
              message: 'See your children',

              leading: PrecachedImage.asset(imageURI: 'assets/images/babies.png'),//Image.asset('assets/images/babies.png'),

              overflow: null,
              constraints: BoxConstraints(
                minHeight: 75.0,
                maxHeight: 90.5,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              onTap: () async {
                // Before the new Route is pushed we set the value of
                Get.toNamed(ViewChildrenScreen.routeName, arguments: profile);
              },
              label: Align(
                alignment: Alignment(-1.02, -2.0),
                child: PrecachedImage.asset(
                  imageURI: BetaIconPaths.tryMeBanner,
                ),
              ),
            ),
            DescriptionBanner(
              message: 'Personal preference',
              leading: Icon(
                Icons.info,
                color: Colors.blue,
              ),
              overflow: null,
              constraints: BoxConstraints(
                minHeight: 75.0,
                maxHeight: 90.5,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              trailing: CompatibilityScale(
                value: profile.compatibilityScore!,
                startValue: 20.0,
              ),
              onTap: () async {
                await GlobalWidgets.showAlertDialogue(
                  context,
                  title: 'Info',
                  message:
                      'The probability that you will like the current profile, according to Alex,your AI which learnt your personal taste.',
                );
              },
            ),
            DescriptionBanner(
              message: 'Compatibility',
              overflow: null,
              constraints: BoxConstraints(
                minHeight: 75.0,
                maxHeight: 90.5,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              leading: Icon(
                Icons.info,
                color: Colors.blue,
              ),
              trailing: LikeScale(value: profile.hotnessScore!),
                onTap: () async {
                  try {
                    await GlobalWidgets.showAlertDialogue(
                      context,
                      title: 'Info',
                      message:
                      'The probability that you will be a good match, according to Chris. Chris is an AI which was trained on millions of successful couples!',
                    );} catch (e, s) {
                    print(s);
                  }
                }
            ),
          ],
        ),
      ),
    ];
  }

  /// A widget that displays the actions a user can make on a match.
  /// Actions such as:
  ///   "Dislike",
  ///   "Like",
  ///   "Draft Message"
  ///
  /// Essentially a list of [DecisionControl] widgets to display below
  /// the Image Display Widget of each match.
  Widget _matchControls({EdgeInsets padding = const EdgeInsets.all(2.0)}) {
    return Container(
      padding: padding,
      foregroundDecoration: BoxDecoration(
        color: Colors.transparent,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: lightCardColor,
            offset: Offset(0.0, 0.2),
            blurRadius: 16.0,
          ),
        ],
      ),
      // A Material Widget is added here so as to allow the solash of the InkWell Widgets
      // below this Widget in the tree to show.
      //
      // Note: Any Container Within the Widget tree will obscure the action of any InkWell Widget
      // below such Container in the Widget tree.
      child: Material(
        // With this as transparent we can retain the original color of the Enclosing
        // Decoration Widget.
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(15.0),
              child: GlobalWidgets.assetImageToIcon(
                BetaIconPaths.dislikeMatchIcon,
                scale: 4.0,
              ),
              onTap: () {
                MatchEngine().currentMatchDecision(Decision.nope);
                print('nope pressed');
              },
            ),
            InkWell(
              borderRadius: BorderRadius.circular(15.0),
              child: GlobalWidgets.assetImageToIcon(
                BetaIconPaths.likeMatchIcon,
                // The scale is kid of backwards.
                scale: 3.75,
              ),
              onTap: () {
                MatchEngine().currentMatchDecision(Decision.like);
                print('like pressed');
              },
            ),
            InkWell(
              borderRadius: BorderRadius.circular(15.0),
              child: GlobalWidgets.assetImageToIcon(
                BetaIconPaths.draftMesssageIcon,
                scale: 4.0,
              ),
              onTap: () {
                // Call a Function to open a chat Tab to chat with the match
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: whiteCardColor,
              borderRadius: BorderRadius.circular(18.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: lightCardColor,
                  offset: Offset(0.0, 0.2),
                  blurRadius: 12.0,
                ),
              ],
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Container(
                    // padding: EdgeInsets.all(0.0),
                    clipBehavior: Clip.antiAlias,
                    constraints: constraints,
                    decoration: BoxDecoration(
                      color: whiteCardColor,
                      borderRadius: BorderRadius.circular(18.0),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: darkTextColor,
                          offset: Offset(0.0, 0.2),
                          blurRadius: 12.0,
                        ),
                      ],
                    ),
                    child: _buildBackground(context),
                  ),
                  ...buildMatchDetails(
                    widget.profile!,
                    context: context,
                  ),
                  _matchControls(),
                ],
              ),
            ),
          );
        }),

      ],
    );
  }
}

/// A Widget to display a set of images.
/// Used by the [MatchCard] widget to display images of
/// matches.
class PhotoView extends StatefulWidget {
  PhotoView({
    Key? key,
    this.isClickable = true,
    this.initialPhotoIndex = 0,
    this.descriptionWidget,
    this.imageUrls = const <String>[],
    this.descriptionAlignment = Alignment.bottomCenter,
    this.descriptionHeightFraction = 0.2,
    this.descriptionWidthFraction = 1.0,
    this.showCarousel = true,
    this.carouselPosition = CarouselPosition.bottom,
    this.carouselDotSize = 3.5,
    this.selectedCarouselDotSize = 6.0,
    this.carouselActiveDotColor = Colors.blue,
    this.carouselInactiveDotColor = Colors.lightBlueAccent,
    this.carouselBackgroundColor = Colors.transparent,
    this.onChanged,
  })  : assert(
            initialPhotoIndex != null &&
                initialPhotoIndex <= imageUrls!.length &&
                initialPhotoIndex.isEven,
            'The initialPhotoIndex cannot be "null" or negative. It must also be in the range of avaliable imageUrls (starting from `0`), Please supply a correct initialPhotoIndex or leave it as it is without supplying the parameter.'),
        assert(showCarousel != null,
            'The optional parameter `showCarousel` cannot be "null". Please set it to either true or false to either show the carousel widget or not.'),
        assert(isClickable != null,
            'The optional parameter `isClickable` cannot be "null". Please set it to either true or false to either make the PhotoView respond to touch Gestures or not.'),
        super(key: key);

  /// The index of the photo to display initially.
  /// 'The initialPhotoIndex cannot be `null` or negative.
  /// It must also be in the range of avaliable imageUrls (starting from `0`).
  ///
  /// Defaults to `0`.
  final int initialPhotoIndex;

  /// Wheter or not user can interact with the [PhotoView] to
  /// either move to the next page or the previous page.
  final bool isClickable;

  /// A list of `imageUrl` String (literals).
  /// This is used by the [PhotoView] widget to produce carousel images.
  final List<String>? imageUrls;

  /// A callback with value Function.
  /// Pass a value to this parameter to get notified whenever a change
  /// occurs to the [PhotoView]'s index.
  final Function(int? index)? onChanged;

  /// The [Color] to be used to paint the background of the Carousel.
  ///
  /// Defaults to [Colors.transparent].
  final Color carouselBackgroundColor;

  /// The [Color] to be used to paint the background of the CarouselDots
  /// when active.
  ///
  /// Defaults to [Colors.blue].
  final Color carouselActiveDotColor;

  /// The [Color] to be used to paint the background of the CarouselDots
  /// when inactive.
  ///
  /// Defaults to [Colors.lightBlueAccent].
  final Color carouselInactiveDotColor;

  /// The size of the CarouselDots used to indicate the current index
  /// of each image in the [PhotoView].
  ///
  /// This is equivalent to double the width and the height of the Dot.
  ///
  /// Defaults to `3.5` logical pixels.
  final double carouselDotSize;

  /// The size of the CarouselDots used to indicate the current index
  /// of the selected image in the [PhotoView].
  ///
  /// This is used as the radius of the CarouselDot which is equivalent to
  /// double the width and the height of the selected Dot.
  ///
  /// Defaults to `4.0` logical pixels.
  final double selectedCarouselDotSize;

  /// A boolean value that determines wheter the [CarouselDot]s are visible
  /// or not.
  ///
  /// This must not be `null`. It is set to true by default.
  final bool showCarousel;

  /// Determines where to Align the Carousel of the [PhotoView].
  final CarouselPosition carouselPosition;

  /// An optional Widget to build a description box into the PhotoView.
  final Widget? descriptionWidget;

  /// The alignment of the `desriptionWidget` in the stack.
  ///
  /// Defaults to `Alignment.bottomCenter`.
  final AlignmentGeometry descriptionAlignment;

  /// The Fractional percentage of the height of the [PhotoView] the
  /// `descriptionWidget` should occupy.
  ///
  /// The accepted values range from `0.0` to `1.0`
  /// A heightFraction of `0.0` means the `descriptionWidget` won't
  /// be visible.
  ///
  /// The default is `0.2`.
  final double descriptionHeightFraction;

  /// The Fractional percentage of the width of the [PhotoView] the
  /// `descriptionWidget` should occupy.
  ///
  /// The accepted values range from `0.0` to `1.0`
  /// A widthFraction of `0.0` means the `descriptionWidget` won't
  /// be visible.
  ///
  /// The default is `1.0`.
  final double descriptionWidthFraction;

  @override
  _PhotoViewState createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  //
  late List<Widget> imagesList;

  //
  List<CarouselDot>? carouselDots;

  // holds the state of the selected photo index.
  int? selectedPhotoIndex;

  @override
  void initState() {
    super.initState();

    // set the initial value of the state variable `_selectedPhotoIndex` to the
    // value of `initialPhotoIndex` passed as a parameter to the [PhotoView] widget.
    selectedPhotoIndex = widget.initialPhotoIndex;
  }

  @override
  void didUpdateWidget(PhotoView oldWidget) {
    super.didUpdateWidget(oldWidget);

    updateImages(context);
    if (widget.initialPhotoIndex != oldWidget.initialPhotoIndex) {
      setState(() {
        selectedPhotoIndex = widget.initialPhotoIndex;
      });
    }
  }

  /// Loads the image into cache
  void updateImages(context) {
    // instantiate the image List
    imagesList = [];

    // instantiate the carousel List
    carouselDots = <CarouselDot>[];

    for (int imageIndex = 0;
        imageIndex < widget.imageUrls!.length;
        imageIndex++) {
      var img = Image.network(
        'https://' + widget.imageUrls![imageIndex],
        scale: 1.0,
        fit: BoxFit.cover,
      );
      precacheImage(img.image, context);
      imagesList.add(img);
    }
  }

  @override
  void didChangeDependencies() {
    updateImages(context);
    super.didChangeDependencies();
  }

  /// A private Function to call the onChanged Callback parameter of the [PhotoView] widget
  /// whenever a change is made to the index of the [PhotoView].
  void _indexChangeListener(int? index) {
    // check if the onChanged(int) Callback parameter passed to the [PhotoView] widget
    // is not `null`.
    if (widget.onChanged != null) {
      // call the `onChanged` Function of the [PhotoView] widget.
      widget.onChanged!(index);
    }
  }

  /// A convenient Function to change the current Image Displayed to
  /// the next image on the Image List.
  ///
  /// If there is no longer any next image in the List, this takes automatically
  /// change the Image Displayed back to the first image on the List.
  void _showNextImg() {
    // This prevents out of interval error.
    if (selectedPhotoIndex!=null && selectedPhotoIndex != widget.imageUrls!.length - 1) {
      setState(() {
        // increase the photo index by one (1).
        selectedPhotoIndex =selectedPhotoIndex! + 1;
      });
    } else {
      setState(() {
        // set the photo index to zero (0).
        selectedPhotoIndex = 0;
      });
    }

    // notify the `onChanged(int)` Callback Listener.
    _indexChangeListener(selectedPhotoIndex);
  }

  /// A convinient Function to change the current Image Displayed to
  /// the previous image on the Image List.
  ///
  /// If there is no longer any previous image next in the List, this takes automatically
  /// change the Image Displayed back to the last image on the List.
  void _showPrevImg() {
    // This prevents out of interval error.
    if (selectedPhotoIndex!=null && selectedPhotoIndex! > 0) {
      setState(() {
        // decrease the photo index by one (1).
        selectedPhotoIndex = selectedPhotoIndex! - 1;
      });
    } else {
      setState(() {
        // set the photo index to the last index of the image List.
        selectedPhotoIndex = widget.imageUrls!.length - 1;
      });
    }
    // notify the `onChanged(int)` Callback Listener.
    _indexChangeListener(selectedPhotoIndex);
  }

  /// An Explicit Function that gives control over the state of the PhotoView.
  /// This include which photo to show at a particular time.
  ///
  /// The `index` parameter must not be `null`.
  ///
  /// Note: use the `onChanged(int)` Function parameter of the [PhotoView]
  /// to get notified whenever a change occurs to the `index` of the [PhotoView].
  void moveToPhoto(int index) {

    // check to verify that such index exists and is accepted.
    if (index <= widget.imageUrls!.length - 1 && !index.isNegative) {
      // switch to the new index.
      setState(() {
        selectedPhotoIndex = index;
      });

      // notify the `onChanged(int)` Callback Listener.
      _indexChangeListener(selectedPhotoIndex);
    } else {
      throw AssertionError(
          '[Invalid State] Index not in range! Please make sure you are passing the right index value as the index parameter.');
    }
  }

  /// A Space or Area for the PhotoDescription.
  Widget _descriptionLayer() {
    return Align(
      alignment: Alignment.center,
      heightFactor: 1.0,
      widthFactor: widget.descriptionWidthFraction,
      child: widget.descriptionWidget,
    );
  }

  /// The space or Area meant for displaying the carousel dots.
  Widget _carouselLayer() {
    // Generate a list of CarouselDots based on the length of the
    // `imageUrls` passed in the constructor body.
    var carousels = List.generate(widget.imageUrls!.length, (index) {
      return CarouselDot(
        key: Key(
          index.toString(),
        ), // Create a Unique Key based on the index of the CarouselDots.
        size: widget.carouselDotSize,
        focusedSize: widget.selectedCarouselDotSize,
        activeColor: widget.carouselActiveDotColor,
        inactiveColor: widget.carouselInactiveDotColor,
        isFocused: index == selectedPhotoIndex,
        onTap: () {
          moveToPhoto(index);
        },
      );
    });

    return Align(
      //
      alignment: widget.carouselPosition == CarouselPosition.bottom
          ? Alignment.bottomCenter
          : Alignment.topCenter,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
            color: widget.carouselBackgroundColor,
            borderRadius: BorderRadius.circular(16.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: carousels,
        ),
      ),
    );
  }

  /// The Space or Area that is clickable by the user.
  Widget _gestureLayer() {
    // returns a Stack of Gesture [Widget]s if the [PhotoView]'s
    // `isClickable` parameter is true.
    // if (widget.isClickable) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // This is stacked to the left hand side.
        // When clicked it shows the previous image of the match.
        // Calls [_showPrevImg()].
        GestureDetector(
          onTap: _showPrevImg,
          child: FractionallySizedBox(
            heightFactor: 1.0,
            widthFactor: 0.5,
            alignment: Alignment.topLeft,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),

        // This is stacked to the right hand side.
        // When clicked it shows the next image of the match.
        // Calls [_showNextImg()].
        GestureDetector(
          onTap: _showNextImg,
          child: FractionallySizedBox(
            heightFactor: 1.0,
            widthFactor: 0.5,
            alignment: Alignment.topRight,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );

  }

  /// The Space or Area in which the image will be displayed.
  Widget _imageLayer() {
    //
    return imagesList[selectedPhotoIndex!];
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // clips the edge of the container preventing any of its content
      // from overflowing.
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(16.0),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // declare the ImageLayer of the PhotoView.
          _imageLayer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 55.0,
                maxHeight: 90.0,
                minWidth: 300,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              child: Container(
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      //Colors.redAccent, To see the actual size of the gradient box, uncomment redAccent and blue and comment out transparent and black45
                      //Colors.blue
                      Colors.transparent,
                      Colors.black45,
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16.0),
                  ),
                ),
                child: Column(
                  // fit: StackFit.expand,
                  mainAxisAlignment: widget.descriptionWidget == null ||
                          widget.showCarousel == null
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    // declare the DescriptionLayer of the PhotoView.
                    // This is placed above the Gesture Layer to allow
                    // for Explicit Gestures.
                    if (widget.descriptionWidget != null)
                      Expanded(child: _descriptionLayer()),

                    // declare the CarouselLayer of the PhotoView.
                    if (widget.showCarousel != null && widget.showCarousel)
                      _carouselLayer(),
                  ],
                ),
              ),
            ),
          ),
          // declare the GestureLayer of the PhotoView.
          if (widget.isClickable) _gestureLayer(),
        ],
      ),
    );
  }
}

/// A widget to indicate the index of a [PhotoView].
///
class CarouselDot extends StatelessWidget {
  const CarouselDot({
    Key? key,
    this.onTap,
    this.size = 3.5,
    this.focusedSize = 4.0,
    this.shape,
    this.isFocused = false,
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);

  /// The active [Color] of this Dot.
  ///
  /// Is used to paint the Dot whenever tit is on Focus.
  final Color? activeColor;

  /// The inactive [Color] of this Dot.
  ///
  /// Is used to paint the Dot whenever it is no more on Focus.
  final Color? inactiveColor;

  /// A Function that fires when [this] is tapped.
  final void Function()? onTap;

  /// Wether or not this Dot is bon Focus.
  ///
  /// Use this parameter to specify the CarouselDot as being focused.
  final bool isFocused;

  /// This is equivalent to double the width and the height of the Dot.
  ///
  /// This defaults to `3.5`
  final double size;

  /// The size of the Dot when focused.
  ///
  /// This is equivalent to double the width and the height of the Dot.
  ///
  /// This defaults to `4.0`
  final double focusedSize;

  /// The ShapeBorder to be used to draw the CarouselDot.
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      // Make the Dot appear bigger than the others when in Focus.
      size: Size.fromRadius(isFocused ? focusedSize : size),
      child: GestureDetector(
        onTap: () {
          onTap!();
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isFocused ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(24.0),
          ),
        ),
      ),
    );
  }
}

/// Used to determine the position of the carousel in the description stack of the
/// [PhotoView].
enum CarouselPosition {
  /// The CarouselDots will be stacked above the Description in the Description Widget.
  top,

  /// The CarouselDots will be stacked below the Description in the Description Widget.
  bottom,
}
