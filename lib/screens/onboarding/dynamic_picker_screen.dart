import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/screen_size.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DynamicPickerScreen extends StatefulWidget {
  final String headline;
  final List<Widget> itemList;
  final int initialItem;
  final void Function(int)? onSelectedItemChanged;
  const DynamicPickerScreen(
      {Key? key,
      this.headline = '',
      this.itemList = const [],
      this.initialItem = 0,
      this.onSelectedItemChanged})
      : super(key: key);

  @override
  State<DynamicPickerScreen> createState() => _DynamicPickerScreenState();
}

class _DynamicPickerScreenState extends State<DynamicPickerScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return ListenerWidget(
      notifier: SettingsData.instance,
      builder: (context) {
        return Scaffold(
          backgroundColor: kBackroundThemeColor,
          body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                  child: Text(
                    widget.headline,
                    style: titleStyle,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height:
                      ScreenSize.getSize(context) == ScreenSizeCategory.small
                          ? screenHeight * 0.50
                          : screenHeight * 0.30,
                  child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                          initialItem: widget.initialItem),
                      itemExtent: 50.0,
                      onSelectedItemChanged: widget.onSelectedItemChanged,
                      children: widget.itemList),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
