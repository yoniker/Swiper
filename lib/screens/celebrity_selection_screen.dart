import 'dart:async';

import 'package:betabeta/data_models/celeb.dart';
import 'package:betabeta/models/celebs_info_model.dart';
import 'package:betabeta/widgets/celeb_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ScreenCelebritySelection extends StatefulWidget {
  static const String routeName = '/celebrity_select_screen';
  @override
  _ScreenCelebritySelectionState createState() => _ScreenCelebritySelectionState();
}

class _ScreenCelebritySelectionState extends State<ScreenCelebritySelection> {
  Timer _debounce; //Define debounce, see https://stackoverflow.com/questions/51791501/how-to-debounce-textfield-onchange-in-dart
  TextEditingController _controller = TextEditingController();

  _onSearchChanged(String query,CelebsInfo celebInfo) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      celebInfo.sortListByKeywords(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void unfocus(){

    FocusScopeNode currentFocus = FocusScope.of(context); //Dismiss the keyboard, see https://flutterigniter.com/dismiss-keyboard-form-lose-focus/

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }


  @override
  Widget build(BuildContext context) {
    return
      Consumer<CelebsInfo>(
          builder: (context, celebInfo, child) {
            int _numCelebsToShow = 0;
            if(celebInfo.infoLoadedFromDatabase()){
              _numCelebsToShow = celebInfo.entireCelebsList.length;
            }
            return Scaffold(
                backgroundColor: Color(0xff681B17),
                body:
                SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [Flexible(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.all(10.0),
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  suffixIcon: IconButton(icon:Icon(Icons.close),onPressed: (){
                                    _controller.clear();
                                    _onSearchChanged('', celebInfo);
                                  },iconSize: 30.0,),
                                  prefixIcon: IconButton(icon: Icon(Icons.search),onPressed: unfocus,iconSize: 30.0,),


                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  hintText: 'Enter Celeb Name Here'

                              ),
                              onChanged: (String newText){_onSearchChanged(newText,celebInfo);},
                            ),
                          ),
                        ),
                        ],
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          child: ListView.separated(
                            physics:BouncingScrollPhysics(),
                            separatorBuilder:(BuildContext context, int index){
                              return SizedBox(height:15.0);
                            },

                            itemCount:_numCelebsToShow,
                            itemBuilder:(BuildContext context, int index){
                              Celeb currentCeleb = celebInfo.entireCelebsList[index];
                              return CelebWidget(theCeleb:currentCeleb,celebsInfo:celebInfo,onTap:(){
                                print('Main celeb widget got ${currentCeleb.celebName}');
                                Navigator.pop(context, currentCeleb);
                              },);
                            },


                          ),
                        ),
                      )
                    ],

                  ),
                )
            );
          }
      );}



}

