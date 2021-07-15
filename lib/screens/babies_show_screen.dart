import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class BabiesShowScreen extends StatefulWidget {
  static const String routeName = '/babies_show_screen';
  @override
  _BabiesShowScreenState createState() => _BabiesShowScreenState();
}

class _BabiesShowScreenState extends State<BabiesShowScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title:'Show babies',trailing: Text('Icon Here'),hasTopPadding:true),
      body:
        Column(
          children:
          [Text('Dor is the only king'),]
        )
    );
  }
}
