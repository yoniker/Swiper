import 'package:flutter/material.dart';

class BouncingButton extends StatefulWidget {
  final bool shouldBounce;
  final List<Color> gradientColors;
  final bool isActive;
  final double height;
  final double width;
  final Duration duration;
  final GestureTapCallback? onTap;
  final Widget child;

  const BouncingButton({Key? key,required this.shouldBounce, required this.gradientColors, required this.height,required  this.width,required this.duration,required this.isActive, this.onTap, required this.child}) : super(key: key);



  @override
  _BouncingButtonState createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<BouncingButton> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {});
    });
    if(widget.shouldBounce) {
      _controller.repeat(reverse: true);
    }
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();

  }


  @override
  void didUpdateWidget(covariant BouncingButton oldWidget) {
    if(widget.shouldBounce) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
    }
    super.didUpdateWidget(oldWidget);
  }


  @override
  Widget build(BuildContext context) {
    double _scale = 1 - _controller.value;
    return Transform.scale(
      scale: _scale,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            boxShadow: widget.isActive?[
              BoxShadow(
                color: Color(0x80000000),
                blurRadius: 12.0,
                offset: Offset(0.0, 5.0),
              ),
            ]:[],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.gradientColors,
            )),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(100.0),
            onTap: widget.isActive? widget.onTap:null,
            child: Center(
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
