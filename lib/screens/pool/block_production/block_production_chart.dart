import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart' as paint;
import 'package:pegasus_tool/common/label_value_widget.dart';
import 'package:pegasus_tool/models/blocks_model.dart';
import 'package:pegasus_tool/models/chart_data_model.dart';
import 'package:pegasus_tool/models/ecosystem_model.dart';
import 'package:pegasus_tool/models/stake_model.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/provider/theme_provider.dart';
import 'package:pegasus_tool/screens/pool/base_chart/interactive_linear_chart.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/utils.dart';
import 'package:provider/provider.dart';

import '../alerts/new_block_alert_widget.dart';

class BlockProductionChart extends StatefulWidget {
  final List<Blocks?> blockProduction;
  final num currentEpoch;
  final StakePool poolSummary;
  final Ecosystem ecosystem;
  final List<Stake?> stake;

  const BlockProductionChart(
      {Key? key,
      required this.blockProduction,
      required this.currentEpoch,
      required this.poolSummary,
      required this.ecosystem,
      required this.stake})
      : super(key: key);

  @override
  BlockProductionChartState createState() => BlockProductionChartState();
}

class BlockProductionChartState extends State<BlockProductionChart> {
  List<Blocks?>? remoteData;
  SelectedPoint selectedPoint = SelectedPoint();
  late List<charts.Series<ChartData, String>> chartData;

  @override
  void initState() {
    super.initState();
    remoteData = widget.blockProduction;
    chartData = createData();
  }

  @override
  Widget build(BuildContext context) {
    bool? isDarkTheme =
        Provider.of<ThemeProvider>(context, listen: false).darkTheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 0.0, left: 8.0, right: 0.0),
                child: Row(children: [
                  const Icon(
                    Icons.verified_user,
                    size: 24.0,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                      child: Text("Block Production",
                          style: paint.TextStyle(fontSize: 18.0))),
                  NewBlockAlertWidget(pool: widget.poolSummary)
                ])),
            const Divider(),
            Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8.0, left: 8.0, right: 0.0),
                child: SizedBox(
                    height: 175,
                    child: charts.BarChart(chartData,
                        barGroupingType: charts.BarGroupingType.stacked,
                        domainAxis: charts.OrdinalAxisSpec(
                            renderSpec: charts.SmallTickRendererSpec(
                                labelStyle: charts.TextStyleSpec(
                                    color: Styles.chartAxisColor(isDarkTheme!)),
                                lineStyle: charts.LineStyleSpec(
                                    color: Styles.chartAxisColor(isDarkTheme))),
                            tickProviderSpec:
                                charts.StaticOrdinalTickProviderSpec(
                                    prettyTicks(widget.currentEpoch,
                                        chartData[1].data.length))),
                        behaviors: [
                          LinePointHighlighter(
                              symbolRenderer: CustomCircleSymbolRenderer(
                                  isDarkTheme: isDarkTheme,
                                  selectedPoint: selectedPoint))
                        ],
                        selectionModels: [
                          SelectionModelConfig(
                              changedListener: (SelectionModel model) {
                            if (model.hasDatumSelection) {
                              selectedPoint.value = model.selectedSeries[0]
                                  .measureFn(model.selectedDatum[0].index);
                            }
                          })
                        ],
                        primaryMeasureAxis: charts.NumericAxisSpec(
                          renderSpec: charts.GridlineRendererSpec(
                            labelStyle: charts.TextStyleSpec(
                                color: Styles.chartAxisColor(isDarkTheme)),
                          ),
                        ),
                        animate: true))),
            Text("Total blocks: ${widget.poolSummary.l}",
                style: paint.TextStyle(
                    color: Theme.of(context).textTheme.titleMedium!.color,
                    fontSize: 11)),
            Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(),
                      LabelValueWidget(
                          onTapFunc: () => {
                                showInfoDialog(context, "Produced in epoch",
                                    "The number of block produced by this pool in the current epoch.")
                              },
                          label: "Produced",
                          value: getEpochBlocs(
                                  widget.poolSummary, widget.currentEpoch)
                              .toString()),
                      const Spacer(),
                      LabelValueWidget(
                          textAlign: TextAlign.left,
                          onTapFunc: () => {
                                showInfoDialog(context, "Expected blocks",
                                    "The blocks to be created by this pool is predicted from the active stake and other network parameters. It shows the most likely number of blocks this pool will create by the end of this epoch.\n\nIt is important to understand that the actually produced blocks may be well above or below this number, however that does not necessarily mean a superior or inferior performance compared to other pools. A pool can get extremely lucky or unlucky at the slot election process in an epoch, but long term the law of averages apply.\n\nNote that the pool operators can submit their expected blocks to PoolTool in which case that value is shown here.")
                              },
                          label: "Expected",
                          value: getAssignedBlocksFormatted(
                                  widget.poolSummary,
                                  getCurrentEpochAmount(),
                                  widget.ecosystem,
                                  widget.currentEpoch)
                              .toString()),
                      const Spacer(),
                      LabelValueWidget(
                          textAlign: TextAlign.left,
                          onTapFunc: () => {
                                showInfoDialog(context, "Assigned blocks",
                                    "The number of block assigned to this pool in the current epoch.")
                              },
                          label: "Assigned",
                          value: getExpectedBlocksFormatted(
                                  widget.poolSummary,
                                  getCurrentEpochAmount(),
                                  widget.ecosystem,
                                  widget.currentEpoch)
                              .toString()),
                      const Spacer()
                    ])),
          ],
        ),
      ),
    );
  }

  List<charts.Series<ChartData, String>> createData() {
    List<ChartData> blocks = [];

    if (remoteData != null) {
      for (var element in remoteData!) {
        if (element != null && element.amount! > 0) {
          blocks.add(ChartData(int.parse(element.epoch!), element.amount!));
        }
      }
    }

    blocks.sort((a, b) => a.epoch.compareTo(b.epoch));

    bool foundFirstBlock = false;
    var toRemove = [];
    for (var e in blocks) {
      if (e.value == 0 && foundFirstBlock == false) {
        toRemove.add(e);
      }
      if (e.value > 0) {
        foundFirstBlock = true;
      }
    }
    blocks.removeWhere((e) => toRemove.contains(e));

    List<ChartData> expectedBlocks = [];
    if (blocks.isNotEmpty) {
      for (int i = blocks[0].epoch; i <= widget.currentEpoch; i++) {
        num b;
        if (i == widget.currentEpoch) {
          Stake? currentEpochStake = widget.stake.firstWhereOrNull(
              (element) => element!.epoch == widget.currentEpoch.toString());

          num? poolActiveStake;
          if (currentEpochStake != null) {
            poolActiveStake = currentEpochStake.amount;
          }

          num? assignedBlocks = getAssignedBlocks(widget.poolSummary,
              poolActiveStake, widget.ecosystem, widget.currentEpoch);

          if (assignedBlocks != null) {
            num blockToGo = assignedBlocks.round() -
                getEpochBlocs(widget.poolSummary, widget.currentEpoch);
            b = max(blockToGo, 0);
          } else {
            b = 0;
          }
          // num blockToGo = getAssignedBlocks(
          //             widget.poolSummary,
          //             widget.stake
          //                 .firstWhereOrNull((element) =>
          //                     element!.epoch == widget.currentEpoch.toString())!
          //                 .amount!,
          //             widget.ecosystem,
          //             widget.currentEpoch)
          //         .round() -
          //     getEpochBlocs(widget.poolSummary, widget.currentEpoch);
          // b = max(blockToGo, 0);
        } else {
          b = 0;
        }
        expectedBlocks.add(ChartData(i, b as int));
      }
    }

    return [
      charts.Series<ChartData, String>(
        id: 'ExpectedBlockProduction',
        colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
        domainFn: (ChartData data, _) => data.epoch.toString(),
        measureFn: (ChartData data, _) => data.value,
        data: expectedBlocks,
      ),
      charts.Series<ChartData, String>(
        id: 'BlockProduction',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (ChartData data, _) => data.epoch.toString(),
        measureFn: (ChartData data, _) => data.value,
        data: blocks,
      ),
    ];
  }

  num? getCurrentEpochAmount() {
    Stake? currentEpochStake = widget.stake.firstWhereOrNull(
        (element) => element!.epoch == widget.currentEpoch.toString());

    num? poolActiveStake;
    if (currentEpochStake != null) {
      poolActiveStake = currentEpochStake.amount;
    }

    return poolActiveStake;
  }
}
