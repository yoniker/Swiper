import 'dart:convert';
import 'dart:math';
import 'package:betabeta/constants/api_consts.dart';
import 'package:betabeta/models/profile.dart';
import 'package:betabeta/services/match_engine.dart';
import 'package:betabeta/services/cache_service.dart';
import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:http_parser/src/media_type.dart' as media;
import 'dart:convert' as json;

class NewNetworkService {
  static const SERVER_ADDR = 'dordating.com:8088';
  static const MIN_MATCHES_CALL_INTERVAL = Duration(seconds: 1);
  DateTime _lastMatchCall = DateTime(2000);
  NewNetworkService._privateConstructor();

  static final NewNetworkService _instance =
      NewNetworkService._privateConstructor();

  static NewNetworkService get instance => _instance;

  //A helper method to shrink an image if it's too large, and decode it into a workable image format
  // static Future<img.Image> _prepareImage(XFile pickedImageFile) async {
  //   const MAX_IMAGE_SIZE =
  //       1500; //TODO make this a parameter and let the user control it (if needed)
  //
  //   img.Image theImage = img.decodeImage(await pickedImageFile.readAsBytes())!;
  //   if (max(theImage.height, theImage.width) > MAX_IMAGE_SIZE) {
  //     double resizeFactor =
  //         MAX_IMAGE_SIZE / max(theImage.height, theImage.width);
  //     theImage = img.copyResize(theImage,
  //         width: (theImage.width * resizeFactor).round());
  //   }
  //   return theImage;
  // }

  // Future<void> postProfileImage(XFile pickedImage) async {
  //   String fileName = '${DateTime.now().toString()}.jpg';
  //   img.Image theImage = await _prepareImage(pickedImage);
  //
  //   http.MultipartRequest request = http.MultipartRequest(
  //     'POST',
  //     Uri.https(
  //         SERVER_ADDR, '/upload_profile_image/${SettingsData.instance.uid}'),
  //   );
  //   var multipartFile = new http.MultipartFile.fromBytes(
  //     'file',
  //     img.encodeJpg(theImage, quality: 50),
  //     filename: fileName,
  //     contentType: media.MediaType.parse('image/jpeg'),
  //   );
  //   request.files.add(multipartFile);
  //   var response = await request.send(); //TODO something if response wasn't 200
  //   if (response.statusCode == 200) {
  //     var resp_text = await response.stream.bytesToString();
  //     var responseMap = jsonDecode(resp_text);
  //     String url = getProfileImageUrl(responseMap['image_url']);
  //     await CacheService.saveToCache(url, img.encodeJpg(theImage, quality: 50));
  //     print('SAVED UPLOADED IMAGE TO CACHE!');
  //   }
  //
  //   return;
  // }

  // static String shortProfileUrlImageById(String userId) {
  //   //Get the user's main profile image by her userId
  //   return '/profile_image/$userId';
  // }

  // static String getProfileImageUrl(String shortUrl) {
  //   return 'https://' + SERVER_ADDR + shortUrl;
  // }

  // Future<void> syncCurrentProfileImagesUrls() async {
  //   Uri countUri = Uri.https(
  //       SERVER_ADDR, '/profile_images/get_urls/${SettingsData.instance.uid}/');
  //   var response = await http.get(countUri);
  //   if (response.statusCode == 200) {
  //     var parsed = json.jsonDecode(response.body);
  //     List<String>? imagesLinks = parsed.cast<String>();
  //     if (imagesLinks != null) {
  //       SettingsData.instance.profileImagesUrls = imagesLinks;
  //     }
  //   }
  // }

  // Future<void> swapProfileImages(
  //     String profileImage1Url, String profileImage2Url) async {
  //   Map<String, String> toSend = {
  //     'file1_url': profileImage1Url,
  //     'file2_url': profileImage2Url
  //   };
  //
  //   String encoded = jsonEncode(toSend);
  //
  //   Uri swapUri = Uri.https(
  //       SERVER_ADDR, '/profile_images/swap/${SettingsData.instance.uid}');
  //   http.Response response = await http.post(swapUri, body: encoded);
  //   return;
  // }

  // Future<void> deleteProfileImage(String profileImageUrl) async {
  //   Uri deletionUri = Uri.https(
  //       SERVER_ADDR, '/profile_images/delete/${SettingsData.instance.uid}');
  //   Map<String, String> toSend = {
  //     'file_url': profileImageUrl,
  //   };
  //   print('trying to delete $profileImageUrl');
  //   String encoded = jsonEncode(toSend);
  //   var response = await http.post(deletionUri, body: encoded);
  //   return;
  // }

  postUserDecision(
      {required Decision decision, required Profile otherUserProfile}) async {
    Map<String, String?> toSend = {
      API_CONSTS.DECIDER_ID_KEY: SettingsData.instance.uid,
      API_CONSTS.DECIDEE_ID_KEY: otherUserProfile.uid,
      API_CONSTS.DECISION_KEY: decision.name
    };
    String encoded = jsonEncode(toSend);
    Uri postDecisionUri =
        Uri.https(SERVER_ADDR, '/decision/${SettingsData.instance.uid}');
    http.Response response = await http.post(postDecisionUri,
        body: encoded); //TODO something if response wasnt 200
  }

  // Future<Profile?> getSingleUserProfile(String userId) async {
  //   Uri getUserUri = Uri.https(SERVER_ADDR, '/profile/$userId');
  //   http.Response response = await http.get(getUserUri);
  //   if (response.statusCode != 200) {
  //     return null; //TODO retry?
  //   }
  //   dynamic profileDataResult = jsonDecode(response.body);
  //   if (profileDataResult[API_CONSTS.MATCH_STATUS] ==
  //       API_CONSTS.SINGLE_PROFILE_NOT_FOUND) {
  //     return null;
  //   }
  //   return Profile.fromJson(
  //       profileDataResult[API_CONSTS.SINGLE_PROFILE_USER_DATA]);
  // }

  Future<void> unmatch(String uid) async {
    Uri unmatchUrl =
        Uri.https(SERVER_ADDR, '/unmatch/${SettingsData.instance.uid}/$uid');
    http.Response response = await http.get(unmatchUrl);
    //TODO something if not 200
    return;
  }

  Future<void> clearLikes() async {
    Uri clearLikesUrl =
        Uri.https(SERVER_ADDR, '/clear_likes/${SettingsData.instance.uid}');
    http.Response response = await http.get(clearLikesUrl);
    return;
  }

  Future<ServerRegistrationStatus> registerUid(
      {required String firebaseIdToken}) async {
    Uri verifyTokenUri = Uri.https(SERVER_ADDR, '/register_firebase_uid');
    http.Response response = await http
        .get(verifyTokenUri, headers: {'firebase_id_token': firebaseIdToken});
    if (response.statusCode != 200) {
      //TODO throw error (bad jwt? server down?)
    }

    var decodedResponse = json.jsonDecode(response.body);

    if (decodedResponse[API_CONSTS.STATUS] == API_CONSTS.ALREADY_REGISTERED) {
      SettingsData.instance
          .updateFromServerData(decodedResponse[API_CONSTS.USER_DATA]);
      return ServerRegistrationStatus.already_registered;
    }
    //The only possible response possible now is that the user is newly registered - so had to go through onboarding
    //if(decodedResponse[API_CONSTS.STATUS]==API_CONSTS.NEW_REGISTER){
    SettingsData.instance.uid =
        decodedResponse[API_CONSTS.USER_DATA][SettingsData.FIREBASE_UID_KEY];
    return ServerRegistrationStatus.new_register;
    //}
  }

  Future<void> verifyToken({required String firebaseIdToken}) async {
    Uri verifyTokenUri = Uri.https(SERVER_ADDR, '/verify_token');
    http.Response response = await http
        .get(verifyTokenUri, headers: {'firebase_id_token': firebaseIdToken});
    if (response.statusCode != 200) {
      //TODO throw error (bad jwt? server down?)
    }

    var decodedResponse = json.jsonDecode(response.body);

    return;
    //}
  }

  Future<LocationCountData> getCountUsersByLocation() async {
    Uri countUsersByLocationUri = Uri.https(
        SERVER_ADDR, '/users_in_location/${SettingsData.instance.uid}');
    http.Response response = await http.get(countUsersByLocationUri);
    if (response.statusCode != 200) {
      return LocationCountData(status: LocationCountStatus.initial_state);
    }
    try {
      var decodedResponse = jsonDecode(response.body);
      LocationCountStatus status = LocationCountStatus.values.firstWhere(
          (status_option) =>
              status_option.name ==
              decodedResponse[API_CONSTS.LOCATION_STATUS_KEY],
          orElse: () => LocationCountStatus.initial_state);
      if (decodedResponse[API_CONSTS.IS_TEST_USER_KEY] == true) {
        SettingsData.instance.isTestUser = true;
      } else {
        SettingsData.instance.isTestUser = false;
      }
      //Here there should be just enough users or not enough users + data
      if (status == LocationCountStatus.enough_users) {
        return LocationCountData(status: status);
      }
      //Here only if there are enough users so:
      int requiredUsers = decodedResponse[API_CONSTS.LOCATION_REQUIRED_USERS];
      int currentNumUsers = decodedResponse[API_CONSTS.LOCATION_CURRENT_USERS];
      return LocationCountData(
          status: status,
          currentNumUsers: currentNumUsers,
          requiredNumUsers: requiredUsers);
    } catch (e) {
      return LocationCountData(status: LocationCountStatus.initial_state);
    }
  }

  Future<void> deleteAccount() async {
    Uri deleteAccountUri =
        Uri.https(SERVER_ADDR, '/delete_account/${SettingsData.instance.uid}');
    http.Response response = await http.get(deleteAccountUri);
    //TODO check for a successful response and give user feedback if not successful
  }
}
