import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:convert' as json;
import 'dart:math';

import 'package:betabeta/models/profile.dart';
import 'package:betabeta/services/match_engine.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/models/userid.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/src/media_type.dart' as media;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tuple/tuple.dart';

enum NetworkTaskStatus {
  completed,
  inProgress,
  notExist
} //possible statuses for long ongoing tasks on the server

class NetworkHelper {
  static const SERVER_ADDR = 'dordating.com:8081';
  static final NetworkHelper _instance = NetworkHelper._internal();
  static const MIN_MATCHES_CALL_INTERVAL = Duration(seconds: 1);
  static const MIN_TASK_STATUS_CALL_INTERVAL = Duration(seconds: 1);
  static const ALL_USER_IMAGES = 'all_user_images';
  DateTime _lastMatchCall =
      DateTime(2000); //The year 2000 is when the last call happened :D
  DateTime _lastFacesImagesCall = DateTime(2000);
  DateTime _lastTaskStatusCall = DateTime(2000);
  Future<http.Response>? _facesCall;
  static const MIN_FACES_CALL_INTERVAL = Duration(milliseconds: 500);

  factory NetworkHelper() {
    return _instance;
  }

  NetworkHelper._internal();

  static Future<List<String>> getCeleblinks(String? celebName) async {
    Uri celebsLinkUri = Uri.https(SERVER_ADDR, 'celeblinks/$celebName');
    http.Response resp = await http.get(celebsLinkUri);
    if (resp.statusCode == 200) {
      //TODO think how to handle network errors
      var parsed = json.jsonDecode(resp.body);
      List<String> imagesLinks = parsed.cast<String>();
      return imagesLinks;
    }

    return [];
  }

  // static String faceUrlToFullUrl(String faceUrl) {
  //   return 'https://' + NetworkHelper.SERVER_ADDR + '/' + faceUrl;
  // }

  // static List<Image> serverImagesUrlsToImages(
  //     List<String> facesUrls, BuildContext context) {
  //   List<Image> facesImages = [];
  //   for (int imageIndex = 0; imageIndex < facesUrls.length; imageIndex++) {
  //     String url = NetworkHelper.faceUrlToFullUrl(facesUrls[imageIndex]);
  //     Image img = Image.network(url, fit: BoxFit.cover);
  //     precacheImage(img.image, context);
  //     facesImages.add(img);
  //   }
  //   return facesImages;
  // }

  //getMatches: Grab some matches and image links from the server
  dynamic getMatches() async {
    if (DateTime.now().difference(_lastMatchCall) < MIN_MATCHES_CALL_INTERVAL) {
      await Future.delayed(MIN_MATCHES_CALL_INTERVAL -
          DateTime.now().difference(_lastMatchCall));
    }
    _lastMatchCall = DateTime.now();
    Uri matchesUrl =
        Uri.https(SERVER_ADDR, '/matches/${SettingsData.instance.uid}');
    http.Response response = await http.get(matchesUrl); //eg /12313?gender=Male
    if (response.statusCode != 200) {
      return null; //TODO error handling
    }

    try{dynamic listProfiles = jsonDecode(response.body);
    return listProfiles;
    }
    catch(e){
      print('Error during parsing matches');
      return [];
    }

  }

  static List<String> serverImagesUrl(List<String> imagesUrls) {

    return imagesUrls.map((val) {
      return NetworkHelper.SERVER_ADDR + '/images/' + val;
    }).toList();
  }

  // static String serverCelebImageUrl(String imageUrl){
  //   return NetworkHelper.faceUrlToFullUrl(imageUrl);
  // }

  postUserDecision({Decision? decision, Profile? otherUserProfile}) async {
    SettingsData settings = SettingsData.instance;
    if (true) {
      print('TODO fix the profile @matchEngine stuff');
      return;
    }
    Map<String, String?> toSend = {
      'deciderName': settings.name,
      'decidee': otherUserProfile!.username,
      'decision': decision
          .toString()
          .substring("Decision.".length, decision.toString().length)
    };
    String encoded = jsonEncode(toSend);
    Uri postDecisionUri =
        Uri.https(SERVER_ADDR, '/decision/${settings.facebookId}');
    http.Response response = await http.post(postDecisionUri,
        body: encoded); //TODO something if response wasnt 200
  }

  // postUserSettings() async {
  //   await NewNetworkService.instance.postUserSettings(); //TODO This is because matches are changed through the older server. Once the matches are handled by new server, get rid of this method and switch the calls to it to newnetworkservice
  //   SettingsData settings = SettingsData.instance;
  //   Map<String, String?> toSend = {
  //     SettingsData.FIREBASE_UID_KEY: settings.uid,
  //     SettingsData.FACEBOOK_ID_KEY: settings.facebookId,
  //     'update_date': '8.0',
  //     SettingsData.NAME_KEY: settings.name,
  //     SettingsData.MIN_AGE_KEY: settings.minAge.toString(),
  //     SettingsData.MAX_AGE_KEY: settings.maxAge.toString(),
  //     SettingsData.PREFERRED_GENDER_KEY: settings.preferredGender,
  //     SettingsData.FILTER_NAME_KEY: settings.filterName,
  //     SettingsData.AUDITION_COUNT_KEY: settings.auditionCount.toString(),
  //     SettingsData.TASTE_MIX_RATIO_KEY: settings.tasteMixRatio.toString(),
  //     SettingsData.CELEB_ID_KEY: settings.celebId,
  //     SettingsData.FILTER_DISPLAY_IMAGE_URL_KEY: settings.filterDisplayImageUrl,
  //     SettingsData.RADIUS_KEY: settings.radius.toString(),
  //     SettingsData.FCM_TOKEN_KEY: settings.fcmToken,
  //     SettingsData.FACEBOOK_PROFILE_IMAGE_URL_KEY:
  //         settings.facebookProfileImageUrl,
  //     SettingsData.FACEBOOK_BIRTHDAY_KEY: settings.facebookBirthday,
  //     SettingsData.EMAIL_KEY: settings.email,
  //     SettingsData.USER_GENDER_KEY: settings.userGender,
  //     SettingsData.USER_DESCRIPTION_KEY: settings.userDescription,
  //     SettingsData.SHOW_USER_GENDER_KEY: settings.showUserGender.toString(),
  //     SettingsData.USER_BIRTHDAY_KEY: settings.userBirthday,
  //     SettingsData.USER_RELATIONSHIP_TYPE_KEY: settings.relationshipType,
  //     SettingsData.LONGITUDE_KEY: settings.longitude.toString(),
  //     SettingsData.LATITUDE_KEY: settings.latitude.toString(),
  //   };
  //   String encoded = jsonEncode(toSend);
  //   Uri postSettingsUri = Uri.https(SERVER_ADDR, '/settings/${settings.uid}');
  //   //http.Response response = await http.post(postSettingsUri, body: encoded); //TODO something if response wasnt 200
  //
  // }

  Future<HashMap<String, dynamic>> getFacesCustomImageSearchLinks(
      {String? imageFileName}) async {
    if (_facesCall != null) {
      return HashMap();
    }
    Uri facesLinkUri =
        Uri.https(SERVER_ADDR, 'faces/${SettingsData.instance.uid}/$imageFileName');
    _facesCall = http.get(facesLinkUri);
    if (DateTime.now().difference(_lastFacesImagesCall) <
        MIN_FACES_CALL_INTERVAL) {
      await Future.delayed(MIN_FACES_CALL_INTERVAL -
          DateTime.now().difference(_lastFacesImagesCall));
    }
    _lastFacesImagesCall = DateTime.now();
    http.Response response = await _facesCall!; //TODO something if error
    dynamic facesData = jsonDecode(response.body);
    _facesCall = null;
    return HashMap.from(facesData);
  }

  //A helper method to shrink an image if it's too large, and decode it into a workable image format
  Future<img.Image> _prepareImage(XFile pickedImageFile) async {
    const MAX_IMAGE_SIZE = 800; //TODO make it  a parameter (if needed)

    img.Image theImage = img.decodeImage(await pickedImageFile.readAsBytes())!;
    if (max(theImage.height, theImage.width) > MAX_IMAGE_SIZE) {
      double resizeFactor =
          MAX_IMAGE_SIZE / max(theImage.height, theImage.width);
      theImage = img.copyResize(theImage,
          width: (theImage.width * resizeFactor).round());
    }
    return theImage;
  }

  Future<Tuple2<img.Image, String>> preparedFaceSearchImageFileDetails(
      XFile imageFile) async {
    img.Image theImage = await _prepareImage(imageFile);
    String fileName = 'custom_face_search_${DateTime.now()}.jpg';
    return Tuple2<img.Image, String>(theImage, fileName);
  }

  Future<void> postFaceSearchImage(
      Tuple2<img.Image, String> imageFileDetails) async {
    img.Image theImage = imageFileDetails.item1;
    String fileName = imageFileDetails.item2;

    http.MultipartRequest request = http.MultipartRequest(
      'POST',
      Uri.https(SERVER_ADDR, '/upload/${SettingsData.instance.uid}'),
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

  Future<void> postProfileImage(XFile pickedImage) async {
    String fileName = '${DateTime.now().toString()}.jpg';
    img.Image theImage = await _prepareImage(pickedImage);

    http.MultipartRequest request = http.MultipartRequest(
      'POST',
      Uri.https(SERVER_ADDR, '/profile_images/${SettingsData.instance.uid}'),
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

  Future<List<String>?> getProfileImages() async {
    Uri countUri = Uri.https(
        SERVER_ADDR, '/profile_images/get_list/${SettingsData.instance.uid}/');
    var response = await http.get(countUri);
    if (response.statusCode == 200) {
      var parsed = json.jsonDecode(response.body);
      List<String>? imagesLinks = parsed.cast<String>();
      return imagesLinks;
    }
  }

  String getProfileImageUrl(String shortUrl) {
    return 'https://' +
        SERVER_ADDR +
        '/profile_images/${SettingsData.instance.uid}/$shortUrl';
  }

  Future<void> deleteProfileImage(int index) async {
    Uri deletionUri = Uri.https(SERVER_ADDR,
        '/profile_images/delete/${SettingsData.instance.uid}/${index.toString()}');
    var response = await http.get(deletionUri);
    return;
  }

  Future<void> swapProfileImages(
      int profileImageIndex1, int profileImageIndex2) async {
    Map<String, int> toSend = {
      'file1_index': profileImageIndex1,
      'file2_index': profileImageIndex2
    };

    String encoded = jsonEncode(toSend);

    Uri swapUri = Uri.https(
        SERVER_ADDR, '/profile_images/swap/${SettingsData.instance.uid}');
    http.Response response = await http.post(swapUri, body: encoded);
    return;
  }

  Future<NetworkTaskStatus> checkTaskStatus(String? taskId) async {
    if (DateTime.now().difference(_lastTaskStatusCall) <
        MIN_TASK_STATUS_CALL_INTERVAL) {
      await Future.delayed(MIN_TASK_STATUS_CALL_INTERVAL -
          DateTime.now().difference(_lastTaskStatusCall));
    }
    _lastTaskStatusCall = DateTime.now();
    Uri getTaskStatus = Uri.https(
        SERVER_ADDR, '/task_status/${SettingsData.instance.uid}/$taskId');
    http.Response response = await http.get(getTaskStatus);
    if (response.statusCode == 200) {
      var decodedResponse = json.jsonDecode(response.body);
      if (decodedResponse == 'in_progress') {
        return NetworkTaskStatus.inProgress;
      }
      if (decodedResponse == 'completed') {
        return NetworkTaskStatus.completed;
      }
      return NetworkTaskStatus.notExist;
    }

    return NetworkTaskStatus
        .notExist; //TODO else what to do when status isnt 200?
  }
}
