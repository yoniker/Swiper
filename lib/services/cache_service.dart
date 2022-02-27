import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
class CacheService{

  static String keyToMd5(String key) => md5.convert(utf8.encode(key)).toString();

  static Future<void> saveToCache(String url,List<int>? data)async{
    if(data==null){return;}
    String md5Key = keyToMd5(url);
  final Directory _cacheImagesDirectory = Directory(
      join((await getTemporaryDirectory()).path, cacheImageFolderName));
  if (!_cacheImagesDirectory.existsSync()){
    await _cacheImagesDirectory.create();
  }
  final File cacheFile = File(join(_cacheImagesDirectory.path, md5Key));
    if (cacheFile.existsSync()) {return;} //File already exists. TODO worry about max Age?
    await File(join(_cacheImagesDirectory.path, md5Key)).writeAsBytes(data);
}

}