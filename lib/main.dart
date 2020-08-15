import 'package:flutter/material.dart';

import 'matching_screen.dart';


void main()  {
  runApp(MyApp());}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColorBrightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home:
        LoginHome(),
      //MatchingScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

class LoginHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlineButton(
                child:Text('Click me!'),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => MatchingScreen(title: 'Flutter Demo Home Page')

                  ));
                },
              )
            ],
          ),
        )

    );
  }


}