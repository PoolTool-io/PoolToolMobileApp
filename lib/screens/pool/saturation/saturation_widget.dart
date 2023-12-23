import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pegasus_tool/loading.dart';
import 'package:pegasus_tool/models/live_delegators_model.dart';
import 'package:pegasus_tool/models/stake_model.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/screens/pool/saturation/stake_chart.dart';

import 'preview_delegators_widget.dart';

class SaturationWidget extends StatelessWidget {
  final StakePool poolSummary;
  final List<Stake?> stake;
  final LiveDelegators? delegators;
  final num currentEpoch;

  const SaturationWidget(
      {super.key,
      required this.stake,
      required this.poolSummary,
      required this.delegators,
      required this.currentEpoch});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(children: <Widget>[
              StakeChart(
                  stake: stake,
                  poolSummary: poolSummary,
                  currentEpoch: currentEpoch),
              const SizedBox(height: 8),
              delegators != null
                  ? PreviewDelegatorsWidget(
                      liveDelegators: delegators, poolSummary: poolSummary)
                  : const LoadingWidget(),
              const SizedBox(height: 72)
            ])));
  }
}
