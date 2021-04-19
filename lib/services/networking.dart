
import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;
import 'package:betabeta/models/match_engine.dart';
import 'package:betabeta/models/settings_model.dart';
import 'package:http/http.dart' as http;
import 'package:betabeta/models/profile.dart';
import 'dart:convert';
import 'dart:convert' as json;
import 'package:http_parser/src/media_type.dart' as media;
import 'package:tuple/tuple.dart';

class NetworkHelper{
  static const SERVER_ADDR='192.116.48.67:8082';
  static final NetworkHelper _instance = NetworkHelper._internal();
  static const MIN_MATCHES_CALL_INTERVAL = Duration(seconds: 1);
  DateTime _lastMatchCall=DateTime(2000); //The year 2000 is when the last call happened :D
  DateTime _lastFacesImagesCall=DateTime(2000);
  Future<http.Response> _facesCall;
  static const MIN_FACES_CALL_INTERVAL = Duration(milliseconds: 500);

  factory NetworkHelper() {
    return _instance;
  }

  NetworkHelper._internal();

  static Future<List<String>> getCeleblinks(String celebName)async{
    Uri celebsLinkUri = Uri.http(SERVER_ADDR, 'celeblinks/$celebName');
    http.Response resp = await http.get(celebsLinkUri);
    if(resp.statusCode==200){ //TODO think how to handle network errors
      var parsed = json.jsonDecode(resp.body);
      List<String> imagesLinks = parsed.cast<String>();
      return imagesLinks;
    }

    return [];
  }

  static String faceUrlToFullUrl(String faceUrl){
    return 'http://'+NetworkHelper.SERVER_ADDR+'/'+ faceUrl;
  }



  //getMatches: Grab some matches and image links from the server
  dynamic getMatches() async {
    if(DateTime.now().difference(_lastMatchCall) < MIN_MATCHES_CALL_INTERVAL){
      await Future.delayed(MIN_MATCHES_CALL_INTERVAL - DateTime.now().difference(_lastMatchCall));
    }
    SettingsData settings = SettingsData();
    String userName = settings.facebookId ?? 'SOMEUSER'; //TODO Login screen if the username in sharedprefs is null
    _lastMatchCall = DateTime.now();
    Uri matchesUrl = Uri.http(SERVER_ADDR, '/matches/$userName');
    http.Response response=await http.get(matchesUrl); //eg /12313?gender=Male
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
    Uri postDecisionUri = Uri.http(SERVER_ADDR, '/decision/${settings.facebookId}');
    http.Response response = await http.post(postDecisionUri,body:encoded); //TODO something if response wasnt 200

  }


  postUserSettings()async{
    SettingsData settings = SettingsData();
    Map<String,String> toSend = {'decider_facebook_id':settings.facebookId,'update_date':'8.0','decider_name':settings.name,'min_age':settings.minAge.toString(),'max_age':settings.maxAge.toString(),'gender_preferred':settings.preferredGender,
      SettingsData.FILTER_NAME_KEY:settings.filterName,
      SettingsData.AUDITION_COUNT_KEY:settings.auditionCount.toString(),
      SettingsData.TASTE_MIX_RATIO_KEY:settings.tasteMixRatio.toString(),
      SettingsData.CELEB_ID_KEY:settings.celebId,
      SettingsData.FILTER_DISPLAY_IMAGE_URL_KEY :settings.filterDisplayImageUrl,
      SettingsData.RADIUS_KEY :settings.radius.toString()



    };
    String encoded = jsonEncode(toSend);
    Uri postSettingsUri = Uri.http(SERVER_ADDR, '/settings/${settings.facebookId}');
    http.Response response = await http.post(postSettingsUri,body:encoded); //TODO something if response wasnt 200

    }

  Future<HashMap<String,dynamic>> getFacesLinks({String imageFileName,String userId})async{
    if(_facesCall!=null){return HashMap();}
    Uri facesLinkUri = Uri.http(SERVER_ADDR, 'faces/$userId/$imageFileName');
    _facesCall = http.get(facesLinkUri);
    if(DateTime.now().difference(_lastFacesImagesCall) < MIN_FACES_CALL_INTERVAL){
      await Future.delayed(MIN_FACES_CALL_INTERVAL - DateTime.now().difference(_lastFacesImagesCall));
    }
    _lastFacesImagesCall = DateTime.now();
    http.Response response = await _facesCall; //TODO something if error
    dynamic facesData=jsonDecode(response.body);
    _facesCall = null;
    return HashMap.from(facesData);

  }

  Tuple2<img.Image, String> preparedImageFileDetails(File imageFile){
    const MAX_IMAGE_SIZE = 800;

    img.Image theImage = img.decodeImage(imageFile.readAsBytesSync());
    if(max(theImage.height, theImage.width)>MAX_IMAGE_SIZE){
      double resizeFactor = MAX_IMAGE_SIZE/max(theImage.height, theImage.width);
      theImage = img.copyResize(theImage, width: (theImage.width*resizeFactor).round(),height: (theImage.height*resizeFactor).round());
    }
    String fileName = 'custom_face_search_${DateTime.now()}.jpg';
    return Tuple2<img.Image, String>(theImage,fileName);

  }

  Future<void> postImage(Tuple2<img.Image, String> imageFileDetails)async{
    img.Image theImage = imageFileDetails.item1;
    String fileName = imageFileDetails.item2;



    http.MultipartRequest request = http.MultipartRequest(
      'POST',
      Uri.http(SERVER_ADDR, '/upload/${SettingsData().facebookId}'),
    );
    var multipartFile = new http.MultipartFile.fromBytes(
      'file',
      img.encodeJpg(theImage),
      filename: fileName,
      contentType: media.MediaType.parse('image/jpeg'),
    );
    request.files.add(multipartFile);
    var response = await request.send(); //TODO something if response wasn't 200
    return;
  }




}