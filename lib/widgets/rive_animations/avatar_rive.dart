import 'package:betabeta/constants/app_functionality_consts.dart';
import 'package:betabeta/constants/assets_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class AvatarRive extends StatefulWidget {
  final String artBoard;
  final String? eyesColor;
  final String? hairColor;
  final bool darkSkin;
  final bool glasses;
  const AvatarRive(
      {Key? key,
      required this.artBoard,
      this.eyesColor,
      this.hairColor,
      this.darkSkin = false,
      this.glasses = false})
      : super(key: key);

  @override
  State<AvatarRive> createState() => _AvatarRiveState();
}

class _AvatarRiveState extends State<AvatarRive> {
  SMIBool? _isPlaying;
  SMINumber? _lookPercent;
  final List<String> animations = [kAvatarIdleAnimation];

  void _onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State_Machine');

    artboard.addController(controller!);

    _isPlaying = controller.findInput<bool>('isChecking') as SMIBool?;
    _lookPercent = controller.findSMI('numLook') as SMINumber?;
  }

  @override
  void initState() {
    if (widget.eyesColor != null && widget.eyesColor != '') {
      animations.add(widget.eyesColor!);
    }
    if (widget.hairColor != null && widget.hairColor != '') {
      animations.add(widget.hairColor!);
    }
    if (widget.darkSkin == true) {
      animations.add(kAvatarDarkSkin);
    }
    if (widget.glasses == true) {
      animations.add(kAvatarGlasses);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        if (_isPlaying?.value != null) {
          _isPlaying?.value = !_isPlaying!.value;
        }
      },
      onHorizontalDragStart: (DragStartDetails details) {
        _lookPercent!.value = details.globalPosition.dx / screenWidth * 100;
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        _lookPercent!.value = details.globalPosition.dx / screenWidth * 100;
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: kBackroundThemeColor,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(500, 110),
          ),
        ),
        child: RiveAnimation.asset(
          AssetsPaths.riveAvatarsPath,
          artboard: widget.artBoard,
          animations: animations,
          stateMachines: ['State_Machine'],
          onInit: _onRiveInit,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
