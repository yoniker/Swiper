enum PreferredGender{
  Men,
  Women,
  Everyone
}


enum FilterType {
  SELECT_CELEB,
  USE_TASTE,
  NONE,
}

/// CONVERT from String to FilterType.
FilterType filterTypeFromString(String? filter) {
  switch (filter) {
    case 'select_celeb':
      return FilterType.SELECT_CELEB;

    case 'use_taste':
      return FilterType.USE_TASTE;

    case 'none':
      return FilterType.NONE;

    default:
      return FilterType.NONE;

  }
}


/// CONVERT from FilterType to String.
String filterTypeToString(FilterType? filterType) {
  switch (filterType) {
    case FilterType.SELECT_CELEB:
      return 'select_celeb';
     ;
    case FilterType.USE_TASTE:
      return 'use_taste';

    case FilterType.NONE:
      return 'none';

    default:
      return 'none';

  }
}