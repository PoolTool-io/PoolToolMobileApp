import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pegasus_tool/styles/button_styles.dart';

class Styles {
  /* Main App Color
  * Changes main theme
  */
  // static const Map<int, Color> _color = {
  //   50: Color.fromRGBO(160, 254, 106, 1),
  //   100: Color.fromRGBO(160, 254, 106, 1),
  //   200: Color.fromRGBO(160, 254, 106, 1),
  //   300: Color.fromRGBO(160, 254, 106, 1),
  //   400: Color.fromRGBO(160, 254, 106, 1),
  //   500: Color.fromRGBO(160, 254, 106, 1),
  //   600: Color.fromRGBO(160, 254, 106, 1),
  //   700: Color.fromRGBO(160, 254, 106, 1),
  //   800: Color.fromRGBO(160, 254, 106, 1),
  //   900: Color.fromRGBO(160, 254, 106, 1),
  // };
  static const Color APP_COLOR = Colors.green;
  // static const Color APP_COLOR = MaterialColor(0xFFA0FE6A, _color);
  // Make sure to change this color in pubspec.yaml (for splash screen).

  static const Color PRIMARY_COLOR = Colors.green;
  static const Color SECONDARY_COLOR = Colors.greenAccent;
  static const Color SECONDARY_COLOR_LIGHT = Colors.green;

  /* Common Colors
  *  doesn't need frequent changes
  */
  static const Color DANGER_COLOR = Colors.red;
  static const Color WARNING_COLOR = Colors.orange;
  static const Color SUCCESS_COLOR = Colors.lightGreen;
  static const Color SUCCESS_COLOR2 = Colors.green;
  static const Color ICON_INSIDE_COLOR = Colors.white;
  static const Color INACTIVE_COLOR = Colors.grey;
  static Color INACTIVE_COLOR_DARK = Colors.grey.shade700;
  static const Color DIVIDER_COLOR = Colors.grey;
  static const Color SUCCESS_TOST_BACKGROUND = Colors.blue;

  /* CUSTOM COLORS
  *
  */
  static const Color BACKGROUND_COLOR_DARK = Color(0xFF070F28);
  static const Color CARD_BACKGROUND_COLOR_DARK = Color(0xFF131B33);
  static const Color APP_LABEL_TEXT_COLOR = Colors.greenAccent;
  static const Color TEXT_COLOR_DARK = Colors.white;
  static const Color TEXT_FORM_FIELD_FILL = Color(0xfff3f3f4);
  static const Color SUB_TEXT_COLOR_DARK = Colors.grey;
  static const charts.Color CHART_SELECTED_DATA_LABEL_COLOR_DARK =
      charts.Color.white;
  static const charts.Color CHART_SELECTED_DATA_LABEL_COLOR_LIGHT =
      charts.Color.black;

  /* Specific Colors
  *  for specific color setting in app
  */
  static const Color DECENTRALIZATION_PROGRESS_COLOR = Colors.green;
  static const Color DECENTRALIZATION_BACKGROUND_COLOR = Color(0x88FFBF00);
  static const Color LIVE_SATURATION_LEVEL_TEXT_COLOR = Colors.black;
  static const Color LIVE_SATURATION_LEVEL_BACKGROUND_COLOR =
      Color.fromRGBO(220, 220, 220, 1);

  /* Specific to chart section
  * Changes Domain axis and Primary Axis, label colors
  */
  static charts.Color chartAxisColor(bool isDarkTheme) {
    return isDarkTheme
        ? charts.MaterialPalette.gray.shade200
        : charts.MaterialPalette.gray.shade700;
  }

  static ThemeData darkTheme = ThemeData(
    useMaterial3: false,
    appBarTheme: const AppBarTheme(backgroundColor: BACKGROUND_COLOR_DARK),
    primaryColor: BACKGROUND_COLOR_DARK,
    scaffoldBackgroundColor: BACKGROUND_COLOR_DARK,
    cardColor: CARD_BACKGROUND_COLOR_DARK,
    iconTheme: const IconThemeData(color: Colors.greenAccent),
    bottomAppBarTheme: const BottomAppBarTheme(color: BACKGROUND_COLOR_DARK),
    splashColor: BACKGROUND_COLOR_DARK,
    dividerColor: DIVIDER_COLOR,
    disabledColor: INACTIVE_COLOR,
    unselectedWidgetColor: INACTIVE_COLOR,
    hintColor: INACTIVE_COLOR,
    dialogBackgroundColor: CARD_BACKGROUND_COLOR_DARK,
    toggleButtonsTheme:
        const ToggleButtonsThemeData(disabledColor: INACTIVE_COLOR),
    sliderTheme: const SliderThemeData(inactiveTrackColor: INACTIVE_COLOR),
    dialogTheme: const DialogTheme(
        titleTextStyle: TextStyle(color: TEXT_COLOR_DARK),
        contentTextStyle: TextStyle(color: TEXT_COLOR_DARK),
        backgroundColor: CARD_BACKGROUND_COLOR_DARK),
    textTheme: const TextTheme(
        titleMedium: TextStyle(color: SUB_TEXT_COLOR_DARK),
        bodyMedium: TextStyle(color: TEXT_COLOR_DARK),
        bodyLarge: TextStyle(color: TEXT_COLOR_DARK)),
    colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: PRIMARY_COLOR,
        secondary: SECONDARY_COLOR,
        background: BACKGROUND_COLOR_DARK),
    elevatedButtonTheme: ElevatedButtonThemeData(style: raisedButtonStyle),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return Colors.greenAccent;
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return Colors.greenAccent;
        }
        return null;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return Colors.greenAccent;
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return Colors.greenAccent;
        }
        return null;
      }),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    appBarTheme: const AppBarTheme(color: APP_COLOR),
    iconTheme: const IconThemeData(color: APP_COLOR),
    dividerColor: DIVIDER_COLOR,
    splashColor: Colors.white,
    textTheme: const TextTheme(
      titleMedium: TextStyle(color: SUB_TEXT_COLOR_DARK),
    ),
    dialogTheme: const DialogTheme(
        titleTextStyle: TextStyle(color: Colors.white),
        contentTextStyle: TextStyle(color: SUB_TEXT_COLOR_DARK),
        backgroundColor: Colors.white),
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: PRIMARY_COLOR,
        secondary: SECONDARY_COLOR_LIGHT,
        background: Colors.white),
    elevatedButtonTheme: ElevatedButtonThemeData(style: raisedButtonStyle),
  );

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return isDarkTheme ? darkTheme : lightTheme;
  }
}
