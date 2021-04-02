
import 'dart:async';

import 'package:betabeta/models/match_engine.dart';
import 'package:betabeta/models/settings_model.dart';
import 'package:http/http.dart' as http;
import 'package:betabeta/models/profile.dart';
import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class NetworkHelper{
  static const SERVER_ADDR='http://192.116.48.67:8081/';
  static final NetworkHelper _instance = NetworkHelper._internal();
  static const MIN_MATCHES_CALL_INTERVAL = Duration(seconds: 1);
  DateTime _lastMatchCall=DateTime(2000);

  factory NetworkHelper() {
    return _instance;
  }

  NetworkHelper._internal();
  //getMatches: Grab some matches and image links from the server
  dynamic getMatches() async {
    if(DateTime.now().difference(_lastMatchCall) < MIN_MATCHES_CALL_INTERVAL){
      await Future.delayed(MIN_MATCHES_CALL_INTERVAL - DateTime.now().difference(_lastMatchCall));
    }
    SettingsData settings = SettingsData();
    String query = getQueryFromSettings();
    String userName = settings.facebookId ?? 'SOMEUSER'; //TODO Login screen if the username in sharedprefs is null
    _lastMatchCall = DateTime.now();
    http.Response response=await http.get(NetworkHelper.SERVER_ADDR+'/matches/$userName$query'); //eg /12313?gender=Male
    if (response.statusCode!=200){
      return null; //TODO error handling
    }

    dynamic listProfiles=jsonDecode(response.body);
    return listProfiles;
  }

  static List<String> serverImagesUrl(List<String> imagesUrls){
    return imagesUrls.map((val){return NetworkHelper.SERVER_ADDR+'/images/'+val;}).toList();
  }


  postUserDecision({Decision decision,Profile otherUserProfile})async{
    SettingsData settings = SettingsData();
    if(true){print('TODO fix the profile @matchEngine stuff'); return;}
    Map<String,String> toSend = {'deciderName':settings.name,'decidee':otherUserProfile.username,'decision':decision.toString().substring("Decision.".length,decision.toString().length)};
    String encoded = jsonEncode(toSend);
    http.Response response = await http.post(SERVER_ADDR+'/decision/${settings.facebookId}',body:encoded); //TODO something if response wasnt 200

  }


  postUserSettings()async{
    SettingsData settings = SettingsData();
    Map<String,String> toSend = {'decider_facebook_id':settings.facebookId,'update_date':'8.0','decider_name':settings.name,'min_age':settings.minAge.toString(),'max_age':settings.maxAge.toString(),'gender_preferred':settings.preferredGender};
    String encoded = jsonEncode(toSend);
    http.Response response = await http.post(SERVER_ADDR+'/settings/${settings.facebookId}',body:encoded); //TODO something if response wasnt 200

    }

  void prefetchImages(List<String> imagesUrls){
    for(String imageUrl in imagesUrls){
      String actualUrl=NetworkHelper.SERVER_ADDR+'/images/'+ imageUrl;
      DefaultCacheManager().getSingleFile(actualUrl);

      //CachedNetworkImageProvider(actualUrl);
    }
  }

  static String getQueryFromSettings(){
    SettingsData settings = SettingsData();
    if(!settings.readFromShared){
      return '';
    }

    String queryGenderString;
    switch(settings.preferredGender){
      case 'Women':
        queryGenderString='Female';
        break;
      case 'Men':
        queryGenderString='Male';
        break;
      case 'Everyone':
        queryGenderString='Everyone';
        break;
      default:
        queryGenderString='Female';
        break;


    }
    return '?gender=$queryGenderString';
  }




}