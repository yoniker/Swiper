import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/profile.dart';
import 'package:flutter/material.dart';

/// A widget to paint the various information of a
/// match unto the screen.
///
class MatchCard extends StatefulWidget {
  MatchCard({
    Key key,
    this.profile,
    this.clickable = true,
    this.showCarousel = true,
  }) : super(key: key);

  /// The profile of the match.
  final Profile profile;

  /// Whether or not the Match card can recieve click gestures.
  final bool clickable;

  /// Whether to show the carousel or not.
  final bool showCarousel;

  @override
  _MatchCardState createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  /// This connotes the Widget to display as the background.
  /// This is typically a [PhotoView].
  Widget _buildBackground() {
    // returns a [PhotoView] widget.
    return FractionallySizedBox(
      alignment: Alignment.center,
      heightFactor: 1.0,
      widthFactor: 1.0,
      child: PhotoView(
        isClickable: widget.clickable,
        initialPhotoIndex: 0,
        imageUrls: widget.profile.imageUrls,
        showCarousel: widget.showCarousel,
        descriptionWidget: _descritionWidget(),
        carouselInactiveDotColor: darkCardColor,
        carouselActiveDotColor: colorBlend02,
      ),
    );
  }

  /// A widget to display the Description of the user.
  /// This will be passed as a the `descriptionWidget` Parameter of the [PhotoView] widget.
  Widget _descritionWidget() {
    // get the relative fontSize for each Device Screen.
    //
    // This thus helps creates a kind of sizing effect to our text.
    double getRelativeTextSize(num baseValue) {
      // get the aspect Ratio of the Device i.e. the length dived by the breadth (something of that sort)
      double aspectRation = MediaQuery.of(context).size.aspectRatio;

      // clamp the value to a range between "0.0" and the supplied baseValue
      double clamppedValue = (aspectRation * 100.00).clamp(
        0.0,
        baseValue.toDouble(),
      );

      return clamppedValue;
    }

    // construct the Widget.
    var descriptionCard = Material(
      color: Colors.black54,
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(16.0),
      ),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(
                '${widget.profile.username}, ${widget.profile.age}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: boldTextStyle.copyWith(
                    color: Colors.white, fontSize: getRelativeTextSize(24)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(
                '${widget.profile.headline}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: boldTextStyle.copyWith(
                    color: Colors.white, fontSize: getRelativeTextSize(18)),
              ),
            ),
          ],
        ),
      ),
    );

    return descriptionCard;
  }

  /// The revert button placed over each MatchCard which Functions to bring back the
  /// recently dismissied MatchCard.
  // Widget _revertButton() {
  //   return Align(
  //     alignment: Alignment.topLeft,
  //     heightFactor: 0.1,
  //     widthFactor: 1.0,
  //     child: Material(
  //       color: Colors.transparent,
  //       child: Padding(
  //         padding: EdgeInsets.all(2.0),
  //         child: IconButton(
  //           icon: Icon(
  //             Icons.replay_rounded,
  //             size: 24.0,
  //             color: colorBlend01,
  //           ),
  //           onPressed: () {
  //             // Move to the prevoious Match Deducted by the Match Engine.
  //             Provider.of<MatchEngine>(context, listen: false).goBack();
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        color: whiteCardColor,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: darkCardColor,
            offset: Offset(0.0, 0.2),
            blurRadius: 12.0,
          ),
        ],
      ),
      child: _buildBackground(),
    );
  }
}

/// A widget to display the Details of each match which will be
/// displayed when the MatchCard is scrolled up.
// class MatchDetailsCard extends StatefulWidget {
//   const MatchDetailsCard({
//     Key key,
//     @required this.matchprofile,
//     @required this.scrollController,
//     this.exitDuration = const Duration(milliseconds: 200),
//   }) : super(key: key);

//   /// The Profile of this match from which the necessary information
//   /// to display is extracted.
//   final Profile matchprofile;

//   /// This gives us the opportunity to close the details page once a Decision
//   /// has been made regarding the current Match.
//   final ScrollController scrollController;

//   /// The Time taken for the Details screen to exit the details Page when a
//   /// Decision is made.
//   final Duration exitDuration;

//   @override
//   _MatchDetailsCardState createState() => _MatchDetailsCardState();
// }

// class _MatchDetailsCardState extends State<MatchDetailsCard> {
//   // Defines the ScrollController that controls the inner ScrollView.
//   ScrollController _innerScrollController;

//   //  Defines the ScrollPhysics of the DetalsCard scrollView.
//   ScrollPhysics physics = ClampingScrollPhysics();

//   // The defualt Curve with which the details Page animates out into the new Match Page.
//   final kdefaultExitCurve = Curves.fastOutSlowIn;

//   // /// A function to select the match Decision made on the the current match.
//   // currentMatchDecision(Decision decision) {
//   //   if (Provider.of<MatchEngine>(context, listen: false).currentMatch() !=
//   //       null) {
//   //     Provider.of<MatchEngine>(context, listen: false)
//   //         .currentMatchDecision(decision);
//   //     Provider.of<MatchEngine>(context, listen: false).goToNextMatch();

//   //     // close thr page since a valid Decision has been made.
//   //     closePage();
//   //   }
//   // }

//   // /// Close the MatchDetailsCard.
//   // /// This essetially calls "moveToPage" on the pageController parameter
//   // /// passed to it.
//   // void closePage() {
//   //   widget.scrollController.animateTo(
//   //     0,
//   //     duration: widget.exitDuration,
//   //     curve: kdefaultExitCurve,
//   //   );

//   //   // we can also use jumpToPage but that will not animate.
//   //   // widget.pageController.jumpToPage(0);
//   // }

//   @override
//   void initState() {
//     super.initState();

//     // Instantiate the _innerScrollController.
//     _innerScrollController = ScrollController();

//     // Add a listener to the outter scroll controller.
//     widget.scrollController.addListener(() {
//       // check to see if the scrollView is at the end of scrolling
//       if (widget.scrollController.offset ==
//           widget.scrollController.position.maxScrollExtent) {
//         setState(() {
//           // locks the ScrollView from moving allowing the outter ScrollView
//           // to do the job.
//           physics = ClampingScrollPhysics();
//         });
//       }
//     });

//     // Add a listener to the outter scroll controller.
//     _innerScrollController.addListener(() {
//       //
//       if (_innerScrollController.offset ==
//           _innerScrollController.position.minScrollExtent) {
//         setState(() {
//           // locks the ScrollView from moving allowing the outter ScrollView
//           // to do the job.
//           physics = NeverScrollableScrollPhysics();
//         });
//       }
//     });
//   }

//   // /// A widget that displays the actions a user can make on a match.
//   // /// Actions such as:
//   // ///   "Dislike",
//   // ///   "Like",
//   // ///   "Draft Message"
//   // ///
//   // /// Essentially a list of [DecisionControl] widgets to display below
//   // /// the Image Display Widget of each match.
//   // Widget _matchControls() {
//   //   return Container(
//   //     foregroundDecoration: BoxDecoration(
//   //       color: Colors.transparent,
//   //     ),
//   //     decoration: BoxDecoration(
//   //       color: Colors.white,
//   //       boxShadow: [
//   //         BoxShadow(
//   //           color: darkCardColor,
//   //           offset: Offset(0.0, 0.2),
//   //           blurRadius: 16.0,
//   //         ),
//   //       ],
//   //     ),
//   //     // A Matrial Widget is added here so as to allow the solash of the InkWell Widgets
//   //     // below this Widget in the tree to show.
//   //     //
//   //     // Note: Any Container Within the Widget tree will obscure the action of any InkWell Widget
//   //     // below such Container in the Widget tree.
//   //     child: Material(
//   //       // With this as transparent we can retain the original color of the Enclosing
//   //       // Decoration Widget.
//   //       color: Colors.transparent,
//   //       child: Row(
//   //         mainAxisAlignment: MainAxisAlignment.spaceAround,
//   //         children: [
//   //           InkWell(
//   //             borderRadius: BorderRadius.circular(15.0),
//   //             child: GlobalWidgets.imageToIcon(
//   //               BetaIconPaths.dislikeMatchIcon,
//   //               scale: 4.0,
//   //             ),
//   //             onTap: () {
//   //               // Decision.nope
//   //               currentMatchDecision(Decision.nope);
//   //             },
//   //           ),
//   //           InkWell(
//   //             borderRadius: BorderRadius.circular(15.0),
//   //             child: GlobalWidgets.imageToIcon(
//   //               BetaIconPaths.likeMatchIcon,
//   //               scale: 3.75,
//   //             ),
//   //             onTap: () {
//   //               // Decision.like
//   //               currentMatchDecision(Decision.like);
//   //             },
//   //           ),
//   //           InkWell(
//   //             borderRadius: BorderRadius.circular(15.0),
//   //             child: GlobalWidgets.imageToIcon(
//   //               BetaIconPaths.draftMesssageIcon,
//   //               scale: 4.0,
//   //             ),
//   //             onTap: () {
//   //               // Call a Function to open a chat Tab to chat with the match.
//   //               print('MAKE A DRAFT!');
//   //             },
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           FractionallySizedBox(
//             alignment: Alignment.topCenter,
//             heightFactor: 0.78,
//             widthFactor: 1.0,
//             child: Container(
//               color: Colors.white,
//               alignment: Alignment.center,
//               padding: EdgeInsets.symmetric(vertical: 16.0),
//               child: SingleChildScrollView(
//                 physics: NeverScrollableScrollPhysics(),
//                 primary: true,
//                 child: Column(
//                   children: [
//                     Text('Howdy!'),
//                     Text('Howdy!'),
//                     Text('Howdy!'),
//                     Text('Howdy!'),
//                     Text('Howdy!'),
//                     Text('Howdy!'),
//                     Text('Howdy!'),
//                     Text('Howdy!'),
//                     Text('Howdy!'),
//                     Text('Howdy!'),
//                     Text('Howdy!'),
//                     Text('Howdy!'),
//                     Text('Howdy!'),
//                     Text('Howdy!'),
//                     Text('Howdy!'),
//                     Text('Howdy!'),
//                     Text('Howdy!'),
//                     Text('Howdy!'),
//                     Text('Howdy!'),
//                     Text('Howdy!'),
//                     Text('Howdy!'),
//                     Text('Howdy!'),
//                     Text('Howdy!'),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           // FractionallySizedBox(
//           //   alignment: Alignment.bottomCenter,
//           //   heightFactor: 0.22,
//           //   widthFactor: 1.0,
//           //   child: _matchControls(),
//           // ),
//         ],
//       ),
//     );
//   }
// }

/// A Widget to display a set of images.
/// Used by the [MatchCard] widget to display images of
/// matches.
class PhotoView extends StatefulWidget {
  PhotoView({
    Key key,
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
                initialPhotoIndex <= imageUrls.length &&
                initialPhotoIndex.isEven,
            'The initialPhotoIndex cannot be "null" or negative. It must also be in the range of avaliable imageUrls (starting from `0`), Please supply a correct initialPhotoIndex or leave it as it is without supplying the parameter.'),
        assert(showCarousel != null,
            'The optional parameter `showCarousel` cannot be "null". Please set it to either true or false to either show the carousel widget or not.'),
        assert(isClickable != null,
            'The optional parameter `isClickable` cannot be "null". Please set it to either true or false to either make the PhotoView respond to touch Gestures or not.'),
        super(key: key);

  /// The index of the phot to display initially.
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
  final List<String> imageUrls;

  /// A callback with value Function.
  /// Pass a value to this parameter to get notified whenever a change
  /// occurs to the [PhotoView]'s index.
  final Function(int index) onChanged;

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
  final Widget descriptionWidget;

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
  List<Widget> imagesList;

  //
  List<CarouselDot> carouselDots;

  // holds the state of the selected photo index.
  int selectedPhotoIndex;

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
        imageIndex < widget.imageUrls.length;
        imageIndex++) {
      Image img = Image.network('http://' + widget.imageUrls[imageIndex],
          fit: BoxFit.cover);
      precacheImage(img.image, context);
      imagesList.add(img);

      // generate carousel dots.
      // carouselDots.add(
      //   CarouselDot(
      //     key: Key(
      //       imageIndex.toString(),
      //     ), // Create a Unique Key based on the index of the CarouselDots.
      //     size: widget.carouselDotSize,
      //     activeColor: widget.carouselActiveDotColor,
      //     inactiveColor: widget.carouselInactiveDotColor,
      //     isFocused: imageIndex == selectedPhotoIndex,
      //     onTap: () {
      //       moveToPhoto(imageIndex);
      //     },
      //   ),
      // );
    }
  }

  @override
  void didChangeDependencies() {
    updateImages(context);
    super.didChangeDependencies();
  }

  // void _loadImage(BuildContext context) {
  //   // The prefix part of the imageUrl. Needed for the construction of the Absolute
  //   // path of the match's profile photos.
  //   var prefixUrl = 'http://';

  //   // Iterate through the List of imageUrl given.
  //   imagesList = widget.imageUrls.map<Image>((url) {
  //     Image networkImage = Image.network(prefixUrl + url, fit: BoxFit.cover);

  //     // cache the image into memory.
  //     precacheImage(networkImage.image, context);

  //     // return the final [Image].
  //     return networkImage;
  //   }).toList();
  // }

  /// A private Function to call the onChanged Callback parameter of the [PhotoView] widget
  /// whenever a change is made to the index of the [PhotoView].
  void _indexChangeListener(int index) {
    // check if the onChanged(int) Callback parameter passed to the [PhotoView] widget
    // is not `null`.
    if (widget.onChanged != null) {
      // call the `onChanged` Function of the [PhotoView] widget.
      widget.onChanged(index);
    }
  }

  /// A convinient Function to change the current Image Displayed to
  /// the next image on the Image List.
  ///
  /// If there is no longer any next image in the List, this takes automatically
  /// change the Image Displayed back to the first image on the List.
  void _showNextImg() {
    // This prevents out of interval error.
    if (selectedPhotoIndex != widget.imageUrls.length - 1) {
      setState(() {
        // increase the photo index by one (1).
        selectedPhotoIndex += 1;

        print('GOING to Index: $selectedPhotoIndex');
      });
    } else {
      setState(() {
        // set the photo index to zero (0).
        selectedPhotoIndex = 0;

        print('GOING to Index: $selectedPhotoIndex');
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
    if (selectedPhotoIndex != 0) {
      setState(() {
        // decrease the photo index by one (1).
        selectedPhotoIndex -= 1;
      });
    } else {
      setState(() {
        // set the photo index to the last index of the image List.
        selectedPhotoIndex = widget.imageUrls.length - 1;
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
    assert(
      index != null,
      'Index cannot be null. Please pass in an appropriate value for the index.',
    );

    // check to verify that such index exists and is accepted.
    if (index <= widget.imageUrls.length - 1 && !index.isNegative) {
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
    var carousels = List.generate(widget.imageUrls.length, (index) {
      // print "generating Carousel Dots"
      // print('generating Carousel Dots! [INDEX]: $index');

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
    // } else {
    //   // return an empty Container if the above condition is `false`.
    //   return Container();
    // }
  }

  /// The Space or Area in which the image will be displayed.
  Widget _imageLayer() {
    //
    return imagesList[selectedPhotoIndex];
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

          // declare the GestureLayer of the PhotoView.
          if (widget.isClickable) _gestureLayer(),

          // We place the Description widget and the Carousel widget into a single Stack
          // So that we can apply similar constraints to the two.
          //
          // TODO: Add a more cogent explanation.
          FractionallySizedBox(
            alignment: widget.descriptionAlignment,
            // We apply the height factor given to the DescriptionStack (description + carousel).
            heightFactor: widget.descriptionHeightFraction,
            widthFactor: 1.0,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // declare the DescriptionLayer of the PhotoView.
                // This is placed above the Gesture Layer to allow
                // for Explicit Gestures.
                if (widget.descriptionWidget != null) _descriptionLayer(),

                // declare the CarouselLayer of the PhotoView.
                if (widget.showCarousel != null && widget.showCarousel)
                  _carouselLayer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A widget to indicate the index of a [PhotoView].
///
class CarouselDot extends StatelessWidget {
  const CarouselDot({
    Key key,
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
  final Color activeColor;

  /// The inactive [Color] of this Dot.
  ///
  /// Is used to paint the Dot whenever it is no more on Focus.
  final Color inactiveColor;

  /// A Function that fires when [this] is tapped.
  final void Function() onTap;

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
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      // Make the Dot appear bigger than the others when in Focus.
      size: Size.fromRadius(isFocused ? focusedSize : size),
      child: GestureDetector(
        onTap: () {
          onTap();
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
