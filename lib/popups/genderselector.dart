import 'package:flutter/material.dart';
import 'package:get/get.dart';


class GenderSelector extends StatefulWidget {
  GenderSelector({Key? key, this.selectedGender}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? selectedGender;

  @override
  _GenderSelectorState createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  String? selectedGender;
  @override
  initState(){
    super.initState();
    selectedGender=widget.selectedGender;
  }


  static const List<String> POSSIBLE_GENDERS=['Men','Women','Everyone'];

  Widget _createGenderTile(String gender){
    return ListTile(title: Text(gender),onTap: (){
      setState(() {
        selectedGender = gender;
      });
    },trailing:selectedGender==gender?Icon(Icons.check,color:Colors.redAccent):null,);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
    Get.back(result:selectedGender);
    return new Future(() => false);
    },
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('Show me:',style:TextStyle(color: Colors.black),),

          leading: IconButton(
            icon:Icon(Icons.arrow_back,color:Colors.redAccent),
            onPressed: (){
              Get.back(result: selectedGender);
            },

          ) ,
        ),
        body: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          children: POSSIBLE_GENDERS.map((gender)=>_createGenderTile(gender)).toList(),
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods
  }

  @override
  dispose(){
    super.dispose();
  }
}