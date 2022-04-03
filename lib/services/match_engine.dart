import 'package:betabeta/constants/api_consts.dart';
import 'package:betabeta/models/profile.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:flutter/widgets.dart';
import 'package:betabeta/services/networking.dart';
import 'dart:collection';

class MatchEngine extends ChangeNotifier {
  static const MINIMUM_CACHED_PROFILES=15; //TODO get it from shared preferences rather than hardcoded
  Queue<Match> _previousMatches; //This will be a stack
  Queue<Match> _matches;
  bool? addedMoreProfiles;
  Future? matchesBeingGotten; //See https://stackoverflow.com/questions/63402499/flutter-how-not-to-call-the-same-service-over-and-over/63402620?noredirect=1#comment112113319_63402620
  MatchSearchStatus _serverMatchesSearchStatus = MatchSearchStatus.empty;
  LocationCountStatus _locationCountStatus = LocationCountStatus.initial_state;
  Future? countLocationBeingFetches;
  DateTime lastLocationCheck = DateTime(1990);
  static const Duration minIntervalWaitLocation = Duration(minutes: 5);



  MatchEngine._privateConstructor():_matches=Queue<Match>(),_previousMatches=Queue<Match>(){
    addMatchesIfNeeded();

      }
  static final MatchEngine _instance = MatchEngine._privateConstructor();

  static MatchEngine get instance => _instance;

  clear(){
    _matches.clear();
    _serverMatchesSearchStatus = MatchSearchStatus.empty;
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
    if(_serverMatchesSearchStatus==MatchSearchStatus.not_found){
      print('Not getting more matches from server since nothing was found!');
      return;}
    if (! (matchesBeingGotten == null && _matches.length < MINIMUM_CACHED_PROFILES)) {
      return;}
    if(SettingsData.instance.uid.length<=0){return;}
      try {
        matchesBeingGotten = NewNetworkService.instance.getMatches();
        dynamic matchesSearchResult = await matchesBeingGotten;
        if(matchesSearchResult==null){return;}
        MatchSearchStatus newStatus = MatchSearchStatus.values.firstWhere((s) => s.name==matchesSearchResult[API_CONSTS.MATCHES_SEARCH_STATUS_KEY],orElse:()=>MatchSearchStatus.empty) ;
        if (_serverMatchesSearchStatus!=newStatus){
          _serverMatchesSearchStatus = newStatus;
          notifyListeners();
        }
        print('STATUS OF FINDING MATCHES IS $_serverMatchesSearchStatus');
        dynamic matches = matchesSearchResult[API_CONSTS.MATCHES_SEARCH_MATCHES_KEY];
        List newProfiles = matches.map<Profile>((match){return Profile.fromJson(match);}).toList();
        List<Match> newPotentialMatches=newProfiles.map<Match>((profile){return Match(profile: profile);}).toList();
        if (newPotentialMatches.length>0) {
          _matches.addAll(newPotentialMatches);
          notifyListeners();
        }
      } finally {
        matchesBeingGotten = null;
        addMatchesIfNeeded();
      }


  }

  Future<void> getLocationStatusFromServer()async{
    var e = await NewNetworkService.instance.getCountUsersByLocation();
    print('dor');

  }
  
  MatchSearchStatus get getServerSearchStatus{
    return _serverMatchesSearchStatus;
  }

  void addMatchesIfNeeded(){
    if(this.length()>=MINIMUM_CACHED_PROFILES){
      print('no more matches are needed,length is ${this.length()}');
      return;
    }

    if(_locationCountStatus==LocationCountStatus.initial_state || _locationCountStatus == LocationCountStatus.not_enough_users){
      getLocationStatusFromServer();
    }

      getMoreMatchesFromServer();
    }


  void goToNextMatch() {
    print('go to next match called,decision is ${currentMatch()!.decision}');
    if (currentMatch()!.decision != Decision.indecided) {
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
  }


  currentMatchDecision(Decision decision,{bool nextMatch:true}){
    Match currentMatch=this.currentMatch()!;
    if(currentMatch.decision == Decision.indecided){
      currentMatch.decision = decision;}
    if(nextMatch){
      goToNextMatch();
    }
    notifyListeners();
    NewNetworkService.instance.postUserDecision(decision: decision,otherUserProfile: currentMatch.profile!);
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
