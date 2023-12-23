import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart' as paint;
import 'package:intl/intl.dart';
import 'package:pegasus_tool/common/label_value_widget.dart';
import 'package:pegasus_tool/models/pool_fees_model.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/provider/theme_provider.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/utils.dart';
import 'package:provider/provider.dart';

import '../base_chart/interactive_linear_chart.dart';

class PoolRewardsChart extends StatelessWidget {
  final StakePool poolSummary;
  final List<PoolFees?>? poolRewards;
  final num currentEpoch;
  num totalPoolRewards = 0;
  num estimatedPoolRewards = 0;

  SelectedPoint selectedPoint = SelectedPoint();
  late List<charts.Series<ChartData, String>> chartData;

  String Function(num?)? measureFormatter =
      (value) => NumberFormat.compactCurrency(
            decimalDigits: 0,
            symbol:
                '₳', // if you want to add currency symbol then pass that in this else leave it empty.
          ).format(value);

  PoolRewardsChart(
      {super.key,
      this.poolRewards,
      required this.poolSummary,
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
                Icons.person_outline,
                size: 24.0,
              ),
              SizedBox(width: 8),
              Expanded(
                  child: Text("Pool Rewards",
                      style: paint.TextStyle(fontSize: 18.0))),
              SizedBox(width: 8),
            ])),
        const Divider(),
        buildPoolFeesChart(context),
        buildTotalRewards(context),
      ]),
    );
  }

  Widget buildPoolFeesChart(BuildContext context) {
    bool? isDarkTheme =
        Provider.of<ThemeProvider>(context, listen: false).darkTheme;
    return Padding(
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 0.0, left: 8.0, right: 0.0),
        child: SizedBox(
            height: 175,
            child: charts.BarChart(
              chartData,
              domainAxis: charts.OrdinalAxisSpec(
                  renderSpec: charts.SmallTickRendererSpec(
                      labelStyle: charts.TextStyleSpec(
                          color: Styles.chartAxisColor(isDarkTheme!)),
                      lineStyle: charts.LineStyleSpec(
                          color: Styles.chartAxisColor(isDarkTheme))),
                  tickProviderSpec: charts.StaticOrdinalTickProviderSpec(
                      prettyTicks(currentEpoch, chartData[0].data.length))),
              behaviors: [
                charts.LinePointHighlighter(
                    symbolRenderer: CustomCircleSymbolRenderer(
                        isDarkTheme: isDarkTheme, selectedPoint: selectedPoint))
              ],
              selectionModels: [
                charts.SelectionModelConfig(
                    changedListener: (charts.SelectionModel model) {
                  if (model.hasDatumSelection) {
                    selectedPoint.value = measureFormatter!(model
                        .selectedSeries[0]
                        .measureFn(model.selectedDatum[0].index)!);
                  }
                })
              ],
              primaryMeasureAxis: charts.NumericAxisSpec(
                  renderSpec: charts.GridlineRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                        color: Styles.chartAxisColor(isDarkTheme)),
                  ),
                  tickFormatterSpec:
                      charts.BasicNumericTickFormatterSpec(measureFormatter)),
              animate: true,
            )));
  }

  Widget buildTotalRewards(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
              child: LabelValueWidget(
                  onTapFunc: () => {
                        showInfoDialog(context, "Estimated Rewards",
                            "The pool rewards are estimated from the active stake and the number of blocks produced by this pool in the previous epoch (${(currentEpoch - 1).toString()}).")
                      },
                  textAlign: TextAlign.left,
                  label: "Est. for epoch ${(currentEpoch - 1).toString()}",
                  value:
                      "₳${formatLovelaces(estimatedPoolRewards * 1000000)}")),
          Expanded(
              child: LabelValueWidget(
                  onTapFunc: () => {
                        showInfoDialog(context, "Total Pool Rewards",
                            "The total pool rewards is the sum of fixed and variable fees this pool received for producing blocks in its lifetime. This figure does not include the estimation for the previous epoch.")
                      },
                  textAlign: TextAlign.right,
                  label: "Total",
                  value: "₳${formatLovelaces(totalPoolRewards * 1000000)}")),
        ]));
  }

  List<charts.Series<ChartData, String>> createData() {
    List<ChartData> data = [];

    if (poolRewards != null) {
      for (var element in poolRewards!) {
        if (element != null && element.amount! > 0) {
          data.add(
              ChartData(int.parse(element.epoch!), element.amount! / 1000000));
        }
      }
    }

    data.sort((a, b) => a.epoch.compareTo(b.epoch));

    bool foundFirstReward = false;
    var toRemove = [];
    for (var e in data) {
      if (e.epoch == currentEpoch - 1) {
        estimatedPoolRewards = e.reward;
      } else {
        totalPoolRewards += e.reward;
      }
      if (e.reward < 2 && foundFirstReward == false) {
        toRemove.add(e);
      }
      if (e.reward > 2) {
        foundFirstReward = true;
      }
    }
    data.removeWhere((e) => toRemove.contains(e));

    return [
      charts.Series<ChartData, String>(
        id: 'Pool Rewards',
        colorFn: (data, __) => data.epoch == currentEpoch - 1
            ? charts.MaterialPalette.gray.shadeDefault
            : charts.MaterialPalette.green.shadeDefault,
        domainFn: (ChartData data, _) => data.epoch.toString(),
        measureFn: (ChartData data, _) => data.reward,
        data: data,
      )
    ];
  }
}

class ChartData {
  final int epoch;
  final num reward;

  ChartData(this.epoch, this.reward);
}
