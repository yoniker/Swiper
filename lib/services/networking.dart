
import 'package:betabeta/matches.dart';
import 'package:betabeta/search_preferences.dart';
import 'package:betabeta/user_profile.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:betabeta/profiles.dart';
import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class NetworkHelper{
  static const SERVER_ADDR='http://62.90.219.93:8081';
  //getMatches: Grab some matches and image links from the server
  dynamic getMatches({bool discardIfPreferencesChanged=true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SearchPreferences userPreferences = SearchPreferences.fromSharedPreferences(prefs);
    String query = getQueryFromPreferences(userPreferences);
    String userName = prefs.getString('facebook_id') ?? 'SOMEUSER'; //TODO Login screen if the username in sharedprefs is null
    http.Response response=await http.get(NetworkHelper.SERVER_ADDR+'/matches/$userName$query'); //eg /12313?gender=Male
    if (discardIfPreferencesChanged){
      SearchPreferences userCurrentPreferences = SearchPreferences.fromSharedPreferences(prefs);
      if(userCurrentPreferences!=userPreferences){
        return [];
      }
    }
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
    Map<String,String> toSend = {'deciderName':userProfile.name,'decidee':otherUserProfile.username,'decision':decision.toString().substring("Decision.".length,decision.toString().length)};
    String encoded = jsonEncode(toSend);
    http.Response response = await http.post(SERVER_ADDR+'/decision/${userProfile.facebookId}',body:encoded); //TODO something if response wasnt 200

  }

  void prefetchImages(List<String> imagesUrls){
    for(String imageUrl in imagesUrls){
      String actualUrl=NetworkHelper.SERVER_ADDR+'/images/'+ imageUrl;
      DefaultCacheManager().getSingleFile(actualUrl);

      //CachedNetworkImageProvider(actualUrl);
    }
  }

  static String getQueryFromPreferences(SearchPreferences searchPreferences){
    if(searchPreferences.genderPreferred==null || searchPreferences.genderPreferred.length==0){
      return '';
    }

    String queryGenderString;
    switch(searchPreferences.genderPreferred){
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