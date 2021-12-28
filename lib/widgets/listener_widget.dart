import 'package:flutter/material.dart';

//A class which makes it easier to worker with change notifier without provider/consumer which looks wrong since changenotifier shouldn't be forced into widgets tree for no reason
//eg widgets should represent UI and not business logic


class ListenerWidget extends StatefulWidget {
  const ListenerWidget({Key? key,required ChangeNotifier notifier,required Widget Function(BuildContext) builder,void Function()? action}) : notifier=notifier,builder=builder,action=action,super(key: key);
  final Widget Function(BuildContext) builder;
  final ChangeNotifier notifier;
  final void Function()? action;

  @override
  _ListenerWidgetState createState() => _ListenerWidgetState();
}

class _ListenerWidgetState extends State<ListenerWidget> {

  void emptyListener(){
    setState(() {

    });
  }

  @override
  void initState() {
    widget.notifier.addListener(widget.action??emptyListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.notifier.removeListener(widget.action??emptyListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
