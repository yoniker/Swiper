import 'dart:convert';
import 'dart:math';
import 'package:betabeta/services/cache_service.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:http_parser/src/media_type.dart' as media;
import 'dart:convert' as json;

class NewNetworkService{
  static const SERVER_ADDR = 'dordating.com:8087';
  NewNetworkService._privateConstructor();

  static final NewNetworkService _instance = NewNetworkService._privateConstructor();

  static NewNetworkService get instance => _instance;

  //A helper method to shrink an image if it's too large, and decode it into a workable image format
  static Future<img.Image> _prepareImage(PickedFile pickedImageFile) async {
    const MAX_IMAGE_SIZE = 1500; //TODO make this a parameter and let the user control it (if needed)

    img.Image theImage = img.decodeImage(await pickedImageFile.readAsBytes())!;
    if (max(theImage.height, theImage.width) > MAX_IMAGE_SIZE) {
      double resizeFactor =
          MAX_IMAGE_SIZE / max(theImage.height, theImage.width);
      theImage = img.copyResize(theImage,
          width: (theImage.width * resizeFactor).round());
    }
    return theImage;
  }


  Future<void> postProfileImage(PickedFile pickedImage) async {
    String fileName = '${DateTime.now().toString()}.jpg';
    img.Image theImage = await _prepareImage(pickedImage);

    http.MultipartRequest request = http.MultipartRequest(
      'POST',
      Uri.https(
          SERVER_ADDR, '/upload_profile_image/${SettingsData.instance.uid}'),
    );
    var multipartFile = new http.MultipartFile.fromBytes(
      'file',
      img.encodeJpg(theImage,quality: 50),
      filename: fileName,
      contentType: media.MediaType.parse('image/jpeg'),
    );
    request.files.add(multipartFile);
    var response = await request.send(); //TODO something if response wasn't 200
    if(response.statusCode==200){
    var resp_text = await response.stream.bytesToString();
    var responseMap = jsonDecode(resp_text);
    String url = getProfileImageUrl(responseMap['image_url']);
    await CacheService.saveToCache(url,img.encodeJpg(theImage,quality: 50));
    print('SAVED UPLOADED IMAGE TO CACHE!');

    }


    return;
  }


  static String getImageProfileByUserId(String userId){
    //Get the user's main profile image by her userId
    return 'https://'+SERVER_ADDR+'/profile_image/$userId';
  }

  static String getProfileImageUrl(String shortUrl) {
    //Get any profile image link (not just the main one) from the shorthand version of /profile_images/real/something/something.jpg
    return 'https://' + SERVER_ADDR + shortUrl;
  }



  Future<List<String>?> getCurrentProfileImagesUrls() async {
    Uri countUri = Uri.https(SERVER_ADDR,
        '/profile_images/get_urls/${SettingsData.instance.uid}/');
    var response = await http.get(countUri);
    if (response.statusCode == 200) {
      var parsed = json.jsonDecode(response.body);
      List<String>? imagesLinks = parsed.cast<String>();
      return imagesLinks;
    }
  }


  Future<void> swapProfileImages(
      String profileImage1Url, String profileImage2Url) async {
    Map<String, String> toSend = {
      'file1_url': profileImage1Url,
      'file2_url': profileImage2Url
    };

    String encoded = jsonEncode(toSend);

    Uri swapUri = Uri.https(SERVER_ADDR,
        '/profile_images/swap/${SettingsData.instance.uid}');
    http.Response response = await http.post(swapUri, body: encoded);
    return;
  }

  Future<void> deleteProfileImage(String profileImageUrl) async {
    Uri deletionUri = Uri.https(SERVER_ADDR,
        '/profile_images/delete/${SettingsData.instance.uid}');
    Map<String, String> toSend = {
      'file_url': profileImageUrl,
    };
    String encoded = jsonEncode(toSend);
    var response = await http.post(deletionUri,body: encoded);
    return;
  }



}