import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  MessagesScreen({Key key}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with AutomaticKeepAliveClientMixin<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    // call super.build() method to facilite the preservation of our state.
    super.build(context);

    return Scaffold(
      body: Center(
        child: Text('messages screen'),
      ),
    );
  }

  @override
  // This necessarily helps to preserve the state of our App.
  bool get wantKeepAlive => true;
}
