import 'package:flutter/material.dart';

class CustomScrollViewTakesAllAvailableSpace extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  const CustomScrollViewTakesAllAvailableSpace(
      {Key? key, required this.children, required this.padding})
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
          child: Scrollbar(
            controller: scrollController,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
