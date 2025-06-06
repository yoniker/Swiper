import 'package:flutter/material.dart';

class PhotoBrowser extends StatefulWidget {
  final List<String>? photoAssetPaths;
  final int? visiblePhotoIndex;
  final bool? clickable;
  PhotoBrowser({this.photoAssetPaths, this.visiblePhotoIndex,this.clickable});

  @override
  _PhotoBrowserState createState() => _PhotoBrowserState();
}

class _PhotoBrowserState extends State<PhotoBrowser> {
  int? visiblePhotoIndex;
  late List<Image> images;

  @override
  void initState() {
    super.initState();
    visiblePhotoIndex = widget.visiblePhotoIndex;
  }

  @override
  void didUpdateWidget(PhotoBrowser oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateImages(context);
    if (widget.visiblePhotoIndex != oldWidget.visiblePhotoIndex) {
      setState(() {
        visiblePhotoIndex = widget.visiblePhotoIndex;
      });
    }
  }

  void updateImages(context){
    images = [];
    for(int imageIndex=0; imageIndex<widget.photoAssetPaths!.length; imageIndex++){
      Image img = Image.network('https://'+widget.photoAssetPaths![imageIndex],fit:BoxFit.cover);
      precacheImage(img.image, context);
      images.add(img);

    }
  }
  @override
  void didChangeDependencies() {
    updateImages(context);
    super.didChangeDependencies();
  }

  void _prevImage() {
    setState(() {
      visiblePhotoIndex = visiblePhotoIndex! > 0 ? visiblePhotoIndex! - 1 : 0;
    });
  }

  void _nextImage() {
    setState(() {
      visiblePhotoIndex = visiblePhotoIndex! < widget.photoAssetPaths!.length - 1
          ? visiblePhotoIndex! + 1
          : visiblePhotoIndex;
    });
  }

  Widget _buildPhotoControls() {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new GestureDetector(
          onTap: widget.clickable!? _prevImage:(){},
          child: new FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            alignment: Alignment.topLeft,
            child: new Container(
              color: Colors.transparent,
            ),
          ),
        ),
        new GestureDetector(
          onTap: widget.clickable!?_nextImage:(){},
          child: new FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            alignment: Alignment.topRight,
            child: new Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // Photo
        images[visiblePhotoIndex!],
        /*CachedNetworkImage(
          placeholder: (context, url) => CircularProgressIndicator(),
          imageUrl:
          widget.photoAssetPaths[visiblePhotoIndex],
            fit: BoxFit.cover
        ),*/
        // Photo indicator
        new Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: SelectedPhotoIndicator(
            photoCount: widget.photoAssetPaths!.length,
            visiblePhotoIndex: visiblePhotoIndex,
          ),
        ),
        // Photo control
        _buildPhotoControls(),
      ],
    );
  }
}

class SelectedPhotoIndicator extends StatelessWidget {
  final int? photoCount;
  final int? visiblePhotoIndex;

  SelectedPhotoIndicator({this.visiblePhotoIndex, this.photoCount});

  Widget _buildInactiveIndicator() {
    return new Expanded(
      child: new Padding(
        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
        child: new Container(
          height: 3.0,
          decoration: new BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2.5)),
        ),
      ),
    );
  }

  Widget _buildActiveIndicator() {
    return  Expanded(
      child:  Padding(
        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
        child:  Container(
          height: 3.0,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.circular(2.5),
              boxShadow: [
                 BoxShadow(
                    color: const Color(0x22000000),
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: const Offset(0.0, 1.0))
              ]),
        ),
      ),
    );
  }

  List<Widget> _buildIndicators() {
    List<Widget> indicators = [];
    for (int i = 0; i < photoCount!; i++) {
      indicators.add(i == visiblePhotoIndex
          ? _buildActiveIndicator()
          : _buildInactiveIndicator());
    }
    return indicators;
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(0.0),
      child:  Row(
        children: _buildIndicators(),
      ),
    );
  }
}
