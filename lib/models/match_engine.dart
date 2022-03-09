import 'package:betabeta/models/profile.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:flutter/widgets.dart';
import 'package:betabeta/services/networking.dart';
import 'dart:collection';

class MatchEngine extends ChangeNotifier {
  static const MINIMUM_CACHED_PROFILES=15; //TODO get it from shared preferences rather than hardcoded
  Queue<Match> _previousMatches; //This will be a stack
  Queue<Match> _matches;
  bool? addedMoreProfiles;
  Future? itemsBeingGotten; //See https://stackoverflow.com/questions/63402499/flutter-how-not-to-call-the-same-service-over-and-over/63402620?noredirect=1#comment112113319_63402620

  MatchEngine._privateConstructor():_matches=Queue<Match>(),_previousMatches=Queue<Match>(){
        addMatchesIfNeeded();
      }
  static final MatchEngine _instance = MatchEngine._privateConstructor();

  static MatchEngine get instance => _instance;

  clear(){
    _matches.clear();
    notifyListeners();
    addMatchesIfNeeded();
  }

  bool previousMatchExists(){
    return _previousMatches.length>0;
  }
  int length(){return _matches.length;}
  Match?  currentMatch() {
    if(_matches.length<=0){return null;}
    return _matches.elementAt(0);}
  Match? nextMatch()  {
    if(_matches.length<=1){return null;}
    return _matches.elementAt(1);}

  Future<void> getMoreMatchesFromServer() async {
    if (! (itemsBeingGotten == null && _matches.length < MINIMUM_CACHED_PROFILES)) {
      return;}
    if(SettingsData.instance.uid ==null || SettingsData.instance.uid.length<=0){return;}
      try {
        itemsBeingGotten = NetworkHelper().getMatches();
        dynamic matches = await itemsBeingGotten;
        if(matches==null){return;}
        List newProfiles = matches.map<Profile>((match){return Profile.fromServer(match);}).toList();
        List<Match> newPotentialMatches=newProfiles.map<Match>((profile){return Match(profile: profile);}).toList();
        if (newPotentialMatches.length>0) {
          _matches.addAll(newPotentialMatches);
          notifyListeners();
        }
      } finally {
        itemsBeingGotten = null;
        addMatchesIfNeeded();
      }


  }

  void addMatchesIfNeeded(){
    if(this.length()<MINIMUM_CACHED_PROFILES){
      getMoreMatchesFromServer();
    }
    else{print('no more matches are needed,length is ${this.length()}');}//TODO use user's settings instead of a hardcoded value
  }

  void goToNextMatch() {
    print('go to next match called,decision is ${currentMatch()!.decision}');
    if (currentMatch()!.decision != Decision.indecided) {
      _previousMatches.addLast(_matches.removeFirst());
      printMatches();
      notifyListeners();
      addMatchesIfNeeded();
    }
  }

  void goBack(){
    if(_previousMatches.length>0){
      Match previousMatch = _previousMatches.removeLast();
      previousMatch.decision=Decision.indecided;
    _matches.addFirst(previousMatch);
    notifyListeners();
    }
  }


  currentMatchDecision(Decision decision,{bool nextMatch:true}){
    Match currentMatch=this.currentMatch()!;
    if(currentMatch!=null && currentMatch.decision == Decision.indecided){
      currentMatch.decision = decision;}
    if(nextMatch){
      goToNextMatch();
    }
    notifyListeners();
    NetworkHelper().postUserDecision(decision: decision,otherUserProfile: currentMatch.profile);
    }
  }


class Match extends ChangeNotifier {

  final Profile? profile;
  Decision decision = Decision.indecided;

  Match({this.profile});
}

enum Decision {
  dontKnow,
  indecided,
  nope,
  like,
  superLike,
}
