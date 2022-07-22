import 'dart:collection';
import 'dart:math';

import 'package:betabeta/data_models/celeb.dart';
import 'package:betabeta/services/aws_networking.dart';
import 'package:betabeta/services/db_helper.dart';
import 'package:betabeta/services/networking.dart';
import 'package:flutter/foundation.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:trotter/trotter.dart';

class CelebsInfo extends ChangeNotifier {
  bool? _infoLoadedFromDatabase; //TODO change this to enum with more complicated completion states
  int _numCelebsUrlsToGet = 0; //TODO this relies on the fact that dart is single threaded, look for a better way if needed
  List<Celeb>? _celebsInfo;
  DateTime? _lastChangeTime;

  DateTime? get lastChangeTime => _lastChangeTime;

  Future<void> getCelebsFromDatabase() async {
    _celebsInfo = await DatabaseHelper().getCelebs();
    _infoLoadedFromDatabase = true;
    _lastChangeTime = DateTime.now();
    notifyListeners();
  }



  static final CelebsInfo instance = CelebsInfo._privateConstructor();

  CelebsInfo._privateConstructor(){
    _lastChangeTime = DateTime.now();
    _infoLoadedFromDatabase = false;
    getCelebsFromDatabase();
  }

  bool? infoLoadedFromDatabase(){
    return _infoLoadedFromDatabase;
  }

  Future<void> getCelebImageLinks(Celeb celeb)async{
    _numCelebsUrlsToGet += 1;
    String? celebName = celeb.celebName;
    List<String> celebUrls = await AWSServer.instance.getCelebUrls(celebName);
    for (int i = 0; i < _celebsInfo!.length; i++){
      if(_celebsInfo![i].celebName == celebName){
        _celebsInfo![i].imagesUrls = celebUrls;
        break;
      }
    }
    _numCelebsUrlsToGet -= 1;
    if(_numCelebsUrlsToGet==0){
      notifyListeners();
    }

  }

  UnmodifiableListView<Celeb> get entireCelebsList => UnmodifiableListView(_celebsInfo!);

  static HashMap<Celeb?,double> computeScores(Map map){
    var celebInfo = map['celebInfo'];
    var searchString = map['searchString'];

    HashMap<Celeb?,double> celebScores =HashMap<Celeb?,double>();
    const int MAX_PERMUTATIONS = 4;
    for(final celeb in celebInfo) {
      double currentCelebScore = 1.0;
      final Fuzzy fuse = Fuzzy(celeb.aliases);
      final allWords = searchString.split(' ');
      List<String> allSearchWords = [];
      allWords.forEach((word) {
        word = word.trim();
        if (word.length > 0) {
          allSearchWords.add(word);
        }
      });
      final perms = Permutations(min(allSearchWords.length, MAX_PERMUTATIONS), allSearchWords);

      for (final perm in perms()) {
        final currentSearchTerm = perm.join(' ');
        final results = fuse.search(currentSearchTerm);
        for (final result in results) {
          if (result.score < currentCelebScore) { //0.0 score means a perfect match
            currentCelebScore = result.score;
          }
        }
        celebScores[celeb] = currentCelebScore;
      }
    }
    return celebScores;

  }

  Future<void> sortListByKeywords(String searchString) async{
    Map map = Map();
    map['celebInfo'] = _celebsInfo;
    map['searchString'] = searchString;

    HashMap<Celeb?,double> celebScores = await compute(computeScores,map);
    List<Celeb> celebsInfoCopy =  List<Celeb>.from(_celebsInfo!);
    celebsInfoCopy.sort((celebA, celebB) => celebScores[celebA]!.compareTo(celebScores[celebB]!));
    _celebsInfo = celebsInfoCopy;
    _lastChangeTime = DateTime.now();
    notifyListeners();


  }



}