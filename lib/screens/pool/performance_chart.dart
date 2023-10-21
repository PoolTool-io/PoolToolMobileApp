import 'dart:async';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:expandable/expandable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart' as paint;
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/provider/theme_provider.dart';
import 'package:pegasus_tool/screens/pool/alerts/add_performance_alert_dialog.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';
import 'package:pegasus_tool/services/firebase_messaging_service.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/utils.dart';
import 'package:provider/provider.dart';

import 'base_chart/interactive_linear_chart.dart';

class PerformanceChart extends StatefulWidget {
  final dynamic performance;
  final dynamic poolSummary;

  const PerformanceChart({super.key, this.performance, this.poolSummary});

  @override
  PerformanceChartState createState() => PerformanceChartState();
}

class PerformanceChartState extends State<PerformanceChart> {
  dynamic performance;
  SelectedPoint selectedPoint = SelectedPoint();
  dynamic performanceAlert;

  late StreamSubscription alertValueSubscription;
  late StreamSubscription alertDeletionSubscription;

  final FirebaseMessagingService firebaseMessagingService =
      GetIt.I<FirebaseMessagingService>();
  final FirebaseDatabaseService firebaseDatabaseService =
      GetIt.I<FirebaseDatabaseService>();

  @override
  void initState() {
    super.initState();
    performance = widget.performance;
    initAlert();
  }

  @override
  Widget build(BuildContext context) {
    bool? isDarkTheme =
        Provider.of<ThemeProvider>(context, listen: false).darkTheme;
    return Padding(
      padding: const EdgeInsets.only(
          top: 16.0, bottom: 0.0, left: 12.0, right: 12.0),
      child: Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 0.0, left: 8.0, right: 8.0),
              child: Row(children: [
                const Icon(
                  Icons.accessibility_new,
                  size: 24.0,
                ),
                const SizedBox(width: 8),
                const Expanded(
                    child: Text("Performance",
                        style: paint.TextStyle(fontSize: 18.0))),
                getLivePerformance()
              ])),
          const Divider(),
          Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
              child: Text(
                  "The performance is measured by how many blocks the stake pool has produced compared to how many it was nominated to produce. Performance ratings make more sense over a longer period of time. If a pool has not yet been selected to produce a block in the current epoch, its performance rating will be 0%.",
                  style: paint.TextStyle(
                      fontSize: 13.0,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).textTheme.titleMedium!.color))),
          Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 0.0, left: 8.0, right: 0.0),
              child: SizedBox(
                  height: 175,
                  child: charts.LineChart(createData(),
                      behaviors: [
                        charts.LinePointHighlighter(
                            symbolRenderer: CustomCircleSymbolRenderer(
                                isDarkTheme: isDarkTheme ?? false,
                                selectedPoint: selectedPoint))
                      ],
                      selectionModels: [
                        charts.SelectionModelConfig(
                            changedListener: (charts.SelectionModel model) {
                          if (model.hasDatumSelection) {
                            selectedPoint.value =
                                "${(model.selectedSeries[0].measureFn(model.selectedDatum[0].index)! * 100).truncateToDouble()}%";
                          }
                        })
                      ],
                      primaryMeasureAxis: charts.PercentAxisSpec(
                        renderSpec: charts.GridlineRendererSpec(
                          labelStyle: charts.TextStyleSpec(
                              color: Styles.chartAxisColor(isDarkTheme!)),
                        ),
                      ),
                      animate: true))),
          Padding(
              padding: const EdgeInsets.only(
                  top: 0.0, bottom: 8.0, left: 8.0, right: 8.0),
              child: Column(
                  children: [const Divider(), buildAlertWidget(context)])),
        ]),
      ),
    );
  }

  List<charts.Series<PerformanceData, int>> createData() {
    List<PerformanceData> data = [];

    if (performance != null) {
      try {
        performance.forEach((epoch, p) {
          if (p != null) {
            data.add(
                PerformanceData(int.parse(epoch), p['performance'].toDouble()));
          }
        });
      } on dynamic catch (_) {
        performance.forEach((p) {
          if (p != null) {
            data.add(PerformanceData(p['epoch'], p['performance'].toDouble()));
          }
        });
      }
    }

    data.sort((a, b) => a.epoch.compareTo(b.epoch));

    return [
      charts.Series<PerformanceData, int>(
        id: 'Performance',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (PerformanceData data, _) => data.epoch,
        measureFn: (PerformanceData data, _) => data.performance.toDouble(),
        data: data,
      )
    ];
  }

  Widget getLivePerformance() {
    dynamic tear = performanceTear(widget.poolSummary);
    dynamic icon = getIcon(widget.poolSummary, tear);
    dynamic color = getColorForTear(tear);
    dynamic iconWidget = Icon(icon, color: color, size: 14);

    return Row(children: <Widget>[
      iconWidget,
      const SizedBox(width: 2),
      Text(formattedPerformance(widget.poolSummary),
          style: paint.TextStyle(color: color))
    ]);
  }

  void initAlert() async {
    String? token = await firebaseMessagingService.firebaseMessaging.getToken();

    DatabaseReference alertRef = firebaseDatabaseService.firebaseDatabase
        .ref()
        .child("ITN1")
        .child("legacy_alerts")
        .child(widget.poolSummary['poolId'])
        .child("performance")
        .child(token!);
    alertRef.keepSynced(true);
    alertDeletionSubscription = alertRef.onChildRemoved
        .listen((DatabaseEvent event) => performanceAlert = null);
    alertValueSubscription = alertRef.onValue.listen(updateAlert);
  }

  @override
  void dispose() {
    alertDeletionSubscription.cancel();
    alertValueSubscription.cancel();
    super.dispose();
  }

  void updateAlert(DatabaseEvent event) {
    setState(() {
      performanceAlert = event.snapshot.value;
    });
  }

  Widget alertText() {
    return Flexible(
        child: Text(
            "You will be notified when this pool ends an epoch below ${performanceAlert['limit']}% performance.",
            textAlign: TextAlign.left));
  }

  Widget removeAlertButton(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: Styles.DANGER_COLOR,
                textStyle: const TextStyle(color: Styles.ICON_INSIDE_COLOR)),
            icon: const Icon(Icons.delete,
                color: Styles.ICON_INSIDE_COLOR, size: 24),
            label: const Text("Delete Alert"),
            onPressed: () {
              deleteAlert(context);
            }));
  }

  void deleteAlert(BuildContext context) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text('Delete Alert!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to delete this alert?')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.DANGER_COLOR),
              icon: const Icon(Icons.delete,
                  color: Styles.ICON_INSIDE_COLOR, size: 24),
              label: const Text('Delete'),
              onPressed: () async {
                String? token =
                    await firebaseMessagingService.firebaseMessaging.getToken();
                firebaseDatabaseService.firebaseDatabase
                    .ref()
                    .child("ITN1")
                    .child("legacy_alerts")
                    .child(widget.poolSummary['poolId'])
                    .child("performance")
                    .child(token!)
                    .remove();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildAlertWidget(BuildContext context) {
    return performanceAlert != null
        ? ExpandablePanel(
            theme: const ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              tapHeaderToExpand: true,
              hasIcon: true,
            ),
            header: Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 0.0, left: 0.0, right: 0.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.alarm_on, size: 24),
                      const SizedBox(width: 8),
                      alertText()
                    ])),
            expanded: Column(children: [
              buildAddAlertButton(context),
              removeAlertButton(context)
            ]),
            collapsed: Container(),
          )
        : buildAddAlertButton(context);
  }

  Widget buildAddAlertButton(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(color: Styles.ICON_INSIDE_COLOR)),
            icon: Icon(performanceAlert != null ? Icons.edit : Icons.add_alert,
                color: Styles.ICON_INSIDE_COLOR, size: 24),
            label: Text(performanceAlert != null
                ? "Edit Alert"
                : "Add Performance Alert"),
            onPressed: () {
              showAddPerformanceAlertDialog(
                  context, widget.poolSummary['poolId']);
            }));
  }
}

class PerformanceData {
  final int epoch;
  final double performance;

  PerformanceData(this.epoch, this.performance);
}
