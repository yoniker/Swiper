import 'package:flutter/widgets.dart';
import 'package:betabeta/services/networking.dart';
import './profiles.dart';
import 'dart:collection';

class MatchEngine extends ChangeNotifier {
  static const MINIMUM_CACHED_PROFILES=100; //TODO get it from shared preferences rather than hardcoded
  Queue<Match> _matches;
  bool addedMoreProfiles;
  Future itemsBeingGotten; //See https://stackoverflow.com/questions/63402499/flutter-how-not-to-call-the-same-service-over-and-over/63402620?noredirect=1#comment112113319_63402620

  MatchEngine({
    List<Match> matches,
  }):_matches=Queue<Match>()   {
    if (matches!=null){
    _matches.addAll(matches);}
    addMatchesIfNeeded();
  }
  int length(){return _matches.length;}
  Match  currentMatch() {
    if(_matches.length<=0){return null;}
    return _matches.elementAt(0);}
  Match nextMatch()  {
    if(_matches.length<=1){return null;}
    return _matches.elementAt(1);}

  Future<void> getMoreMatchesFromServer() async {
    if (! (itemsBeingGotten == null && _matches.length < MINIMUM_CACHED_PROFILES)) {
      print('going to return from getMoreMatchesFromServer,itemsBeingGotten is $itemsBeingGotten');
      return;} //TODO use user's settings rather than an arbitrary value
      try {
        print('going to try and get matches at getMoreMatchesFromServer');
        itemsBeingGotten = NetworkHelper().getMatches();
        dynamic matches = await itemsBeingGotten;
        List newProfiles = matches.map<Profile>((match){return Profile.fromMatch(match);}).toList();
        List<Match> newPotentialMatches=newProfiles.map<Match>((profile){return Match(profile: profile);}).toList();
        print('newPotentialMatches found ${newPotentialMatches.length} matches');
        if (newPotentialMatches.length>0) {
          _matches.addAll(newPotentialMatches);
          print('Finished getting matches at getMoreMatchesFromServer,new _matches length is ${_matches.length}');
          notifyListeners();
        }
      } finally {
        itemsBeingGotten = null;
        addMatchesIfNeeded();
      }


  }

  void addMatchesIfNeeded(){
    if(this.length()<MINIMUM_CACHED_PROFILES){
      print('will try to get more matches since length of queue is ${this.length()}');
      getMoreMatchesFromServer();} //TODO use user's settings instead of a hardcoded value
  }

  void goToNextMatch() {
    if (currentMatch().decision != Decision.indecided) {
      _matches.removeFirst();
      notifyListeners();
      addMatchesIfNeeded();
    }
  }
}

class Match extends ChangeNotifier {
  final Profile profile;
  Decision decision = Decision.indecided;

  Match({this.profile});

  void like() {
    if (decision == Decision.indecided) {
      decision = Decision.like;
      print('user decision: Like ${profile.username}');
      notifyListeners();
    }
  }

  void nope() {
    if (decision == Decision.indecided) {
      decision = Decision.nope;
      print('User decision:Nope ${profile.username}');
      notifyListeners();
    }
  }

  void superLike() {
    if (decision == Decision.indecided) {
      decision = Decision.superLike;
      print('User decision:superlike');
      notifyListeners();
    }
  }

  void reset() {
    if (decision != Decision.indecided) {
      decision = Decision.indecided;
      notifyListeners();
    }
  }
}

enum Decision {
  indecided,
  nope,
  like,
  superLike,
}
