import 'package:flutter/material.dart';

class RoundedPictureButton extends StatelessWidget {
  final ImageProvider image;
  final Widget child;
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final void Function()? onTap;
  final BoxFit? fit;
  final BorderRadiusGeometry? borderRadius;
  const RoundedPictureButton({
    Key? key,
    required this.image,
    required this.child,
    required this.onTap,
    this.fit = BoxFit.cover,
    this.padding = const EdgeInsets.symmetric(vertical: 5),
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
        margin: padding,
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
              fit: fit,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.75), BlendMode.dstATop),
            ),
            borderRadius: borderRadius),
        child: Center(child: child),
      ),
    );
  }
}
