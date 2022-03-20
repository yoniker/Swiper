enum RelationshipPreference { marriage, relationship, casual, notSure }

enum PreferredGender { Men, Women, Everyone }

enum FilterType {
  CELEB_IMAGE,
  CUSTOM_IMAGE,
  USER_TASTE,
  NONE,
}

extension uiDescription on FilterType{
  String get description{
    switch(this){
      case FilterType.CELEB_IMAGE: return "Celeb Filter";
      case FilterType.CUSTOM_IMAGE: return "Custom Image";
      case FilterType.USER_TASTE: return "My taste";
      case FilterType.NONE: return "Normal mode";
      default: return "Normal mode";
    }
  }
}

enum ImageType { Celeb, Custom }

/// CONVERT from String to FilterType.
FilterType filterTypeFromString(String? filter) {
  switch (filter) {
    case 'select_celeb':
      return FilterType.CELEB_IMAGE;

    case 'use_taste':
      return FilterType.USER_TASTE;

    case 'none':
      return FilterType.NONE;

    default:
      return FilterType.NONE;
  }
}

/// CONVERT from FilterType to String.
String filterTypeToString(FilterType? filterType) {
  switch (filterType) {
    case FilterType.CELEB_IMAGE:
      return 'select_celeb';
      ;
    case FilterType.USER_TASTE:
      return 'use_taste';

    case FilterType.NONE:
      return 'none';

    default:
      return 'none';
  }
}
