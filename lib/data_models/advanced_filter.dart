import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/data_models/celeb.dart';

class AdvancedFilter {
  // ignore: non_constant_identifier_names
  static final String USER_ADVANCED_FILTERS_KEY = 'USER_ADVANCED_FILTERS_KEY';

  AdvancedFilter({
    this.filterIndex,
    this.filterType,
    this.auditionCount,
    this.selectedCeleb,
  });

  /// The index of the [AdvancedFilter] instance
  ///
  /// This is `1` for [FilterType.CELEB_IMAGE], `2` for [FilterType.USER_TASTE] and `0` (zero) for [FilterType.NONE].
  int? filterIndex;

  /// The type of the Advanced filters chosen.
  /// This can either be `FilterType.SELECT_CELEB`, `FilterType.USE_TASTE` or `FilterType.NONE`.
  FilterType? filterType;

  /// The number of People to Audition.
  int? auditionCount;

  /// The Profile of the Celebrity chosen.
  ///
  /// NOTE: This should never be null when the `filterIndex` is (1) one.
  Celeb? selectedCeleb;

  /// ### FACTORY CONSTRUCTOR
  ///
  /// A constructor for the [AdvancedFilter] class
  /// to construct an [AdvancedFilter] instance from a Map of values.
  factory AdvancedFilter.fromJson(Map<String, dynamic> json) {
    return AdvancedFilter(
      filterIndex: json['filter_index'] ?? 0,
      filterType: filterTypeFromString(json['filter_type']),
      auditionCount: json['audition_count'] ?? 50,
      // The null case is taken care of by the [Celeb] class.
      selectedCeleb: Celeb.fromJson(json['celeb']),
    );
  }

  /// ### MOCK DATA CONSTRUCTOR
  ///
  /// NOTE: This constructor should only be called during the App entry point.
  /// Edit this to customarily change the initial data you want your user to have.
  factory AdvancedFilter.getMockedData() {
    // create a mockedJson file just to make sure the conversion
    // methods work appropriately.
    var jsonString = {
      'filter_index': 1,
      'filter_type': 'select_celeb',
      'audition_count': 24,
      'celeb': {
        'celeb_name': 'celebName',
        'name': 'name',
        'aliases': [
          'aliases',
          'aliases',
        ],
        'birthday': 'birthday',
        'description': 'description',
        'country': 'country',
        'image_urls': [
          'none',
          'image_urls',
        ],
      },
    };

    return AdvancedFilter.fromJson(jsonString);
  }

  /// A method to copy the property of [this] with the new provided
  /// parameters.
  ///
  /// If the new Provided parameters are found to be null,
  /// the old properties of [this] are used instead.
  AdvancedFilter copyWith({
    int? filterIndex,
    FilterType? filterType,
    int? auditonCount,
    Celeb? selectedCeleb,
  }) {
    //
    return AdvancedFilter(
      filterIndex: filterIndex ?? this.filterIndex ?? 0,
      filterType: filterType ?? this.filterType ?? FilterType.NONE,
      auditionCount: auditonCount ?? this.auditionCount ?? 50,
      selectedCeleb: selectedCeleb ?? this.selectedCeleb,
    );
  }

  /// A method to convert the current [AdvancedFilter] instance
  /// to Json Serilizable format.
  Map<String, dynamic> toJson() {
    //
    return {
      'filter_index': filterIndex,
      'filter_type': filterType!.name,
      'audition_count': auditionCount,
      'celeb': selectedCeleb!.toJson(),
    };
  }

  @override
  String toString() {
    // retrun the Json Representation of the [AdvancedFilter] for now.
    return toJson().toString();
  }
}
