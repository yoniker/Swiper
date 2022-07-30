import 'package:flutter/material.dart';

class CustomScrollViewTakesAllAvailableSpace extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final CrossAxisAlignment crossAxisAlignment;
  const CustomScrollViewTakesAllAvailableSpace(
      {Key? key,
      required this.children,
      required this.padding,
      this.crossAxisAlignment = CrossAxisAlignment.start})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Expanded(
      child: Padding(
        padding: padding,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: RawScrollbar(
            controller: scrollController,
            thumbColor: Colors.black87,
            trackVisibility: true,
            trackRadius: Radius.circular(20),
            trackColor: Colors.red,
            radius: Radius.circular(20),
            thumbVisibility: true,
            child: CustomScrollView(
              controller: scrollController,
              primary: false,
              scrollDirection: Axis.vertical,
              reverse: false,
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: crossAxisAlignment,
                    children: children,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
