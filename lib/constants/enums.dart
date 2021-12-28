enum Gender{
  Men,
  Women,
  Everyone
}

extension ToDisplayString on Gender {
  String toShortString() {
    return this.toString().split('.').last;
  }
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
      break;
    case 'use_taste':
      return FilterType.USE_TASTE;
      break;
    case 'none':
      return FilterType.NONE;
      break;
    default:
      return FilterType.NONE;
      break;
  }
}


/// CONVERT from FilterType to String.
String filterTypeToString(FilterType? filterType) {
  switch (filterType) {
    case FilterType.SELECT_CELEB:
      return 'select_celeb';
      break;
    case FilterType.USE_TASTE:
      return 'use_taste';
      break;
    case FilterType.NONE:
      return 'none';
      break;
    default:
      return 'none';
      break;
  }
}