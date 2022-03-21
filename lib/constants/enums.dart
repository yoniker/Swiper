enum RelationshipPreference { marriage, relationship, casual, notSure }

enum PreferredGender { Men, Women, Everyone }

enum FilterType {
  CELEB_IMAGE,
  CUSTOM_IMAGE,
  TEXT_SEARCH,
  USER_TASTE,
  NONE,
}

extension uiDescription on FilterType {
  String get description {
    switch (this) {
      case FilterType.CELEB_IMAGE:
        return "Celeb Filter";
      case FilterType.CUSTOM_IMAGE:
        return "Custom Image";
      case FilterType.USER_TASTE:
        return "My taste";
      case FilterType.NONE:
        return "Normal mode";
      default:
        return "Normal mode";
    }
  }
}

enum ImageType { Celeb, Custom }

/// CONVERT from String to FilterType.
FilterType filterTypeFromString(String? filterName) {
  return FilterType.values.firstWhere((filter) => filter.name == filterName,
      orElse: () => FilterType.NONE);
}
