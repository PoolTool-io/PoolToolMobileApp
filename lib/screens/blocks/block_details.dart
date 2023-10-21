import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/common/label_value_widget.dart';
import 'package:pegasus_tool/loading.dart';
import 'package:pegasus_tool/screens/pool/pool_details.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';
import 'package:pegasus_tool/utils.dart';

class BlockDetails extends StatefulWidget {
  final String epoch;
  final String blockNumber;

  const BlockDetails(
      {super.key, required this.epoch, required this.blockNumber});

  @override
  BlockDetailsState createState() => BlockDetailsState();
}

class BlockDetailsState extends State<BlockDetails> {
  late String currentEpoch;
  late String currentBlockNumber;

  var loading = true;
  StreamSubscription<DatabaseEvent>? blockSubscription;

  final FirebaseDatabaseService firebaseDatabaseService =
      GetIt.I<FirebaseDatabaseService>();
  var block;

  @override
  void initState() {
    super.initState();
    currentEpoch = widget.epoch;
    setCurrentBlockNumber(widget.blockNumber);
  }

  void setCurrentBlockNumber(String newBlockNumber) {
    setState(() {
      loading = true;
    });
    currentBlockNumber = newBlockNumber;
    blockSubscription?.cancel();
    blockSubscription = firebaseDatabaseService.firebaseDatabase
        .ref()
        .child('${getEnvironment()}/blocks/$currentEpoch/$currentBlockNumber')
        .onValue
        .listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        setState(() {
          loading = false;
          block = event.snapshot.value;
        });
      }
    }, onError: (Object o) {
      log(o.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    blockSubscription?.cancel();
  }

  String getLeaderName() {
    if (block['leaderPoolTicker'] != null) {
      return "[${block['leaderPoolTicker']}] ${block['leaderPoolName']}";
    } else {
      return block['leaderPoolId'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar: AppBar(
                title: Text("Block number ${format(currentBlockNumber)}")),
            body: Material(
                color: Theme.of(context).colorScheme.background,
                child: loading
                    ? const LoadingWidget()
                    : SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  LabelValueWidget(
                                      onTapFunc: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => PoolDetails(
                                                    poolId:
                                                        block['leaderPoolId'],
                                                  )),
                                        );
                                      },
                                      label: "Slot Leader",
                                      value: getLeaderName()),
                                  LabelValueWidget(
                                      label: "Hash", value: block['hash']),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            LabelValueWidget(
                                                label: "Epoch",
                                                value:
                                                    block['epoch'].toString()),
                                            LabelValueWidget(
                                                label: "Slot",
                                                value: format(block['slot'])),
                                            LabelValueWidget(
                                                label: "Total fees",
                                                value:
                                                    "₳${formatLovelaces(block['fees'])}"),
                                            LabelValueWidget(
                                                onTapFunc: () {
                                                  onPreviousBlockClicked();
                                                },
                                                label: "Previous block",
                                                value:
                                                    format(block['block'] - 1)),
                                          ],
                                        )),
                                        Expanded(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: <Widget>[
                                              LabelValueWidget(
                                                  textAlign: TextAlign.right,
                                                  label: "Time",
                                                  value: timestampToDateTime(
                                                      block['time'])),
                                              LabelValueWidget(
                                                  textAlign: TextAlign.right,
                                                  label: "Size",
                                                  value:
                                                      "${format(block['size'])} Bytes"),
                                              LabelValueWidget(
                                                  textAlign: TextAlign.right,
                                                  label: "Total output",
                                                  value:
                                                      "₳${formatLovelaces(block['output'])}"),
                                              LabelValueWidget(
                                                  onTapFunc: () {
                                                    onNextBlockClicked();
                                                  },
                                                  textAlign: TextAlign.right,
                                                  label: "Next block",
                                                  value: format(
                                                      block['block'] + 1)),
                                            ])),
                                      ]),
                                  const SizedBox(height: 16),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text("----------------"),
                                        Text(
                                            "${block['transactions'].toString()} Transactions"),
                                        const Text("----------------"),
                                      ]),
                                  const SizedBox(height: 32),
                                  Text(
                                      "Transactions details are coming soon...",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .color))
                                ]))))));
  }

  //Note: Epoch change does not work!!
  void onNextBlockClicked() {
    setCurrentBlockNumber((int.parse(currentBlockNumber) + 1).toString());
  }

  void onPreviousBlockClicked() {
    setCurrentBlockNumber((int.parse(currentBlockNumber) - 1).toString());
  }
}
