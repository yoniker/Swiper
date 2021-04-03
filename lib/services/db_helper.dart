import 'dart:core';
import 'dart:io' show  File;
import 'dart:typed_data';
import 'package:betabeta/data_models/celeb.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseHelper {

  static final _databaseName = "mobile_celebs.db";
  static final table = 'celebs_mobile';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String databasesGeneralPath = await getDatabasesPath();

    String celebsDatabasePath =
    path.join(databasesGeneralPath, _databaseName);

    bool celebsDbExists = await File(celebsDatabasePath).exists();

    if (!celebsDbExists) {
      // Copy from asset
      print('db does not exist, copying from asset...');
      ByteData data = await rootBundle.load(path.join("assets", _databaseName));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(celebsDatabasePath).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(celebsDatabasePath,readOnly:true);
  }

  Future<List<Celeb>> getCelebs()async{
    Database d = await database;
    final List<Map<String, dynamic>> rawData = await d.query(table);
    return List.generate(rawData.length, (index) {
      var currentItem = rawData[index];
      String aliasesString = currentItem['aliases'];
      List<String> aliases;
      if(aliasesString == null || aliasesString.length<1){
        aliases = [];
      }
      else {
        aliases = aliasesString.split('@');
      }
      aliases.add(currentItem['celeb_name']);
      return Celeb(
        celebName: currentItem['celeb_name'],
        name:currentItem['name'],
        aliases: aliases,
        birthday: currentItem['birthday'],
        description: currentItem['description'],
        country: currentItem['country'],

      );

    });

  }

}