import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class FemaleAvatarRive extends StatefulWidget {
  const FemaleAvatarRive({Key? key}) : super(key: key);

  @override
  State<FemaleAvatarRive> createState() => _FemaleAvatarRiveState();
}

class _FemaleAvatarRiveState extends State<FemaleAvatarRive> {
  SMIBool? _isPlaying;

  void _onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State_Machine');

    artboard.addController(controller!);

    _isPlaying = controller.findInput<bool>('isChecking') as SMIBool?;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _playArtBoard?.forEachComponent(
    //   (child) {
    //     if (child is Shape) {
    //       final Shape shape = child;
    //       if (child.name == 'Hair' || child.name == 'Pony') {
    //         (shape.fills.first.children[0] as SolidColor).colorValue =
    //             (Colors.black).value;
    //       }
    //       //shape.fills.first.paint.color = Colors.red;
    //     }
    //   },
    // );
    return GestureDetector(
      onTap: () {
        if (_isPlaying?.value != null) {
          _isPlaying?.value = !_isPlaying!.value;
        }
      },
      child: RiveAnimation.asset(
        'assets/rive/female_avatar2.riv',
        artboard: 'WomanArtboard',
        animations: ['Idle', 'HairColorBlack'],
        stateMachines: ['State_Machine'],
        onInit: _onRiveInit,
        fit: BoxFit.contain,
      ),
    );
  }
}
