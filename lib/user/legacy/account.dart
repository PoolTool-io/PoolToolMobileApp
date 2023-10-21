import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart' as paint;
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/common/label_value_widget.dart';
import 'package:pegasus_tool/provider/theme_provider.dart';
import 'package:pegasus_tool/screens/pool/base_chart/interactive_linear_chart.dart';
import 'package:pegasus_tool/screens/pool/pool_details.dart';
import 'package:pegasus_tool/services/firebase_auth_service.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';
import 'package:pegasus_tool/services/firebase_messaging_service.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/user/login_sign_up/add_account_success_widget.dart';
import 'package:pegasus_tool/user/login_sign_up/verify_account_widget.dart';
import 'package:provider/provider.dart';

import '../../utils.dart';

class AccountWidget extends StatefulWidget {
  final dynamic account;
  final num currentEpoch;
  final List<String> userVerifiedAddresses;
  final bool? isRewardProcessing;

  AccountWidget(
      {Key? key,
      this.account,
      required this.currentEpoch,
      required this.userVerifiedAddresses,
      this.isRewardProcessing})
      : super(key: key ?? ValueKey(account['name']));

  @override
  State<StatefulWidget> createState() {
    return _AccountWidgetState();
  }
}

class _AccountWidgetState extends State<AccountWidget> {
  dynamic account;
  final SelectedPoint selectedPoint = SelectedPoint();
  late List<charts.Series<ChartData, String>> rewardsData;

  Action? menuAction;
  String? menuName;

  final FirebaseAuthService firebaseAuthService =
      GetIt.I<FirebaseAuthService>();
  final FirebaseMessagingService firebaseMessagingService =
      GetIt.I<FirebaseMessagingService>();
  final FirebaseDatabaseService firebaseDatabaseService =
      GetIt.I<FirebaseDatabaseService>();

  @override
  void initState() {
    super.initState();
    account = widget.account;
    rewardsData = createData();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 0.0, left: 8.0, right: 0.0),
              child: Row(children: [
                const Icon(
                  Icons.account_balance_wallet,
                  size: 24.0,
                ),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(account['name'],
                        style: const paint.TextStyle(fontSize: 18.0))),
                InkWell(
                    onTap: () {
                      showDeleteAccountDialog();
                    },
                    child: const Icon(
                      Icons.close,
                      size: 24.0,
                    )),
                const SizedBox(width: 8),
              ])),
          const Divider(),
          hasNoRewards()
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("You haven't received any rewards yet.",
                      textAlign: TextAlign.center))
              : Container(),
          hasNoRewards() ? Container() : accountChart(),
          hasNoRewards() ? Container() : accountSummary(context),
          const Divider(),
          verifyAddressWidget()
        ],
      ),
    );
  }

  Widget accountSummary(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 0.0, bottom: 8.0, left: 8.0, right: 8.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Divider(),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                LabelValueWidget(
                    onTapFunc: () {
                      showInfoDialog(context, "Distributed Rewards",
                          "The rewards that were distributed to this account by the protocol for epoch ${(widget.currentEpoch - 2)}.");
                    },
                    label: "Distributed for Epoch ${getLastRewards()!.epoch}",
                    value: widget.isRewardProcessing == null ||
                            widget.isRewardProcessing!
                        ? "Processing..."
                        : "₳${format(getLastRewards()!.value)}",
                    valueFontSize: widget.isRewardProcessing == null ||
                            widget.isRewardProcessing!
                        ? 11.0
                        : 16.0),
                LabelValueWidget(
                    textAlign: TextAlign.right,
                    onTapFunc: () {
                      showInfoDialog(context, "Total Rewards",
                          "The total rewards received by this account in its lifetime. This figure does not include the estimate for the next epoch.");
                    },
                    label: "Total Rewards",
                    value: "₳${format(totalRewards())}"),
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                LabelValueWidget(
                    onTapFunc: () {
                      showInfoDialog(context, "Estimated Rewards",
                          "The account rewards are estimated from the active stake and the number of blocks produced by the pool in the previous epoch (${(widget.currentEpoch - 1).toString()}).");
                    },
                    label:
                        "Estimated for Epoch ${getEstimatedRewards()?.epoch.toString() ?? (widget.currentEpoch - 1).toString()}",
                    valueFontSize: widget.isRewardProcessing == null ||
                            widget.isRewardProcessing!
                        ? 11.0
                        : 16.0,
                    value: widget.isRewardProcessing == null ||
                            widget.isRewardProcessing!
                        ? "Processing..."
                        : "₳${getEstimatedRewards() == null ? "0" : format(getEstimatedRewards()?.value)}"),
              ]),
          const Divider(),
          getDelegatedPool(context)
        ]));
  }

  Widget accountChart() {
    bool? isDarkTheme =
        Provider.of<ThemeProvider>(context, listen: false).darkTheme;
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 16.0, left: 8.0, right: 8.0),
      child: SizedBox(
          height: 175,
          child: charts.BarChart(
            rewardsData,
            behaviors: [
              charts.LinePointHighlighter(
                  symbolRenderer: CustomCircleSymbolRenderer(
                      isDarkTheme:
                          Provider.of<ThemeProvider>(context, listen: true)
                                  .darkTheme ??
                              false,
                      selectedPoint: selectedPoint))
            ],
            selectionModels: [
              charts.SelectionModelConfig(
                  changedListener: (charts.SelectionModel model) {
                if (model.hasDatumSelection) {
                  selectedPoint.value =
                      "₳${format(model.selectedSeries[0].measureFn(model.selectedDatum[0].index))}";
                }
              })
            ],
            primaryMeasureAxis: charts.NumericAxisSpec(
                renderSpec: charts.GridlineRendererSpec(
                  labelStyle: charts.TextStyleSpec(
                      color: Styles.chartAxisColor(isDarkTheme!)),
                ),
                tickFormatterSpec:
                    charts.BasicNumericTickFormatterSpec(measureFormatter)),
            domainAxis: charts.OrdinalAxisSpec(
                renderSpec: charts.SmallTickRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                        color: Styles.chartAxisColor(isDarkTheme)),
                    lineStyle: charts.LineStyleSpec(
                        color: Styles.chartAxisColor(isDarkTheme))),
                tickProviderSpec: charts.StaticOrdinalTickProviderSpec(
                    prettyTicks(
                        widget.currentEpoch, rewardsData[0].data.length))),
            animate: true,
          )),
    );
  }

  bool hasNoRewards() => getLastRewards() == null;

  num totalRewards() {
    num total = 0;
    for (var d in rewardsData.last.data) {
      if (d.epoch != widget.currentEpoch - 1) {
        total += d.value;
      }
    }
    return total;
  }

  ChartData? getLastRewards() {
    try {
      return rewardsData.last.data.firstWhere(
          (element) => element.epoch == widget.currentEpoch - 2,
          orElse: null);
    } on dynamic catch (_) {
      return null;
    }
  }

  ChartData? getEstimatedRewards() {
    try {
      return rewardsData.last.data.firstWhere(
          (element) => element.epoch == widget.currentEpoch - 1,
          orElse: null);
    } on dynamic catch (_) {
      return null;
    }
  }

  List<charts.Series<ChartData, String>> createData() {
    List<ChartData> rewardsData = [];
    var rewards = account['rewards'];

    if (rewards != null) {
      try {
        rewards.forEach((epoch, p) {
          if (p != null) {
            var rewards = p['stakeRewards'].toDouble() / 1000000 +
                p['operatorRewards'].toDouble() / 1000000;
            rewardsData.add(ChartData(p['epoch'], rewards));
          }
        });
      } on dynamic catch (_) {
        rewards.forEach((p) {
          if (p != null) {
            var rewards = p['stakeRewards'].toDouble() / 1000000 +
                p['operatorRewards'].toDouble() / 1000000;
            rewardsData.add(ChartData(p['epoch'], rewards));
          }
        });
      }
    }

    rewardsData.sort((a, b) => a.epoch.compareTo(b.epoch));

    return [
      charts.Series<ChartData, String>(
        id: 'Rewards',
        colorFn: (data, __) => data.epoch == widget.currentEpoch - 1
            ? charts.MaterialPalette.gray.shadeDefault
            : charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ChartData data, _) => data.epoch.toString(),
        measureFn: (ChartData data, _) => data.value,
        data: rewardsData,
      ),
    ];
  }

  Widget getDelegatedPool(context) {
    var poolName =
        (account['poolTicker'] != null && account['poolTicker'].length > 0)
            ? "[${account['poolTicker']}] ${account['poolName']}"
            : account['poolId'];
    return InkWell(
        onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PoolDetails(poolId: account['poolId'])),
              )
            },
        child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              children: [
                const Expanded(child: Text("Delegated to")),
                Expanded(
                    child: Text(poolName,
                        style: paint.TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                        textAlign: TextAlign.right)),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 16.0,
                )
              ],
            )));
  }

  void showDeleteAccountDialog() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Account!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to remove this account?')
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
              label: const Text('Remove'),
              onPressed: () async {
                String? token =
                    await firebaseMessagingService.firebaseMessaging.getToken();
                await firebaseDatabaseService.firebaseDatabase
                    .ref()
                    .child(getEnvironment())
                    .child("legacy_users")
                    .child(token!)
                    .child("accounts")
                    .child(account['name'])
                    .remove();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget verifyAddressWidget() {
    if (isVerified()) {
      return Padding(
          padding: const EdgeInsets.all(8),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Icon(
              Icons.check,
              color: Colors.green,
              size: 24.0,
            ),
            SizedBox(width: 8),
            Text("Verified Account!",
                textAlign: TextAlign.center,
                style: paint.TextStyle(fontSize: 11.0)),
          ]));
    } else {
      return Padding(
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            const Text(
                "Verify your address to keep tracking your rewards beyond 1st January 2022!",
                textAlign: TextAlign.center,
                style: paint.TextStyle(fontSize: 11.0)),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (firebaseAuthService.firebaseAuth.currentUser !=
                          null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VerifyAccountWidget(
                                    address: account["stakeKeyHash"],
                                    password: null,
                                  )),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddAccountSuccessWidget(
                                  showAccountAddedSuccess: false,
                                  address: account["stakeKeyHash"])),
                        );
                      }
                    },
                    child: const Text("Verify")))
          ]));
    }
  }

  bool isVerified() =>
      widget.userVerifiedAddresses.contains(account["stakeKeyHash"]);
}

class ChartData {
  final int epoch;
  final num value;

  ChartData(this.epoch, this.value);
}
