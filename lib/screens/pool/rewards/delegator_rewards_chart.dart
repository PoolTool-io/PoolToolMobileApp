import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart' as paint;
import 'package:intl/intl.dart';
import 'package:pegasus_tool/common/label_value_widget.dart';
import 'package:pegasus_tool/models/chart_data_model.dart';
import 'package:pegasus_tool/models/delegator_rewards_model.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/provider/theme_provider.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/utils.dart';
import 'package:provider/provider.dart';

import '../base_chart/interactive_linear_chart.dart';

class DelegatorRewardsChart extends StatelessWidget {
  final StakePool poolSummary;
  final List<DelegatorsRewards?>? delegatorRewards;
  final num currentEpoch;
  num totalDelegatorRewards = 0;
  num estimatedDelegatorRewards = 0;

  SelectedPoint selectedPoint = SelectedPoint();
  late List<charts.Series<ChartData, String>> chartData;

  String Function(num?)? measureFormatter =
      (value) => NumberFormat.compactCurrency(
            decimalDigits: 0,
            symbol:
                '₳', // if you want to add currency symbol then pass that in this else leave it empty.
          ).format(value);

  DelegatorRewardsChart(
      {super.key,
      this.delegatorRewards,
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
                Icons.people_outline,
                size: 24.0,
              ),
              SizedBox(width: 8),
              Expanded(
                  child: Text("Delegator Rewards",
                      style: paint.TextStyle(fontSize: 18.0))),
              SizedBox(width: 8),
            ])),
        const Divider(),
        buildDelegatorRewardsChart(context),
        buildTotalRewards(context),
      ]),
    );
  }

  Widget buildDelegatorRewardsChart(BuildContext context) {
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
                        .measureFn(model.selectedDatum[0].index));
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
                            "The delegator rewards are estimated from the active stake and the number of blocks produced by this pool in the previous epoch (${(currentEpoch - 1).toString()}).")
                      },
                  textAlign: TextAlign.left,
                  label: "Est. for epoch ${(currentEpoch - 1).toString()}",
                  value:
                      "₳${formatLovelaces(estimatedDelegatorRewards * 1000000)}")),
          Expanded(
              child: LabelValueWidget(
                  onTapFunc: () => {
                        showInfoDialog(context, "Total Delegator Rewards",
                            "The total delegator rewards is the amount this pool has distributed to their delegators in its lifetime. This figure does not include the estimation for the previous epoch.")
                      },
                  textAlign: TextAlign.right,
                  label: "Total",
                  value:
                      "₳${formatLovelaces(totalDelegatorRewards * 1000000)}")),
        ]));
  }

  List<charts.Series<ChartData, String>> createData() {
    List<ChartData> data = [];

    if (delegatorRewards != null) {
      for (var element in delegatorRewards!) {
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
        estimatedDelegatorRewards = e.value;
      } else {
        totalDelegatorRewards += e.value;
      }
      if (e.value == 0 && foundFirstReward == false) {
        toRemove.add(e);
      }
      if (e.value > 0) {
        foundFirstReward = true;
      }
    }
    data.removeWhere((e) => toRemove.contains(e));

    return [
      charts.Series<ChartData, String>(
        id: 'Delegator Rewards',
        colorFn: (data, __) => data.epoch == currentEpoch - 1
            ? charts.MaterialPalette.gray.shadeDefault
            : charts.MaterialPalette.green.shadeDefault,
        domainFn: (ChartData data, _) => data.epoch.toString(),
        measureFn: (ChartData data, _) => data.value,
        data: data,
      )
    ];
  }
}
