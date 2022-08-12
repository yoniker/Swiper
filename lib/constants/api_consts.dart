enum MatchSearchStatus{
found,not_found,searching,empty
}

enum LocationCountStatus{ //Possible responses from Location count request
unknown_location, enough_users,not_enough_users, initial_state
}

class LocationCountData{
  LocationCountStatus status;
  int? requiredNumUsers;
  int? currentNumUsers;
  LocationCountData({required this.status,this.currentNumUsers,this.requiredNumUsers});
  LocationCountData.clone(LocationCountData copiedData): this(status: copiedData.status,requiredNumUsers: copiedData.requiredNumUsers,currentNumUsers: copiedData.currentNumUsers);

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
  static const String ALREADY_REGISTERED = 'registered';
  static const String STATUS = 'status';
  static const String USER_DATA = 'user_data';
  //Possible notification types and fields
  static const String PUSH_NOTIFICATION_TYPE_KEY = 'push_notification_type';
  static const String PUSH_NOTIFICATION_NEW_MATCH = 'new_match';
  static const String PUSH_NOTIFICATION_MATCH_INFO = 'match_info';
  static const String NEW_READ_RECEIPT = 'new_read_receipt';
  static const String PUSH_NOTIFICATION_NEW_MESSAGE = 'new_message';
  static const String PUSH_NOTIFICATION_USER_ID = 'user_id';
  static const String CHANGE_USER_STATUS = 'change_user_status';
  static const String CHANGE_USER_KEY = 'change_user_key';
  static const String CHANGE_USER_VALUE = 'change_user_value';
  //Possible location count responses
  static const String LOCATION_STATUS_KEY = 'status';
  static const String IS_TEST_USER_KEY  = 'is_test_user';
  static const String LOCATION_REQUIRED_USERS = 'required_num';
  static const String LOCATION_CURRENT_USERS = 'current_num';

  //responses when analysing user profile, getting info etc
  static const String FACES_DETAILS = 'faces_details';
  static const String CELEBS_DATA = 'celebs_data';
  static const String TRAITS = 'traits';

}