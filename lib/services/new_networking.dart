import 'dart:math';
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
      img.encodeJpg(theImage),
      filename: fileName,
      contentType: media.MediaType.parse('image/jpeg'),
    );
    request.files.add(multipartFile);
    var response = await request.send(); //TODO something if response wasn't 200
    var resp_text = await response.stream.bytesToString();
    return;
  }

  static String getProfileImageUrl(String shortUrl) {
    return 'https://' + SERVER_ADDR + shortUrl;
  }

  Future<List<String>?> getProfileImagesUrls() async {
    Uri countUri = Uri.https(SERVER_ADDR,
        '/profile_images/get_urls/${SettingsData.instance.uid}/');
    var response = await http.get(countUri);
    if (response.statusCode == 200) {
      var parsed = json.jsonDecode(response.body);
      List<String>? imagesLinks = parsed.cast<String>();
      return imagesLinks;
    }
  }

}