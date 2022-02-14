import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChoiceButton extends StatelessWidget {
  ChoiceButton(
      {this.elvation = 3.0,
      required this.name,
      this.color = Colors.white,
      required this.onTap,
      this.addControlerAnimation = 1,
      this.pressed = false});

  bool pressed;
  double elvation;
  final String? name;
  final Color? color;
  void Function()? onTap;
  double addControlerAnimation = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: pressed == true ? 1 : 6,
      color: pressed == true ? Colors.white.withOpacity(0.94) : color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        side: BorderSide(
            color: pressed == true ? Colors.black : Colors.black38,
            width: pressed == true ? 1.7 : 1.5),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: 20, vertical: pressed == true ? 16 : 18),
      onPressed: onTap,
      minWidth: addControlerAnimation * MediaQuery.of(context).size.width,
      height: addControlerAnimation * MediaQuery.of(context).size.height * 0.04,
      child: Text(
        name!,
        style: TextStyle(
            color: pressed != false ? Colors.black : GetColor(color),
            fontSize: 20,
            fontWeight: pressed == true ? FontWeight.w600 : null),
      ),
    );
  }
}

Color GetColor(Color? color) {
  if (color == Colors.white) {
    return Colors.black38;
  } else if (color == Colors.grey.withOpacity(0.6)) {
    return Colors.black45;
  } else {
    return Colors.white;
  }
}
