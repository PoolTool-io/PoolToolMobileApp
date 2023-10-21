import 'dart:math';

import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as charts_flutter;
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:pegasus_tool/styles/theme_data.dart';

class CustomCircleSymbolRenderer extends CircleSymbolRenderer {
  SelectedPoint selectedPoint;
  bool isDarkTheme;

  CustomCircleSymbolRenderer(
      {required this.selectedPoint, this.isDarkTheme = false});

  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds,
      {List<int>? dashPattern,
      Color? fillColor,
      FillPatternType? fillPattern,
      Color? strokeColor,
      double? strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    var textStyle = style.TextStyle();
    textStyle.color = isDarkTheme
        ? Styles.CHART_SELECTED_DATA_LABEL_COLOR_DARK
        : Styles.CHART_SELECTED_DATA_LABEL_COLOR_LIGHT;
    textStyle.fontSize = 15;
    canvas.drawText(
        charts_flutter.TextElement(selectedPoint.value.toString(),
            style: textStyle),
        (bounds.left).round(),
        (bounds.top - 28).round());
  }
}

class SelectedPoint {
  dynamic value;
}

List<charts.TickSpec<String>> staticTicks(num currentEpoch) {
  var items = <charts.TickSpec<String>>[];
  num i = 0;
  while (i < currentEpoch) {
    i += 5;
    items.add(charts.TickSpec(i.toString()));
  }

  items.add(charts.TickSpec(currentEpoch.toString()));

  return items;
}

List<charts.TickSpec<String>> prettyTicks(num currentEpoch, num listSize) {
  var items = <charts.TickSpec<String>>[];
  num i = 0;
  var steps;
  if (listSize > 100) {
    steps = 20;
  } else if (listSize > 45) {
    steps = 10;
  } else if (listSize > 40) {
    steps = 9;
  } else if (listSize > 35) {
    steps = 8;
  } else if (listSize > 30) {
    steps = 7;
  } else if (listSize > 25) {
    steps = 6;
  } else if (listSize > 20) {
    steps = 5;
  } else if (listSize > 15) {
    steps = 4;
  } else if (listSize > 10) {
    steps = 3;
  } else if (listSize > 5) {
    steps = 2;
  } else {
    steps = 1;
  }

  while (i < currentEpoch) {
    i += steps;
    items.add(charts.TickSpec(i.toString()));
  }

  return items;
}

List<charts.TickSpec<num>> prettyTicksNum(num currentEpoch, num listSize) {
  var items = <charts.TickSpec<num>>[];
  num i = 0;
  var steps;
  if (listSize > 100) {
    steps = 20;
  } else if (listSize > 45) {
    steps = 10;
  } else if (listSize > 40) {
    steps = 9;
  } else if (listSize > 35) {
    steps = 8;
  } else if (listSize > 30) {
    steps = 7;
  } else if (listSize > 25) {
    steps = 6;
  } else if (listSize > 20) {
    steps = 5;
  } else if (listSize > 15) {
    steps = 4;
  } else if (listSize > 10) {
    steps = 3;
  } else if (listSize > 5) {
    steps = 2;
  } else {
    steps = 1;
  }

  while (i < currentEpoch) {
    i += steps;
    items.add(charts.TickSpec(i));
  }

  return items;
}
