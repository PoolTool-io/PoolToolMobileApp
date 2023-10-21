import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/common/label_value_widget.dart';
import 'package:pegasus_tool/config/constants.dart';
import 'package:pegasus_tool/loading.dart';
import 'package:pegasus_tool/screens/explorer/recent_pool_updates_widget.dart';
import 'package:pegasus_tool/screens/pool/relay_info.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';
import 'package:pegasus_tool/utils.dart';

class EcosystemWidget extends StatefulWidget {
  final String currentEpoch;

  const EcosystemWidget({Key? key, required this.currentEpoch})
      : super(key: key);

  @override
  State<EcosystemWidget> createState() {
    return EcosystemWidgetState();
  }
}

class EcosystemWidgetState extends State<EcosystemWidget> {
  bool loading = true;
  late StreamSubscription<DatabaseEvent> ecosystemSubscription;
  var ecosystem;
  var circulatingSupply;

  final FirebaseDatabaseService firebaseDatabaseService =
      GetIt.I<FirebaseDatabaseService>();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
    ecosystemSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const LoadingWidget();
    } else {
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                stakePoolsWidget(context),
                const SizedBox(height: 8.0),
                const RecentPoolUpdatesWidget(),
                const SizedBox(height: 8.0),
                RelayInfo(
                    onlineRelays: ecosystem['onlineRelays'],
                    offlineRelays: ecosystem['offlineRelays']),
              ]));
    }
  }

  Card stakePoolsWidget(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 0.0, left: 8.0, right: 0.0),
              child: Row(children: const [
                Icon(
                  Icons.public,
                  size: 24.0,
                ),
                SizedBox(width: 8),
                Expanded(
                    child:
                        Text("Stake Pools", style: TextStyle(fontSize: 18.0))),
              ])),
          const Divider(),
          Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        LabelValueWidget(
                            onTapFunc: () {
                              showInfoDialog(context, "Registered",
                                  "This is currently the number of registered pools.");
                            },
                            label: "Active",
                            value: format(ecosystem['activePools'])),
                        LabelValueWidget(
                            onTapFunc: () {
                              showInfoDialog(context, "Average cost per epoch",
                                  "This is the average cost per epoch calculated from the active pools with less than ₳10K fixed cost.");
                            },
                            label: "Average cost per epoch",
                            value:
                                "₳${formatLovelaces(ecosystem['averageFixedFee'])}"),
                        LabelValueWidget(
                            onTapFunc: () {
                              showInfoDialog(context, "Average pledge",
                                  "This is the average pool pledge calculated from the active pools.");
                            },
                            label: "Average pledge",
                            value:
                                "₳${formatLovelaces(ecosystem['averagePledge'])}"),
                        LabelValueWidget(
                            onTapFunc: () {
                              showInfoDialog(context, "Delegators",
                                  "Ada owners can participate in the network and earn rewards by delegating the stake associated with their ada holdings to a stake pool. This is the number of active delegations on the network and not necessarily represent unique individuals.");
                            },
                            label: "Delegators",
                            value: format(ecosystem['delegators'])),
                        LabelValueWidget(
                            onTapFunc: () {
                              showInfoDialog(context, "Saturation",
                                  Constants.SATURATION_INFO);
                            },
                            textAlign: TextAlign.left,
                            label: "Saturated",
                            value: ecosystem['saturated'].toString()),
//                    LabelValueWidget(
//                        onTapFunc: () {},
//                        label: "Treasury balance",
//                        value: "₳" + formatLovelaces(
//                            ecosystem['treasury'])),
                      ],
                    )),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                          LabelValueWidget(
                              onTapFunc: () {
                                showInfoDialog(
                                    context,
                                    "Desired number of pools",
                                    "\"K\" is the targeted number of desired pools. Once a pool reaches the point of saturation, it will offer diminishing rewards. The saturation mechanism was designed to prevent centralization by encouraging delegators to delegate to different stake pools, and to incentivize operators to set up alternative pools so that they can continue earning maximum rewards. Saturation, therefore, exists to preserve the interests of both ada holders delegating their stake and stake pool operators, and to prevent any single pool from becoming too large.");
                              },
                              textAlign: TextAlign.right,
                              label: "Desired",
                              value: format(ecosystem['desiredPoolNumber'])),
                          LabelValueWidget(
                              onTapFunc: () {
                                showInfoDialog(context, "Average profit margin",
                                    "This is the average profit margin calculated from the active pools with less than 99% variable fee.");
                              },
                              textAlign: TextAlign.right,
                              label: "Average profit margin",
                              value: ecosystem['averageVariableFee']
                                      .toStringAsFixed(2) +
                                  "%"),
                          LabelValueWidget(
                              onTapFunc: () {
                                showInfoDialog(context, "Total Pledge",
                                    "The sum of honored pledge for all registered pools.");
                              },
                              textAlign: TextAlign.right,
                              label: "Total Pledge",
                              value:
                                  "₳${formatLovelaces(ecosystem['totalPledge'])}"),
                          LabelValueWidget(
                              onTapFunc: () {
                                showInfoDialog(context, "Total Delegated",
                                    "Currently ${formatToMillionsOfAda(ecosystem['totalStaked'])} of the circulating supply is delegated to stake pools.");
                              },
                              textAlign: TextAlign.right,
                              label: "Total Delegated",
                              value: formatToMillionsOfAda(
                                      ecosystem['totalStaked']) +
                                  getStakedPercentage()),
                          LabelValueWidget(
                              onTapFunc: () {
                                showInfoDialog(context, "Saturation Level",
                                    Constants.SATURATION_INFO);
                              },
                              textAlign: TextAlign.right,
                              label: "Saturation Level",
                              value: formatToMillionsOfAda(
                                  ecosystem['saturation'])),
                        ])),
                  ])),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void loadData() async {
    circulatingSupply = (await firebaseDatabaseService.firebaseDatabase
            .ref()
            .child(
                '${getEnvironment()}/circulating_supply/${widget.currentEpoch}')
            .once())
        .snapshot
        .value;

    var ecosystemRef = firebaseDatabaseService.firebaseDatabase
        .ref()
        .child('${getEnvironment()}/ecosystem');
    ecosystemSubscription = ecosystemRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        loading = false;
        ecosystem = event.snapshot.value;
      });
    }, onError: (Object o) {
      log(o.toString());
    });
  }

  String getStakedPercentage() {
    if (ecosystem['totalStaked'] == null || circulatingSupply == null) {
      return "";
    }
    return "(${((ecosystem['totalStaked'] / circulatingSupply) * 100).toStringAsFixed(2)}%)";
  }
}
