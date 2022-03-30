enum MatchSearchStatus{
found,not_found,searching,empty
}

class API_CONSTS{
  static const String MATCHES_SEARCH_STATUS_KEY = 'status';
  static const String MATCHES_SEARCH_MATCHES_KEY = 'matches';

  static const String DECIDER_ID_KEY = 'decider_id';
  static const String DECIDEE_ID_KEY = 'decidee_id';
  static const String DECISION_KEY = 'decision';

  static const String USER_UID_KEY = 'firebase_uid';
  static const String USER_MATCH_CHANGED_TIME = 'match_changed_time';
  static const String USER_NAME = 'name';
  static const String USER_SHOW_USER_GENDER = 'show_user_gender';
  static const String USER_DESCRIPTION = 'user_description';
  static const String USER_RELATIONSHIP_TYPE = 'relationship_type';
  static const String USER_LOCATION_DESCRIPTION = 'location_description';
  static const String USER_JOB_TITLE = 'job_title';
  static const String USER_HEIGHT_IN_CM = 'height_in_cm';
  static const String USER_SCHOOL = 'school';
  static const String USER_RELIGION = 'religion';
  static const String USER_ZODIAC = 'zodiac';
  static const String USER_FITNESS = 'fitness';
  static const String USER_SMOKING = 'smoking';
  static const String USER_DRINKING = 'drinking';
  static const String USER_EDUCATION ='education';
  static const String USER_CHILDREN = 'children';
  static const String USER_COVID_VACCINE = 'covid_vaccine';
  static const String USER_HOBBIES = 'hobbies';
  static const String USER_PETS = 'pets';
  static const String USER_IMAGES = 'images';
  static const String USER_AGE = 'age';
  static const String USER_HOTNESS = 'hotness';
  static const String USER_COMPATABILITY = 'compatibility';
  static const String USER_LOCATION_DISTANCE = 'location_distance';
  static const String USER_GENDER_KEY = 'user_gender';
  static const String SHOW_USER_GENDER_KEY = 'show_user_gender';
  static const String PREFERRED_GENDER_KEY = 'gender_preferred';
  static const String MATCH_STATUS = 'status';
  //Possible results when asking for a single profile from server
  static const String SINGLE_PROFILE_FOUND = 'found';
  static const String SINGLE_PROFILE_NOT_FOUND = 'not_found';
  static const String SINGLE_PROFILE_USER_DATA = 'user_data';
  //Possible registration responses
  static const String NEW_REGISTER = 'new_register';
  static const String ALREADY_REGISTERED = 'already_registered';
  static const String STATUS = 'status';
  static const String USER_DATA = 'user_data';
  
}