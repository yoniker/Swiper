import 'package:betabeta/user_profile.dart';
import 'package:betabeta/profiles.dart';
import 'package:flutter/widgets.dart';
import 'package:betabeta/services/networking.dart';
import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';

class MatchEngine extends ChangeNotifier {
  static const MINIMUM_CACHED_PROFILES=15; //TODO get it from shared preferences rather than hardcoded
  Queue<Match> _previousMatches; //This will be a stack
  Queue<Match> _matches;
  bool addedMoreProfiles;
  Future itemsBeingGotten; //See https://stackoverflow.com/questions/63402499/flutter-how-not-to-call-the-same-service-over-and-over/63402620?noredirect=1#comment112113319_63402620
  FacebookProfile userProfile;
  MatchEngine({this.userProfile,
    List<Match> matches,
  }):_matches=Queue<Match>(),_previousMatches=Queue<Match>()   {
    if (matches!=null){
    _matches.addAll(matches);}
    addMatchesIfNeeded();
  }

  clear(){_matches.clear();}
  int length(){return _matches.length;}
  Match  currentMatch() {
    if(_matches.length<=0){return null;}
    return _matches.elementAt(0);}
  Match nextMatch()  {
    if(_matches.length<=1){return null;}
    return _matches.elementAt(1);}

  Future<void> getMoreMatchesFromServer() async {
    if (! (itemsBeingGotten == null && _matches.length < MINIMUM_CACHED_PROFILES)) {
      return;} //TODO use user's settings rather than an arbitrary value
      try {
        itemsBeingGotten = NetworkHelper().getMatches();
        dynamic matches = await itemsBeingGotten;
        List newProfiles = matches.map<Profile>((match){return Profile.fromMatch(match);}).toList();
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
      getMoreMatchesFromServer();} //TODO use user's settings instead of a hardcoded value
  }

  void goToNextMatch() {
    if (currentMatch().decision != Decision.indecided) {
      _previousMatches.addLast(_matches.removeFirst());
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

    printMatches();
  }

  void printMatches(){
    if(length()>=3){
      for(int i=0; i<3; ++i){
        print(_matches.elementAt(i).profile.username);
      }
    }
  }

  currentMatchDecision(Decision decision){
    Match currentMatch=this.currentMatch();
    if(currentMatch.decision == Decision.indecided){
      currentMatch.decision = decision;
      notifyListeners();
      NetworkHelper().postUserDecision(userProfile: userProfile,decision: decision,otherUserProfile: currentMatch.profile);
    }
  }
}

class Match extends ChangeNotifier {

  final Profile profile;
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
