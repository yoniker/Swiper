
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class NetworkHelper{
  static const SERVER_ADDR='http://10.0.0.22:8081'; //TODO this is a local address,replace with a real external ip
  //getMatches: Grab some matches and image links from the server
  dynamic getMatches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString('username') ?? 'SOMEUSER'; //TODO Login screen if the username is sharedprefs is null
    http.Response response=await http.get(NetworkHelper.SERVER_ADDR+'/matches/$userName');
    if (response.statusCode!=200){
      return null; //TODO error handling
    }

    dynamic listProfiles=jsonDecode(response.body);
    return listProfiles;
  }

  static List<String> serverImagesUrl(List<String> imagesUrls){
    return imagesUrls.map((val){return NetworkHelper.SERVER_ADDR+'/images/'+val;}).toList();
  }


}