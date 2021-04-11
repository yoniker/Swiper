import 'package:flutter/cupertino.dart' show CupertinoColors;

import 'cupertino_range_slider_thumb_shape.dart';
import 'package:flutter/material.dart';

class CupertinoRangeSlider extends StatelessWidget {
  CupertinoRangeSlider({
    Key key,
    @required this.values,
    @required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.labels,
    this.activeColor,
    this.inactiveColor,
    this.semanticFormatterCallback,
    //
    this.thumbColor = Colors.white,
    this.valueIndicatorColor,
    this.activeTickMarkColor,
    this.disabledThumbColor,
    this.inactiveTickMarkColor,
    this.showValueIndicator = ShowValueIndicator.onlyForDiscrete,
    this.trackHeight = 1.8,
    this.thumbRadius = 13.8,
    this.thumbShadows,
  });

  /// By default, [showValueIndicator] is set to [ShowValueIndicator.onlyForDiscrete].
  /// The value indicator is only shown when the thumb is being touched.
  final ShowValueIndicator showValueIndicator;

  /// The color to be used in painting the value indicator
  /// of the [CupertinoRangeSlider].
  /// This Defaults to the `activeColor` of the [CupertinoRangeSlider].
  /// If this is `null` it is set to the current `PrimaryColor`
  /// of the current [Theme].
  final Color valueIndicatorColor;

  /// The color to be used to paint the [Thumb].
  /// Defaults to `Colors.white`.
  final Color thumbColor;

  /// The color to be used to paint the [Thumb].
  /// Defaults to `Colors.grey[300]`.
  final Color disabledThumbColor;

  /// The color to be used to paint the inactiveTicMarks.
  /// Defaults to `Colors.grey`.
  final Color inactiveTickMarkColor;

  /// The color to be used to paint the activeTicMarks.
  /// Defaults to the `colorScheme.onPrimary` of the current theme.
  final Color activeTickMarkColor;

  /// The radius of the [Thumb] (The white button that is slided over the track)
  /// for this slider. Defaults to 13.8.
  final double thumbRadius;

  /// This property helps to define the shadow painted below the thumb
  /// to give users a sense of elevation.
  ///
  /// The default value is the one set in the [CupertinoRangeSliderThumbShape] class.
  /// which is the default value used by the [CupertinoSlider] Widget.
  final List<BoxShadow> thumbShadows;

  /// The height of the slider's track.
  /// Defaults to 1.8.
  final double trackHeight;

  /// The normal parameters of the RangeSlider class.
  /// Copied from the RangeSlider class.
  ///
  /// The currently selected values for this range slider.
  ///
  /// The slider's thumbs are drawn at horizontal positions that corresponds to
  /// these values.
  final RangeValues values;

  /// Called when the user is selecting a new value for the slider by dragging.
  ///
  /// The slider passes the new values to the callback but does not actually
  /// change state until the parent widget rebuilds the slider with the new
  /// values.
  ///
  /// If null, the slider will be displayed as disabled.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// CupertinoRangeSlider(
  ///   values: _rangeValues,
  ///   min: 1.0,
  ///   max: 10.0,
  ///   onChanged: (RangeValues newValues) {
  ///     setState(() {
  ///       _rangeValues = newValues;
  ///     });
  ///   },
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [onChangeStart], which  is called when the user starts  changing the
  ///    values.
  ///  * [onChangeEnd], which is called when the user stops changing the values.
  final ValueChanged<RangeValues> onChanged;

  /// Called when the user starts selecting new values for the slider.
  ///
  /// This callback shouldn't be used to update the slider [values] (use
  /// [onChanged] for that). Rather, it should be used to be notified when the
  /// user has started selecting a new value by starting a drag or with a tap.
  ///
  /// The values passed will be the last [values] that the slider had before the
  /// change began.
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// CupertinoRangeSlider(
  ///   values: _rangeValues,
  ///   min: 1.0,
  ///   max: 10.0,
  ///   onChanged: (RangeValues newValues) {
  ///     setState(() {
  ///       _rangeValues = newValues;
  ///     });
  ///   },
  ///   onChangeStart: (RangeValues startValues) {
  ///     print('Started change at $startValues');
  ///   },
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [onChangeEnd] for a callback that is called when the value change is
  ///    complete.
  final ValueChanged<RangeValues> onChangeStart;

  /// Called when the user is done selecting new values for the slider.
  ///
  /// This differs from [onChanged] because it is only called once at the end
  /// of the interaction, while [onChanged] is called as the value is getting
  /// updated within the interaction.
  ///
  /// This callback shouldn't be used to update the slider [values] (use
  /// [onChanged] for that). Rather, it should be used to know when the user has
  /// completed selecting a new [values] by ending a drag or a click.
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// CupertinoRangeSlider(
  ///   values: _rangeValues,
  ///   min: 1.0,
  ///   max: 10.0,
  ///   onChanged: (RangeValues newValues) {
  ///     setState(() {
  ///       _rangeValues = newValues;
  ///     });
  ///   },
  ///   onChangeEnd: (RangeValues endValues) {
  ///     print('Ended change at $endValues');
  ///   },
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [onChangeStart] for a callback that is called when a value change
  ///    begins.
  final ValueChanged<RangeValues> onChangeEnd;

  /// The minimum value the user can select.
  ///
  /// Defaults to 0.0. Must be less than or equal to [max].
  ///
  /// If the [max] is equal to the [min], then the slider is disabled.
  final double min;

  /// The maximum value the user can select.
  ///
  /// Defaults to 1.0. Must be greater than or equal to [min].
  ///
  /// If the [max] is equal to the [min], then the slider is disabled.
  final double max;

  /// The number of discrete divisions.
  ///
  /// Typically used with [labels] to show the current discrete values.
  ///
  /// If null, the slider is continuous.
  final int divisions;

  /// Labels to show as text in the [SliderThemeData.rangeValueIndicatorShape].
  ///
  /// There are two labels: one for the start thumb and one for the end thumb.
  ///
  /// Each label is rendered using the active [ThemeData]'s
  /// [TextTheme.bodyText1] text style, with the theme data's
  /// [ColorScheme.onPrimary] color. The label's text style can be overridden
  /// with [SliderThemeData.valueIndicatorTextStyle].
  ///
  /// If null, then the value indicator will not be displayed.
  ///
  /// See also:
  ///
  ///  * [RangeSliderValueIndicatorShape] for how to create a custom value
  ///    indicator shape.
  final RangeLabels labels;

  /// The color of the track's active segment, i.e. the span of track between
  /// the thumbs.
  ///
  /// Defaults to [Theme.of(context).primaryColor].
  final Color activeColor;

  /// The color of the track's inactive segments, i.e. the span of tracks
  /// between the min and the start thumb, and the end thumb and the max.
  ///
  /// Defaults to [Colors.grey[300].
  /// That's the default Color for a normal CupertinoSlider Widget.
  final Color inactiveColor;

  /// The callback used to create a semantic value from the slider's values.
  ///
  /// Defaults to formatting values as a percentage.
  ///
  /// This is used by accessibility frameworks like TalkBack on Android to
  /// inform users what the currently selected value is with more context.
  ///
  /// {@tool snippet}
  ///
  /// In the example below, a slider for currency values is configured to
  /// announce a value with a currency label.
  ///
  /// ```dart
  /// CupertinoRangeSlider(
  ///   values: _dollarsRange,
  ///   min: 20.0,
  ///   max: 330.0,
  ///   onChanged: (RangeValues newValues) {
  ///     setState(() {
  ///       _dollarsRange = newValues;
  ///     });
  ///   },
  ///   semanticFormatterCallback: (double newValue) {
  ///     return '${newValue.round()} dollars';
  ///   }
  ///  )
  /// ```
  /// {@end-tool}
  final SemanticFormatterCallback semanticFormatterCallback;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        // This essentially makes the track within the selected range
        // to look slim just like the ones outside the range.
        //
        rangeTrackShape: RectangularRangeSliderTrackShape(),
        // This property controls how the Thumb (The white button that is slided over the track)
        // looks.
        // To make this conform to the cupertino Design Pattern
        // Some of these properties you may wish to tweak has been
        // provided in the constructor body of this class,
        // use those properties to make the necessary modifications.
        rangeThumbShape: CupertinoRangeSliderThumbShape(
          enabledThumbRadius: thumbRadius,
          // The `disabledThumbRadius` is made to be the same
          // as the `enabledThumbRadius`.
          disabledThumbRadius: thumbRadius,
          // This overrides the defult [BoxShadow]s painted below the Thumb.
          // You can ovveride this method by passing the `thumbShadows` parameter
          // in the constructor body of the [CupertinoRangeSlider] Widget.
          boxShadows: thumbShadows,
        ),
        // Sets the inactiveTrackColor to `Colors.grey.shade300`.
        // This is so in order to conform to the cupertino Design Library.
        inactiveTrackColor: inactiveColor ?? Colors.grey[300],
        activeTrackColor: activeColor ?? Theme.of(context).primaryColor,
        // removes the default overlay that usually exists
        // for the Material RangeSlider.
        overlayColor: Colors.transparent,
        // Sets the color to white for iOS
        overlappingShapeStrokeColor: Colors.transparent,
        // This sets the `thumbColor` to white
        // in conformation with the cupertino Design Library.
        thumbColor: CupertinoColors.white,
        // The color to be used in painting the value indicator of the [CupertinoRangeSlider].
        // This Defaults to the activeColor of the [CupertinoRangeSlider].
        // If this is null it is set to the current PrimaryColor of the current [Theme].
        valueIndicatorColor: valueIndicatorColor ??
            activeColor ??
            Theme.of(context).primaryColor,
        activeTickMarkColor: activeTickMarkColor ?? Theme.of(context).colorScheme.onPrimary,
        inactiveTickMarkColor: inactiveTickMarkColor ?? Colors.grey,
        disabledThumbColor: disabledThumbColor,
        showValueIndicator: ShowValueIndicator.onlyForDiscrete,
        trackHeight: trackHeight,
      ),
      child: RangeSlider(
        min: min,
        max: max,
        onChanged: onChanged,
        onChangeStart: onChangeStart,
        onChangeEnd: onChangeEnd,
        values: values,
        divisions: divisions,
        labels: labels,
        semanticFormatterCallback: semanticFormatterCallback,

      ),
    );
  }
}