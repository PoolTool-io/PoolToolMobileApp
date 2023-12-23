import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart' as paint;
import 'package:intl/intl.dart';
import 'package:pegasus_tool/common/label_value_widget.dart';
import 'package:pegasus_tool/models/chart_data_model.dart';
import 'package:pegasus_tool/models/stake_model.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/provider/theme_provider.dart';
import 'package:pegasus_tool/screens/pool/alerts/saturation_alert_widget.dart';
import 'package:pegasus_tool/screens/pool/base_chart/interactive_linear_chart.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/utils.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class StakeChart extends StatelessWidget {
  final StakePool poolSummary;
  final List<Stake?>? stake;
  final num currentEpoch;

  final SelectedPoint selectedPoint = SelectedPoint();
  late List<charts.Series<ChartData, String>> chartData;

  String Function(num?)? measureFormatter =
      (value) => NumberFormat.compactCurrency(
            decimalDigits: 0,
            symbol:
                '₳', // if you want to add currency symbol then pass that in this else leave it empty.
          ).format(value);

  StakeChart(
      {super.key,
      this.stake,
      required this.poolSummary,
      required this.currentEpoch}) {
    chartData = createData();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 0.0, left: 8.0, right: 0.0),
            child: Row(children: [
              const Icon(
                Icons.format_color_fill,
                size: 24.0,
              ),
              const SizedBox(width: 8),
              const Expanded(
                  child: Text("Controlled Stake",
                      style: paint.TextStyle(fontSize: 18.0))),
              SaturationAlertWidget(pool: poolSummary)
            ])),
        const Divider(),
        buildSaturationLevel(context),
        buildStakeChart(context),
        buildActiveLiveStake(context),
      ]),
    );
  }

  Widget buildSaturationLevel(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          InkWell(
              onTap: () {
                showInfoDialog(
                    context, "Live Saturation Level", getStakeDialogMessage());
              },
              child: LinearPercentIndicator(
                barRadius: const Radius.circular(150.0),
                width: MediaQuery.of(context).size.width - 40,
                animation: true,
                animateFromLastPercent: false,
                lineHeight: 24.0,
                percent: min(poolSaturation(poolSummary.ls!), 1.0),
                center: Text(
                    "Live Saturation Level - ${(poolSaturation(poolSummary.ls!) * 100).toStringAsFixed(1)}%",
                    style: const paint.TextStyle(
                        color: Styles.LIVE_SATURATION_LEVEL_TEXT_COLOR,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
                progressColor: getProgressColor(),
                backgroundColor: Styles.LIVE_SATURATION_LEVEL_BACKGROUND_COLOR,
              )),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            getSaturationIcon(poolSummary),
            const SizedBox(width: 2),
            getSaturationMessage(poolSummary),
          ]),
        ]));
  }

  Widget buildStakeChart(BuildContext context) {
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
                      prettyTicks(currentEpoch, chartData[0].data.length - 2))),
              primaryMeasureAxis: charts.NumericAxisSpec(
                  renderSpec: charts.GridlineRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                        color: Styles.chartAxisColor(isDarkTheme)),
                  ),
                  tickFormatterSpec:
                      charts.BasicNumericTickFormatterSpec(measureFormatter)),
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
              animate: true,
            )));
  }

  Widget buildActiveLiveStake(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
              child: LabelValueWidget(
                  onTapFunc: () => {
                        showInfoDialog(context, "Active Stake",
                            "A snapshot of the controlled stake of the pool was taken at the beginning of epoch ${currentEpoch - 2}, which determines the chances for being a slot leader and the number of blocks this pool is expected to produce in the current epoch ($currentEpoch). \n\n${getStakeDialogMessage()}")
                      },
                  textAlign: TextAlign.left,
                  valueColor: getActiveStakeColor(),
                  label: "Active stake",
                  value: "₳${getFormatActiveStake()}")),
          Expanded(
              child: LabelValueWidget(
                  onTapFunc: () => {
                        showInfoDialog(context, "Live stake",
                            "This is the stake controlled by the pool in the current epoch ($currentEpoch) and the amount can change any time until a snapshot is taken at the beginning of the next epoch.\n\n${getStakeDialogMessage()}")
                      },
                  textAlign: TextAlign.right,
                  valueColor: Styles.INACTIVE_COLOR,
                  label: "Live Stake",
                  value: "₳${formatLovelaces(poolSummary.ls)}"))
        ]));
  }

  List<charts.Series<ChartData, String>> createData() {
    List<ChartData> data = [];

    if (stake != null) {
      for (var element in stake!) {
        if (element != null && element.amount! > 0) {
          data.add(
              ChartData(int.parse(element.epoch!), element.amount! / 1000000));
        }
      }

      data.add(ChartData(currentEpoch + 2 as int, poolSummary.ls! / 1000000));
    }

    data.sort((a, b) => a.epoch.compareTo(b.epoch));

    bool foundFirstStake = false;
    var toRemove = [];
    for (var e in data) {
      if (e.value == 0 && foundFirstStake == false) {
        toRemove.add(e);
      }
      if (e.value > 0) {
        foundFirstStake = true;
      }
    }
    data.removeWhere((e) => toRemove.contains(e));

    return [
      charts.Series<ChartData, String>(
        id: 'Saturation',
        colorFn: (ChartData data, _) {
          var greenShades = charts.MaterialPalette.green.makeShades(2);
          if (data.epoch == currentEpoch + 2) {
            return charts.MaterialPalette.gray.shadeDefault;
          } else if (data.epoch == currentEpoch) {
            dynamic tear = stakeTearForStake(data.value);

            if (tear == 3) {
              return charts.MaterialPalette.red.shadeDefault;
            } else if (tear == 2) {
              return charts.MaterialPalette.deepOrange.shadeDefault;
            } else {
              return greenShades[1];
            }
          } else {
            return greenShades[0];
          }
        },
        domainFn: (ChartData data, _) => data.epoch.toString(),
        measureFn: (ChartData data, _) => data.value,
        data: data,
      )
    ];
  }

  Color getActiveStakeColor() {
    num? activeStake;

    Stake? currentEpochStake = stake?.firstWhereOrNull(
        (element) => element!.epoch == currentEpoch.toString());

    if (currentEpochStake != null) {
      activeStake = currentEpochStake.amount;
    }

    if (activeStake == null) {
      return Colors.green;
    }

    dynamic tear = stakeTearForStake(activeStake);
    return getColorForTear(tear);
  }

  MaterialColor getProgressColor() {
    dynamic tear = stakeTearForStake(poolSummary.ls);
    return getColorForTear(tear) as MaterialColor;
  }

  Widget getSaturationMessage(dynamic pool) {
    dynamic tear = stakeTearForStake(poolSummary.ls);
    dynamic color = getColorForTear(tear);
    dynamic text = "";
    switch (tear) {
      case 3:
        text = "Saturated pool! DO NOT DELEGATE!";
        break;
      case 2:
        text = "Close to saturation!";
        break;
      default:
        text = "Below saturation!";
    }

    return Text(text,
        style: paint.TextStyle(
            color: color, fontSize: 14.0, fontStyle: FontStyle.normal));
  }

  Widget getSaturationIcon(dynamic pool) {
    dynamic tear = stakeTearForStake(poolSummary.ls);
    dynamic icon = getIcon(pool, tear);
    dynamic color = getColorForTear(tear);
    return Icon(icon, color: color, size: 18);
  }

  String getStakeDialogMessage() {
    if (poolSummary.ls! > 63471361000000) {
      return "This pool is currently saturated and all delegators will get less than ideal rewards as a result of that. New delegators should not join this pool and some existing ones should redelegate to less saturated and performant pools.";
    } else if (poolSummary.ls! > 57124224000000) {
      return "This pool is currently near saturation. Proceed with caution and make sure you enabled saturation alerts.";
    } else {
      return "This pool is currently below saturation and open for delegators.";
    }
  }

  String getFormatActiveStake() {
    Stake? currentEpochStake = stake?.firstWhereOrNull(
        (element) => element!.epoch == currentEpoch.toString());

    if (currentEpochStake != null) {
      return "₳${formatLovelaces(currentEpochStake.amount)}";
    }

    return "₳ ???";
  }
}
