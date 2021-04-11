import 'package:flutter/material.dart';

/// Copied from the [Material Library]. Changed only certain things
/// to help further customize the Apps UI to meet our needs.
///
/// A convenience widget that makes a [DropdownButton] into a [FormField].
class DropdownButtonFormFieldModified<T> extends FormField<T> {
  /// Creates a [DropdownButton] widget that is a [FormField], wrapped in an
  /// [InputDecorator].
  ///
  /// For a description of the `onSaved`, `validator`, or `autovalidateMode`
  /// parameters, see [FormField]. For the rest (other than [decoration]), see
  /// [DropdownButton].
  ///
  /// The `items`, `elevation`, `iconSize`, `isDense`, `isExpanded`,
  /// `autofocus`, and `decoration`  parameters must not be null.
  DropdownButtonFormFieldModified({
    this.textStyle,
    Key key,
    @required
    List<DropdownMenuItem<T>> items,
    DropdownButtonBuilder selectedItemBuilder,
    T value,
    Widget hint,
    Widget disabledHint,
    this.onChanged,
    VoidCallback onTap,
    int elevation = 8,
    TextStyle style,
    Alignment textAlignment = Alignment.centerRight,
    Widget icon,
    Color iconDisabledColor,
    Color iconEnabledColor,
    double iconSize = 24.0,
    bool isDense = true,
    bool isExpanded = false,
    double itemHeight,
    Color focusColor,
    FocusNode focusNode,
    bool autofocus = false,
    Color dropdownColor,
    InputDecoration decoration,
    FormFieldSetter<T> onSaved,
    FormFieldValidator<T> validator,
    @Deprecated('Use autovalidateMode parameter which provide more specific '
        'behaviour related to auto validation. '
        'This feature was deprecated after v1.19.0.')
    bool autovalidate = false,
    AutovalidateMode autovalidateMode,
  })  : assert(
  items == null ||
      items.isEmpty ||
      value == null ||
      items.where((DropdownMenuItem<T> item) {
        return item.value == value;
      }).length ==
          1,
  "There should be exactly one item with [DropdownButton]'s value: "
      '$value. \n'
      'Either zero or 2 or more [DropdownMenuItem]s were detected '
      'with the same value',
  ),
        assert(elevation != null),
        assert(iconSize != null),
        assert(isDense != null),
        assert(isExpanded != null),
        assert(itemHeight == null || itemHeight >= kMinInteractiveDimension),
        assert(autofocus != null),
        assert(autovalidate != null),
        assert(
        autovalidate == false ||
            autovalidate == true && autovalidateMode == null,
        'autovalidate and autovalidateMode should not be used together.'),
        decoration = decoration ?? InputDecoration(focusColor: focusColor),
        super(
        key: key,
        onSaved: onSaved,
        initialValue: value,
        validator: validator,
        autovalidateMode: autovalidate
            ? AutovalidateMode.always
            : (autovalidateMode ?? AutovalidateMode.disabled),
        builder: (FormFieldState<T> field) {
          final _DropdownButtonFormFieldState<T> state =
          field as _DropdownButtonFormFieldState<T>;
          final InputDecoration decorationArg =
              decoration ?? InputDecoration(focusColor: focusColor);
          final InputDecoration effectiveDecoration =
          decorationArg.applyDefaults(
            Theme.of(field.context).inputDecorationTheme,
          );
          // An unfocusable Focus widget so that this widget can detect if its
          // descendants have focus or not.
          return Focus(
            canRequestFocus: false,
            skipTraversal: true,
            child: Builder(builder: (BuildContext context) {
              return InputDecorator(
                decoration: effectiveDecoration.copyWith(errorText: field.errorText),
                isEmpty: state.value == null,
                isFocused: Focus.of(context).hasFocus,
                child: Align(
                  alignment: textAlignment,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<T>(
                      items: items,
                      selectedItemBuilder: selectedItemBuilder,
                      value: state.value,
                      hint: hint,
                      disabledHint: disabledHint,
                      onChanged: onChanged == null ? null : state.didChange,
                      onTap: onTap,
                      elevation: elevation,
                      style: style,
                      icon: icon,
                      iconDisabledColor: iconDisabledColor,
                      iconEnabledColor: iconEnabledColor,
                      iconSize: iconSize,
                      isDense: isDense,
                      isExpanded: isExpanded,
                      itemHeight: itemHeight,
                      focusColor: focusColor,
                      focusNode: focusNode,
                      autofocus: autofocus,
                      dropdownColor: dropdownColor,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      );

  /// {@macro flutter.material.dropdownButton.onChanged}
  final ValueChanged<T> onChanged;

  ///
  final TextStyle textStyle;

  /// The decoration to show around the dropdown button form field.
  ///
  /// By default, draws a horizontal line under the dropdown button field but
  /// can be configured to show an icon, label, hint text, and error text.
  ///
  /// If not specified, an [InputDecorator] with the `focusColor` set to the
  /// supplied `focusColor` (if any) will be used.
  final InputDecoration decoration;

  @override
  FormFieldState<T> createState() => _DropdownButtonFormFieldState<T>();
}

class _DropdownButtonFormFieldState<T> extends FormFieldState<T> {
  @override
  DropdownButtonFormFieldModified<T> get widget =>
      super.widget as DropdownButtonFormFieldModified<T>;

  @override
  void didChange(T value) {
    super.didChange(value);
    assert(widget.onChanged != null);
    widget.onChanged(value);
  }

  @override
  void didUpdateWidget(DropdownButtonFormFieldModified<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
  }
}