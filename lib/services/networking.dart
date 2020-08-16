
import 'package:betabeta/user_profile.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:betabeta/profiles.dart';
import 'dart:convert';

import '../matches.dart';
class NetworkHelper{
  static const SERVER_ADDR='http://10.0.0.22:8081'; //TODO this is a local address,replace with a real external ip
  //getMatches: Grab some matches and image links from the server
  dynamic getMatches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String preferredGenderSaved = prefs.getString('preferredGender');
    if(preferredGenderSaved==null){preferredGenderSaved='Everyone';}
    String userName = prefs.getString('username') ?? 'SOMEUSER'; //TODO Login screen if the username in sharedprefs is null
    http.Response response=await http.get(NetworkHelper.SERVER_ADDR+'/matches/$userName?gender=$preferredGenderSaved');
    if (response.statusCode!=200){
      return null; //TODO error handling
    }

    dynamic listProfiles=jsonDecode(response.body);
    return listProfiles;
  }

  static List<String> serverImagesUrl(List<String> imagesUrls){
    return imagesUrls.map((val){return NetworkHelper.SERVER_ADDR+'/images/'+val;}).toList();
  }


  postUserDecision({FacebookProfile userProfile,Decision decision,Profile otherUserProfile})async{
    print('at post decision is $decision');
    print('at post other is $otherUserProfile');
    print('at post user profile is $userProfile');
    Map<String,String> toSend = {'username':otherUserProfile.username,'decision':decision.toString().substring("Decision.".length,decision.toString().length)};
    String encoded = jsonEncode(toSend);
    http.Response response = await http.post(SERVER_ADDR+'/decision/${userProfile.facebookId}',body:encoded);
    print('dor');

  }


}