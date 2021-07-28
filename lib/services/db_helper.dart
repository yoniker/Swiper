import 'dart:convert';
import 'dart:core';
import 'dart:io' show Directory, File;
import 'dart:typed_data';
import 'package:betabeta/data_models/celeb.dart';
import 'package:betabeta/services/celeb_hive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:hive_flutter/hive_flutter.dart';
class DatabaseHelper {
  static final boxName = 'celebs_hive';
  static final _filename = 'celebs_hive.hive';
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();
  Box<CelebHive> _celebsBox;
  bool _loadedDb = false;
  // make this a singleton class
  DatabaseHelper._privateConstructor();

  Future<void> _loadCelebsBox() async{
    Hive.registerAdapter(CelebAdapter());
    await _saveHiveFileAppFolder();
    _celebsBox = await Hive.openBox<CelebHive>(boxName);
    _loadedDb = true;
  }
  
  Future<void> _saveHiveFileAppFolder() async{
    Directory databasesGeneralPath = await getApplicationDocumentsDirectory();

    String celebsDatabasePath =
    path.join(databasesGeneralPath.path, _filename);
    print('general path for data file is $celebsDatabasePath');

    bool celebsDbExists = await File(celebsDatabasePath).exists();

    if (!celebsDbExists) {
      // Copy from asset
      print('db does not exist, copying from asset...');
      ByteData data = await rootBundle.load(path.join("assets", _filename));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(celebsDatabasePath).writeAsBytes(bytes, flush: true);
    }

  }
  
  
  

  factory DatabaseHelper() {
    return _instance;
  }

  Future<List<Celeb>> getCelebs() async {

     if(true) { //TODO for now until we'll figure out if to always use json (fast enough?) or hive if it's mobile
       List<Celeb> allCelebs = [];
       String jsonString = await rootBundle.loadString('assets/celebs.json');
       final celebsFromJson = json.decode(jsonString);
       for (var celeb in celebsFromJson) {
         var aliases = celeb['aliases'].split('@');
         aliases.add(celeb['celeb_name'] ?? '');
         Celeb currentCeleb = Celeb(
           celebName: celeb['celeb_name'] ?? '',
           name: celeb['name'] ?? '',
           aliases: aliases,
           birthday: celeb['birthday'],
           description: celeb['description'],
           country: celeb['country'],
         );
         allCelebs.add(currentCeleb);
       }

       return allCelebs;
     }


    if(!_loadedDb){
      await Hive.initFlutter();
      await _loadCelebsBox();

    }

    List<Celeb> allCelebs = [];
    _celebsBox.keys.forEach((key) {
      CelebHive celebHive= _celebsBox.get(key);
      List<String> aliases = celebHive.aliases;
      aliases.add(celebHive.celeb_name);
      Celeb celeb = Celeb(celebName: celebHive.celeb_name,name:celebHive.name,aliases: aliases,birthday: celebHive.birthday,description: celebHive.description,country: celebHive.country);
      allCelebs.add(celeb);
    });
    return allCelebs;
  }




}