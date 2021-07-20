import 'package:flutter/material.dart';

class ViewLikesScreen extends StatefulWidget {
  ViewLikesScreen({Key key}) : super(key: key);
  static const String routeName = '/view_likes';

  @override
  _ViewLikesScreenState createState() => _ViewLikesScreenState();
}

class _ViewLikesScreenState extends State<ViewLikesScreen>
    with AutomaticKeepAliveClientMixin<ViewLikesScreen> {
  @override
  Widget build(BuildContext context) {
    // call super.build() method to facilite the preservation of our state.
    super.build(context);

    return Scaffold(
      body: Center(
        child: Text('view-likes screen'),
      ),
    );
  }

  @override
  // This necessarily helps to preserve the state of our App.
  bool get wantKeepAlive => true;
}
