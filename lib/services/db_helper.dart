import 'dart:convert';
import 'dart:core';
import 'package:betabeta/data_models/celeb.dart';
import 'package:flutter/services.dart';
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();
  // make this a singleton class
  DatabaseHelper._privateConstructor();

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
  }




}