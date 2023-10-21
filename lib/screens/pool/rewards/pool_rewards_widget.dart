import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pegasus_tool/models/pool_stats.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/screens/pool/rewards/pledge_details.dart';
import 'package:pegasus_tool/screens/pool/rewards/pool_rewards_chart.dart';
import 'package:pegasus_tool/screens/pool/rewards/ros_chart.dart';

import 'delegator_rewards_chart.dart';
import 'fee_details.dart';

class PoolRewards extends StatelessWidget {
  final StakePool poolSummary;
  final PoolStats poolStats;
  final num currentEpoch;

  const PoolRewards(
      {Key? key,
      required this.poolSummary,
      required this.poolStats,
      required this.currentEpoch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(children: <Widget>[
              FeeDetails(pool: poolSummary),
              const SizedBox(height: 8),
              PledgeDetails(pool: poolSummary),
              const SizedBox(height: 8),
              RosChart(
                  ros: poolStats.ros!,
                  poolSummary: poolSummary,
                  currentEpoch: currentEpoch),
              const SizedBox(height: 8),
              DelegatorRewardsChart(
                  delegatorRewards: poolStats.delegatorsRewards!,
                  poolSummary: poolSummary,
                  currentEpoch: currentEpoch),
              const SizedBox(height: 8),
              PoolRewardsChart(
                  poolRewards: poolStats.poolFees,
                  poolSummary: poolSummary,
                  currentEpoch: currentEpoch),
              const SizedBox(height: 72),
            ])));
  }
}
