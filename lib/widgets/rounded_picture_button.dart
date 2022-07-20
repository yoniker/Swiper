import 'package:flutter/material.dart';

class RoundedPictureButton extends StatelessWidget {
  final ImageProvider image;
  final Widget child;
  final double width;
  final double height;
  final void Function()? onTap;
  final BorderRadiusGeometry? borderRadius;
  const RoundedPictureButton({
    Key? key,
    required this.image,
    required this.child,
    required this.onTap,
    this.width = 300,
    this.height = 80,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(40),
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.white),
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
            image: DecorationImage(
              image: image,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.75), BlendMode.dstATop),
            ),
            borderRadius: borderRadius),
        child: Center(child: child),
      ),
    );
  }
}
