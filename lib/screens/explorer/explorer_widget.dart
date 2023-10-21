import 'dart:async';
import 'dart:developer';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/common/admin_message_widget.dart';
import 'package:pegasus_tool/common/color_loader.dart';
import 'package:pegasus_tool/config/constants.dart';
import 'package:pegasus_tool/loading.dart';
import 'package:pegasus_tool/models/epoch_model.dart';
import 'package:pegasus_tool/models/epoch_section_model.dart';
import 'package:pegasus_tool/models/recent_block_model.dart';
import 'package:pegasus_tool/repository/epoch_repository.dart';
import 'package:pegasus_tool/repository/mary_db_sync_status_repository.dart';
import 'package:pegasus_tool/repository/recent_block_repository.dart';
import 'package:pegasus_tool/screens/ecosystem/ecosystem_widget.dart';
import 'package:pegasus_tool/screens/explorer/recent_blocks_widget.dart';
import 'package:pegasus_tool/services/epoch_service.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/utils.dart';

class ExplorerWidget extends StatefulWidget {
  const ExplorerWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ExplorerWidgetState();
  }
}

class ExplorerWidgetState extends State<ExplorerWidget> {
  bool mainLoading = true;
  bool epochLoading = true;
  num? selectedEpoch;
  late num currentEpoch;
  RecentBlock? recentBlock;
  bool filterBftPools = true;
  // RecentBlocksWidget recentBlocksWidget = RecentBlocksWidget();

  StreamSubscription<num>? currentEpochSubscription;
  StreamSubscription<RecentBlock>? recentBlockSubscription;
  StreamSubscription<Epoch>? epochSubscription;
  var animate = true;

  var showProgress = true;
  var progress = 0;

  var showBlocks = true;
  var showTransactions = true;
  var showFees = true;
  var showOutput = true;
  var showMessage = true;

  var blocks = "";
  var transactions = "";
  var fees = 0;
  var output = 0;
  var message = "";

  var margin = charts.MarginSpec.fixedPixel(0);

  MaryDbSyncStatusRepository maryDbSyncStatusRepository =
      GetIt.I<MaryDbSyncStatusRepository>();

  RecentBlockRepository recentBlockRepository =
      GetIt.I<RecentBlockRepository>();

  EpochRepository epochRepository = GetIt.I<EpochRepository>();

  EpochService epochService = GetIt.I<EpochService>();

  @override
  void initState() {
    super.initState();

    currentEpochSubscription = epochService.currentEpochStream.listen((epoch) {
      currentEpoch = epoch;
      onEpochUpdated(currentEpoch);
    }, onError: (Object o) {
      log(o.toString());
    });

    epochService.getCurrentEpoch();

    recentBlockSubscription =
        recentBlockRepository.getRecentBlock().listen((block) {
      recentBlock = block;
    }, onError: (Object o) {
      log(o.toString());
    });
  }

  void onEpochUpdated(num epoch) {
    setState(() {
      mainLoading = false;
    });

    epochService.selectedEpoch = epoch;

    updateEpochSummary();

    // recentBlocksWidget.setBlocksRef(
    //     firebaseDatabase
    //         .ref()
    //         .child('${getEnvironment()}/blocks/$selectedEpoch')
    //         .orderByChild("block"),
    //     "Blocks in Epoch $selectedEpoch");
  }

  void updateEpochSummary() {
    animate = true;
    epochSubscription?.cancel();

    epochSubscription =
        epochRepository.getEpoch(epochService.selectedEpoch!).listen((epoch) {
      setState(() {
        showBlocks = epoch.blocks.toString() == blocks;
        showTransactions = epoch.transactions.toString() == transactions;
        showFees = epoch.fees == fees;
        showOutput = epoch.totalOutput == output;
        showMessage = false;
        showProgress = false;
        if (recentBlock != null) {
          progress =
              (recentBlock!.slot! / Constants.EPOCH_LENGTH.toDouble() * 100)
                  .toInt();
        } else {
          progress = 0;
        }
        epochLoading = false;
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) {
            return;
          }
          setState(() {
            blocks = epoch.blocks.toString();
            transactions = epoch.transactions.toString();
            fees = epoch.fees as int;
            output = epoch.totalOutput as int;
            if (recentBlock != null) {
              num secondsTillEpochEnds =
                  Constants.EPOCH_LENGTH - recentBlock!.slot!;
              message =
                  "Ends in ${timeUntil(DateTime.now().add(Duration(seconds: secondsTillEpochEnds as int)))}";
            } else {
              message = "";
            }
            showProgress = true;
            showBlocks = true;
            showTransactions = true;
            showFees = true;
            showOutput = true;
            showMessage = true;
          });
        });
      });
    }, onError: (Object o) {
      log(o.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    currentEpochSubscription?.cancel();
    recentBlockSubscription?.cancel();
    epochSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (mainLoading) {
      return const LoadingWidget();
    } else {
      var epochs = <String>[];
      for (int i = 208; i <= currentEpoch; i++) {
        epochs.add(i.toString());
      }
      var widget = SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const AdminMessageWidget(),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        !epochLoading
                            ? Row(children: [
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      DropdownButton<String>(
                                        value: epochService.selectedEpoch
                                            .toString(),
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        dropdownColor:
                                            Theme.of(context).cardColor,
                                        iconEnabledColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        iconSize: 22,
                                        elevation: 16,
                                        underline: Container(
                                          height: 0,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ),
                                        onChanged: (String? newValue) {
                                          onEpochUpdated(int.parse(newValue!));
                                        },
                                        items: epochs
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text("Epoch $value",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .color,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          );
                                        }).toList(),
                                      ),
                                      AnimatedOpacity(
                                        opacity: showMessage ? 1.0 : 0.0,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: Text(message,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color,
                                                fontStyle: FontStyle.italic)),
                                      ),
                                    ])),
                                SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: Stack(
                                        alignment: AlignmentDirectional.center,
                                        children: [
                                          SpinKitPulse(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              size: 60),
                                          charts.PieChart<int>(createData(),
                                              layoutConfig: charts.LayoutConfig(
                                                  leftMarginSpec: margin,
                                                  topMarginSpec: margin,
                                                  rightMarginSpec: margin,
                                                  bottomMarginSpec: margin),
                                              animate: animate,
                                              defaultRenderer:
                                                  charts.ArcRendererConfig(
                                                      arcWidth: 11)),
                                          AnimatedOpacity(
                                              opacity: showProgress ? 1.0 : 0.0,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              child: Text(
                                                "$progress%",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .color,
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ))
                                        ])),
                              ])
                            : Container(),
                        const SizedBox(height: 16),
                        !epochLoading
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        AnimatedOpacity(
                                          opacity: showBlocks ? 1.0 : 0.0,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          child: Text(format(blocks),
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ),
                                        Text("Blocks",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .color)),
                                        const SizedBox(height: 16),
                                        AnimatedOpacity(
                                            opacity: showFees ? 1.0 : 0.0,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            child: Text(
                                                "₳${formatLovelaces(fees)}",
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.normal))),
                                        Text("Total fees",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .color))
                                      ],
                                    )),
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                          AnimatedOpacity(
                                              opacity:
                                                  showTransactions ? 1.0 : 0.0,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              child: Text(format(transactions),
                                                  textAlign: TextAlign.right,
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.normal))),
                                          Text("Transactions",
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .color)),
                                          const SizedBox(height: 16),
                                          AnimatedOpacity(
                                            opacity: showOutput ? 1.0 : 0.0,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            child: Text(
                                                "₳${formatLovelaces(output)}",
                                                textAlign: TextAlign.right,
                                                style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ),
                                          Text("Total output",
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .color))
                                        ])),
                                  ])
                            : const ColorLoader(dotThreeColor: Styles.APP_COLOR)
                      ])))),
//          epochSummaryWidget,
          EcosystemWidget(currentEpoch: currentEpoch.toString()),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text("---------- ",
                style:
                    TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal)),
            SpinKitPulse(
                color: Theme.of(context).colorScheme.secondary, size: 16),
            const Text(" Recent Blocks ",
                style:
                    TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal)),
            SpinKitPulse(
                color: Theme.of(context).colorScheme.secondary, size: 16),
            const Text(" ----------",
                style:
                    TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal)),
          ]),
          const RecentBlocksWidget(),
          const SizedBox(height: 40),
        ],
      ));
      if (!epochLoading) {
        animate = false;
      }
      return widget;
    }
  }

  List<charts.Series<EpochSection, int>> createData() {
    final data = [EpochSection(0, progress), EpochSection(1, 100 - progress)];
    return [
      charts.Series<EpochSection, int>(
          id: 'EpochSection',
          domainFn: (EpochSection es, _) => es.x,
          measureFn: (EpochSection es, _) => es.y,
          data: data,
          colorFn: (es, n) => charts.MaterialPalette.green.makeShades(2)[n!])
    ];
  }
}
