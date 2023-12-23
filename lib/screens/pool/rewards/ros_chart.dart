import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart' as paint;
import 'package:pegasus_tool/common/label_value_widget.dart';
import 'package:pegasus_tool/models/chart_data_model.dart';
import 'package:pegasus_tool/models/ros_model.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/provider/theme_provider.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/utils.dart';
import 'package:provider/provider.dart';

import '../base_chart/interactive_linear_chart.dart';

class RosChart extends StatelessWidget {
  final StakePool poolSummary;
  final List<Ros?>? ros;
  final num currentEpoch;
  double estimatedRos = 0.0;

  SelectedPoint selectedPoint = SelectedPoint();
  late List<charts.Series<ChartData, int>> chartData;

  RosChart(
      {super.key,
      required this.poolSummary,
      this.ros,
      required this.currentEpoch}) {
    chartData = createData();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        const Padding(
            padding: EdgeInsets.only(
                top: 8.0, bottom: 0.0, left: 8.0, right: 0.0),
            child: Row(children: [
              Icon(
                Icons.replay,
                size: 24.0,
              ),
              SizedBox(width: 8),
              Expanded(
                  child: Text("Return On Stake",
                      style: paint.TextStyle(fontSize: 18.0))),
              SizedBox(width: 8),
            ])),
        const Divider(),
        buildRosChart(context),
        buildEpochAndLifetimeRos(context),
      ]),
    );
  }

  Widget buildRosChart(BuildContext context) {
    bool? isDarkTheme =
        Provider.of<ThemeProvider>(context, listen: false).darkTheme;

    return Padding(
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 0.0, left: 8.0, right: 0.0),
        child: SizedBox(
            height: 175,
            child: charts.LineChart(chartData,
                behaviors: [
                  LinePointHighlighter(
                      symbolRenderer: CustomCircleSymbolRenderer(
                          isDarkTheme: isDarkTheme ?? false,
                          selectedPoint: selectedPoint))
                ],
                selectionModels: [
                  SelectionModelConfig(changedListener: (SelectionModel model) {
                    if (model.hasDatumSelection) {
                      selectedPoint.value =
                          "${(model.selectedSeries[0].measureFn(model.selectedDatum[0].index)! * 100).toStringAsFixed(2)}%";
                    }
                  })
                ],
                domainAxis: charts.NumericAxisSpec(
                    renderSpec: charts.SmallTickRendererSpec(
                        labelStyle: charts.TextStyleSpec(
                            color: Styles.chartAxisColor(isDarkTheme!)),
                        lineStyle: charts.LineStyleSpec(
                            color: Styles.chartAxisColor(isDarkTheme))),
                    viewport: charts.NumericExtents(
                        chartData[0].data.isNotEmpty
                            ? chartData[0].data[0].epoch
                            : currentEpoch - 1,
                        currentEpoch),
                    tickProviderSpec: StaticNumericTickProviderSpec(
                        prettyTicksNum(
                            currentEpoch, chartData[0].data.length))),
                primaryMeasureAxis: charts.PercentAxisSpec(
                    renderSpec: charts.GridlineRendererSpec(
                      labelStyle: charts.TextStyleSpec(
                          color: Styles.chartAxisColor(isDarkTheme)),
                    ),
                    viewport: NumericExtents(0, getMaxRosValue())),
                animate: true)));
  }

  num getMaxRosValue() {
    num max = 0.1;
    for (var d in chartData[0].data) {
      var ros = d.value;
      if (ros > max) {
        max = ros;
      }
    }
    return min(max, 0.8);
  }

  Widget buildEpochAndLifetimeRos(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
              child: LabelValueWidget(
                  onTapFunc: () => {
                        showInfoDialog(context, "Estimated ROS",
                            "The return on stake is estimated from the active stake and the number of blocks produced by this pool in the previous epoch (${(currentEpoch - 1).toString()}).")
                      },
                  textAlign: TextAlign.left,
                  label: "Est. for epoch ${(currentEpoch - 1).toString()}",
                  value: "${(estimatedRos * 100).toStringAsFixed(2)}%")),
          Expanded(
              child: LabelValueWidget(
                  onTapFunc: () => {
                        showInfoDialog(context, "Lifetime Return On Stake",
                            "The ratio of lifetime delegator rewards and pool stake determines the percentage reward for a 5 day epoch. This is then expanded to a full year using a compounding interest formula to show the expected annual ROS.")
                      },
                  textAlign: TextAlign.right,
                  label: "Lifetime ROS",
                  value: "${(poolSummary.lros! * 100).toStringAsFixed(2)}%")),
        ]));
  }

  List<charts.Series<ChartData, int>> createData() {
    List<ChartData> data = [];

    if (ros != null) {
      for (var element in ros!) {
        if (element != null) {
          data.add(ChartData(int.parse(element.epoch!), element.amount! / 100));
        }
      }
    }

    data.sort((a, b) => a.epoch.compareTo(b.epoch));

    bool foundFirstRos = false;
    var toRemove = [];
    for (var e in data) {
      if (e.epoch == currentEpoch - 1) {
        estimatedRos = e.value.toDouble();
      }
      if (e.value == 0.0 && foundFirstRos == false) {
        toRemove.add(e);
      }
      if (e.value > 0.0) {
        foundFirstRos = true;
      }
    }
    data.removeWhere((e) => toRemove.contains(e));

    return [
      charts.Series<ChartData, int>(
        id: 'Roi',
        domainFn: (ChartData data, _) => data.epoch,
        measureFn: (ChartData data, _) => data.value,
        data: data,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
      )
    ];
  }
}
