import 'dart:async';

import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart' as paint;
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/common/label_value_widget.dart';
import 'package:pegasus_tool/loading.dart';
import 'package:pegasus_tool/models/chart_data_model.dart';
import 'package:pegasus_tool/models/stake_history_model.dart';
import 'package:pegasus_tool/provider/theme_provider.dart';
import 'package:pegasus_tool/repository/stake_hist_repository.dart';
import 'package:pegasus_tool/screens/pool/base_chart/interactive_linear_chart.dart';
import 'package:pegasus_tool/screens/pool/pool_details.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/utils.dart';
import 'package:provider/provider.dart';

class VerifiedAccountWidget extends StatefulWidget {
  final User user;
  final String? stakeKeyHash;
  final String? nickname;
  final num currentEpoch;
  final bool isRewardProcessing;

  const VerifiedAccountWidget(
      {Key? key,
      required this.isRewardProcessing,
      required this.user,
      required this.stakeKeyHash,
      required this.nickname,
      required this.currentEpoch})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VerifiedAccountWidgetState();
  }
}

class _VerifiedAccountWidgetState extends State<VerifiedAccountWidget> {
  late String stakeKeyHash;
  late String nickname;
  bool isLoadingHistory = true;
  List<StakeHistory>? stakeHistory;
  List<charts.Series<ChartData, String>>? rewardsData;

  final SelectedPoint selectedPoint = SelectedPoint();

  StakeHistoryRepository stakeHistoryRepository =
      GetIt.I<StakeHistoryRepository>();
  final FirebaseDatabaseService firebaseDatabaseService =
      GetIt.I<FirebaseDatabaseService>();

  StreamSubscription<List<StakeHistory>>? stakeHistorySubscription;

  @override
  void initState() {
    super.initState();
    stakeKeyHash = widget.stakeKeyHash!;
    nickname = widget.nickname ?? "";
    if (nickname.isEmpty || nickname == 'null') {
      nickname = "${stakeKeyHash.substring(0, 5)}...";
    }
    loadHistory();
  }

  @override
  void dispose() {
    if (stakeHistorySubscription != null) {
      stakeHistorySubscription!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                    child: Text(nickname,
                        style: const paint.TextStyle(fontSize: 18.0))),
                InkWell(
                    onTap: () {
                      showEditNicknameDialog();
                    },
                    child: const Icon(
                      Icons.edit,
                      size: 24.0,
                    )),
                const SizedBox(width: 8),
              ])),
          const Divider(),
          hasNoRewards() && !isLoadingHistory
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("You haven't received any rewards yet.",
                      textAlign: TextAlign.center))
              : Container(),
          hasNoRewards() ? Container() : buildHistoryChart(),
          hasNoRewards() ? Container() : accountSummary(context),
          isLoadingHistory
              ? const Padding(
                  padding: EdgeInsets.all(16), child: LoadingWidget())
              : Container()
        ],
      ),
    );
  }

  void showEditNicknameDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        final nameController = TextEditingController();
        nameController.text = nickname;
        final formKey = GlobalKey<FormState>();

        return AlertDialog(
          title: Text('Edit Account Name',
              style: paint.TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Form(
                    key: formKey,
                    child: TextFormField(
                        validator: nameValidator(),
                        controller: nameController,
                        decoration: const InputDecoration(
                            labelText: "Account Name",
                            border: InputBorder.none,
                            fillColor: Styles.TEXT_FORM_FIELD_FILL,
                            filled: true)))
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
              icon: const Icon(Icons.edit,
                  color: Styles.ICON_INSIDE_COLOR, size: 24),
              label: const Text('Edit',
                  style: paint.TextStyle(color: Colors.white)),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  firebaseDatabaseService.firebaseDatabase
                      .ref()
                      .child(getEnvironment())
                      .child("users")
                      .child("privMeta")
                      .child(widget.user.uid)
                      .child("myAddresses")
                      .child(stakeKeyHash)
                      .child("nickname")
                      .set(nameController.text);
                  setState(() {
                    nickname = nameController.text;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  FormFieldValidator<String> nameValidator() {
    return (value) {
      if (value!.isEmpty || value.length < 3) {
        return 'Enter a valid account name';
      }
      return null;
    };
  }

  void loadHistory() async {
    stakeHistorySubscription = stakeHistoryRepository
        .getStakeHist(stakeKeyHash)
        .listen((stakeHistoryList) {
      List<ChartData> tempData = [];

      for (var stakeHistory in stakeHistoryList) {
        if (stakeHistory.epoch <= widget.currentEpoch - 1) {
          var rewards =
              (stakeHistory.rewards.stakeRewards?.toDouble() ?? 0.0) / 1000000 +
                  (stakeHistory.rewards.operatorRewards?.toDouble() ?? 0.0) /
                      1000000;
          tempData.add(ChartData(stakeHistory.epoch as int, rewards));
        }
      }

      tempData.sort((a, b) => a.epoch.compareTo(b.epoch));

      if (mounted) {
        setState(() {
          stakeHistory = stakeHistoryList;
          rewardsData = [
            charts.Series<ChartData, String>(
              id: 'Rewards',
              colorFn: (data, __) => data.epoch == widget.currentEpoch - 1
                  ? charts.MaterialPalette.gray.shadeDefault
                  : charts.MaterialPalette.green.shadeDefault,
              domainFn: (ChartData data, _) => data.epoch.toString(),
              measureFn: (ChartData data, _) => data.value,
              data: tempData,
            ),
          ];
          isLoadingHistory = false;
        });
      }
    });
  }

  Widget buildHistoryChart() {
    bool? isDarkTheme =
        Provider.of<ThemeProvider>(context, listen: false).darkTheme;
    return Padding(
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 16.0, left: 8.0, right: 8.0),
        child: SizedBox(
            height: 175,
            child: charts.BarChart(
              rewardsData!,
              behaviors: [
                LinePointHighlighter(
                    symbolRenderer: CustomCircleSymbolRenderer(
                        isDarkTheme:
                            Provider.of<ThemeProvider>(context, listen: true)
                                    .darkTheme ??
                                false,
                        selectedPoint: selectedPoint))
              ],
              selectionModels: [
                SelectionModelConfig(changedListener: (SelectionModel model) {
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
                          widget.currentEpoch, rewardsData![0].data.length))),
              animate: true,
            )));
  }

  bool hasNoRewards() => getLastRewards() == null;

  ChartData? getLastRewards() {
    try {
      return rewardsData?.last.data.firstWhereOrNull(
          (element) => element.epoch == widget.currentEpoch - 2);
    } on dynamic catch (_) {
      return null;
    }
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
                    value: widget.isRewardProcessing
                        ? "Processing..."
                        : "₳${format(getLastRewards()!.value)}",
                    valueFontSize: widget.isRewardProcessing ? 11.0 : 16.0),
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
                    valueFontSize: widget.isRewardProcessing ? 11.0 : 16.0,
                    value: widget.isRewardProcessing
                        ? "Processing..."
                        : "₳${getEstimatedRewards() == null ? "0" : format(getEstimatedRewards()?.value)}"),
              ]),
          const Divider(),
          getDelegatedPool(context)
        ]));
  }

  num totalRewards() {
    num total = 0;
    for (var d in rewardsData!.last.data) {
      if (d.epoch != widget.currentEpoch - 1) {
        total += d.value;
      }
    }
    return total;
  }

  ChartData? getEstimatedRewards() {
    try {
      return rewardsData!.last.data
          .firstWhere((element) => element.epoch == widget.currentEpoch - 1);
    } on dynamic catch (_) {
      return null;
    }
  }

  Widget getDelegatedPool(context) {
    StakeHistory? lastEpochHistory = stakeHistory
        ?.firstWhereOrNull((element) => element.epoch == widget.currentEpoch);
    lastEpochHistory ??= stakeHistory?.firstWhereOrNull(
        (element) => element.epoch == widget.currentEpoch - 1);
    lastEpochHistory ??= stakeHistory?.firstWhereOrNull(
        (element) => element.epoch == widget.currentEpoch - 2);

    String? poolId = "";
    String? poolName = "Unknown";

    if (lastEpochHistory != null) {
      poolId = lastEpochHistory.rewards.delegatedTo;
      poolName = lastEpochHistory.rewards.delegatedToTicker;
      if (poolName == null || poolName.isEmpty) {
        poolName = "${poolId!.substring(0, 4)}...";
      }
    }
    return InkWell(
        onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PoolDetails(poolId: poolId!)),
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
}
