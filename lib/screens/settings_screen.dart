import 'package:betabeta/models/settings_model.dart';
import 'package:betabeta/services/networking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SettingsScreen extends StatefulWidget {
  static String id = 'screen1';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

enum Gender{
  Men,
  Women,
  Everyone
}

extension ToDisplayString on Gender {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

class _SettingsScreenState extends State<SettingsScreen> {


  static const minAge = 18;
  static const maxAge = 75;

  Gender _currentGenderSelected = Gender.values.firstWhere((e) => e.toShortString() == SettingsData().preferredGender);

  String address;
  String groupValue = "your";

  RangeValues _ages = RangeValues(SettingsData().minAge.toDouble(), SettingsData().maxAge.toDouble());
  RangeLabels labels = RangeLabels(minAge.toString(), maxAge.toString());

  bool status = true;
  double _currentDistanceValue = 5;

  @override
  Widget build(BuildContext context) {
    String agesRangeText;
    if(_ages.start<=minAge) {
      if(_ages.end>=maxAge){
        agesRangeText = 'Any Age';
      }
      else{
        agesRangeText = 'Younger than ${_ages.end.toInt()}';
      }
    }
    else{
      if(_ages.end>=maxAge){
        agesRangeText = 'Older than ${_ages.start.toInt()}';
      }
      else{
        agesRangeText = '${_ages.start.toInt()} - ${_ages.end.toInt()}';
      }
    }

    if(_ages.start == _ages.end){
      agesRangeText = 'Exactly ${_ages.start.toInt()}';
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 20,
              ),
              Text(
                'Settings',
                style: TextStyle(color: Colors.black),
              ),
              GestureDetector(
                onTap: (){Navigator.pop(context);},
                child: Text(
                  'Done',
                  style: TextStyle(color: Colors.pink),
                ),
              ),
            ],
          ),

        ),
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  'ACCOUNT SETTINGS',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: Card(
                  margin: EdgeInsets.all(0),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      topLeft: Radius.circular(0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                flex: 0,
                                child: Text(
                                  'Phone Number',
                                  style: TextStyle(fontSize: 16),
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                style: TextStyle(color: Colors.black),
                                decoration: new InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(8),
                                  hintText: 'Enter Phone No. here',
                                  hintStyle: TextStyle(
                                      fontFamily: 'Lato-Regular',
                                      color: Colors.white,
                                      fontSize: 12),
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Connected Accounts',
                                style: TextStyle(fontSize: 16),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Email',
                                style: TextStyle(fontSize: 16),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'some_email@gmail.com',
                                    style: TextStyle(
                                        color: Colors.pink, fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: Card(
                  margin: EdgeInsets.all(0),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      topLeft: Radius.circular(0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Show me in Discovery',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              FlutterSwitch(
                                inactiveColor: Colors.grey,
                                activeColor: Colors.green,
                                width: 50.0,
                                height: 30.0,
                                valueFontSize: 0.0,
                                toggleSize: 26.0,
                                value: status,
                                borderRadius: 30.0,
                                padding: 1.0,
                                showOnOff: true,
                                onToggle: (val) {
                                  setState(() {
                                    status = val;
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 15),
                child: Text(
                  'While turned off, you will not be shown in the card stack. You can still see and chat with your matches.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                child: Text(
                  'WHERE',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0, bottom: 8),
                child: Card(
                  margin: EdgeInsets.all(0),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      topLeft: Radius.circular(0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location',
                              style: TextStyle(fontSize: 20),
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'My Current Location',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 20),
                                    ),
                                    Text(
                                      'Somewhere, Earth',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                  size: 15,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Maximum Distance',
                              style: TextStyle(fontSize: 20),
                            ),
                            Row(
                              children: [
                                Text(_currentDistanceValue.round().toString(), style: TextStyle(
                                    color: Colors.grey[600], fontSize: 16),),
                                Text(
                                  ' km',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Slider(
                          activeColor: Colors.pink,
                          value: _currentDistanceValue,
                          min: 0,
                          max: 100,
                          divisions: 1000,
                          label: _currentDistanceValue.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _currentDistanceValue = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                child: Text(
                  'WHO',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0, bottom: 8),
                child: Card(
                  margin: EdgeInsets.all(0),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      topLeft: Radius.circular(0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left:8.0, right: 8, top:0, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top:16.0),
                              child: Text(
                                'Gender',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            DropdownButton<Gender>(
                              items: Gender.values.map((Gender dropDownStringItem) {
                                return DropdownMenuItem<Gender>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem.toShortString(), style: TextStyle(color: Colors.grey[600], fontSize: 16),),
                                );
                              }).toList(),
                              onChanged: (Gender newValueSelected){
                                setState(() {
                                  SettingsData().preferredGender = newValueSelected.toShortString();
                                  this._currentGenderSelected = newValueSelected;
                                });
                              },
                              value: _currentGenderSelected,
                            ),
                          ],
                        ),
                        Divider(),
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Text(
                                  "Age",
                                  style: TextStyle(
                                    fontSize: 20,),
                                ),

                              ],
                            ),
                            Text(
                              agesRangeText,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 0,
                                      child: Text(
                                        _ages.start.toInt().toString(),
                                        style: TextStyle(
                                          color: Colors.pink,
                                          fontSize: 15,
                                        ),
                                      )),
                                  Expanded(
                                    child: RangeSlider(
                                      activeColor: Colors.pink,
                                      min: minAge.toDouble(),
                                      max: maxAge.toDouble(),
                                      values: _ages,
                                      divisions: 1000,
                                      labels: labels,
                                      onChanged: (value) {

                                        print('START: ${value.start}, END: ${value.end}');
                                        setState(() {
                                          SettingsData().minAge = value.start.toInt();
                                          SettingsData().maxAge = value.end.toInt();
                                          String endString = value.end.toInt()<maxAge?value.end.toInt().toString():'$maxAge+';
                                          _ages = value;
                                          labels = RangeLabels(
                                              '${value.start.toInt().toString()}',
                                              '$endString');
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                      flex: 0,
                                      child: Text(
                                          _ages.end.toInt()<75?_ages.end.toInt().toString():'75+',
                                        style: TextStyle(
                                          color: Colors.pink,
                                          fontSize: 15,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            TextButton(onPressed: (){NetworkHelper().postUserSettings();}, child: Text('Update server'))
            ],

          ),
        ),
      ),
    );
  }

  valueChanged(e) {
    setState(() {
      if (e == 'your') {
        groupValue = e;
        address = e;
      } else if (e == 'their') {
        groupValue = e;
        address = e;
      } else if (e == 'mixture') {
        groupValue = e;
        address = e;
      }
    });
  }
}
