// import 'package:betabeta/constants/beta_icon_paths.dart';
// import 'package:betabeta/services/aws_networking.dart';
// import 'package:betabeta/services/settings_model.dart';
// import 'package:betabeta/widgets/custom_app_bar.dart';
// import 'package:betabeta/widgets/custom_scrollview_take_all_available_space.dart';
// import 'package:betabeta/widgets/global_widgets.dart';
// import 'package:betabeta/widgets/pre_cached_image.dart';
// import 'package:extended_image/extended_image.dart';
// import 'package:flutter/material.dart';
//
// class MockNewMatchCardPage extends StatefulWidget {
//   static const String routePage = '/new_mock_page';
//   const MockNewMatchCardPage({Key? key}) : super(key: key);
//
//   @override
//   State<MockNewMatchCardPage> createState() => _MockNewMatchCardPageState();
// }
//
// class _MockNewMatchCardPageState extends State<MockNewMatchCardPage> {
//   @override
//   Widget build(BuildContext context) {

// List<Widget> children = [];
// for (var x = 0; x < 50; x++) {
//   children.add(
//     Center(
//         child: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Text('$x'),
//     )),
//   );
// }
// return Scaffold(
//   body: SafeArea(
//     child: Stack(
//       alignment: Alignment.bottomLeft,
//       children: [
//         Column(
//           children: [
//             CustomScrollViewTakesAllAvailableSpace(
//                 children: children, padding: EdgeInsets.zero),
//           ],
//         ),
//         SafeArea(
//           child: AnimatedScale(
//             scale: 3,
//             duration: Duration(milliseconds: 300),
//             child: ProfileImageAvatar(
//                 imageProvider: ExtendedNetworkImageProvider(
//                     AWSServer.getProfileImageUrl(
//                         SettingsData.instance.profileImagesUrls.first),
//                     cache: true)),
//           ),
//         )
//       ],
//     ),
//   ),
// );
//   }
// }

import 'dart:math' as math;
import 'dart:ui';

import 'package:betabeta/constants/assets_paths.dart';
import 'package:flutter/material.dart';

class MockNewMatchCardPage extends StatefulWidget {
  static const routePage = '/mock_page';
  @override
  State createState() => MockNewMatchCardPageState();
}

class MockNewMatchCardPageState extends State<MockNewMatchCardPage> {
  static const double kExpandedHeight = 400.0;

  static const double kInitialSize = 75.0;

  static const double kFinalSize = 30.0;

  static const List<String> kPicturePath = [
    AssetsPaths.customPicFilterSearchPic,
    AssetsPaths.celebSearchPic,
    AssetsPaths.editProfilePicture,
    AssetsPaths.tasteSearchPic,
    AssetsPaths.theirTasteSearchPic,
    AssetsPaths.Woman1Swipe,
  ];

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      setState(() {/* State being set is the Scroll Controller's offset */});
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    double size = !_scrollController.hasClients || _scrollController.offset == 0
        ? 75.0
        : 75 -
            math.min(
                45.0,
                (45 /
                    kExpandedHeight *
                    math.min(_scrollController.offset, kExpandedHeight) *
                    1.5));

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: kExpandedHeight,
            title: Text("Title!"),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(55),
              child: buildAppBarBottom(size),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(title: Text('Item $index'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAppBarBottom(double size) {
    double t = (size - kInitialSize) / (kFinalSize - kInitialSize);

    const double initialContainerHeight = 2 * kInitialSize;
    const double finalContainerHeight = kFinalSize;

    return Container(
      height: lerpDouble(initialContainerHeight, finalContainerHeight, t),
      child: LayoutBuilder(
        builder: (context, constraints) {
          List<Widget> stackChildren = [];
          for (int i = 0; i < 6; i++) {
            Offset offset = getInterpolatedOffset(i, constraints, t);
            stackChildren.add(Positioned(
              left: offset.dx,
              top: offset.dy,
              child: buildSizedBox(size, kPicturePath[i]),
            ));
          }

          return Stack(children: stackChildren);
        },
      ),
    );
  }

  Offset getInterpolatedOffset(
      int index, BoxConstraints constraints, double t) {
    Curve curve = Curves.linear;
    double curveT = curve.transform(t);

    Offset a = getOffset(index, constraints, kInitialSize, 3);
    Offset b = getOffset(index, constraints, kFinalSize, 6);

    return Offset(
      lerpDouble(a.dx, b.dx, curveT)!,
      lerpDouble(a.dy, b.dy, curveT)!,
    );
  }

  Offset getOffset(
      int index, BoxConstraints constraints, double size, int columns) {
    int x = index % columns;
    int y = index ~/ columns;
    double horizontalMargin = (constraints.maxWidth - size * columns) / 2;

    return Offset(horizontalMargin + x * size, y * size);
  }

  Widget buildSizedBox(double size, String assetImage) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(assetImage),
        ),
      ),
    );
  }
}
