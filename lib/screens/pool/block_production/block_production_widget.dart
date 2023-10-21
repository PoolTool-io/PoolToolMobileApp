import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pegasus_tool/models/ecosystem_model.dart';
import 'package:pegasus_tool/models/pool_stats.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/screens/pool/block_production/block_production_chart.dart';

import 'pool_recent_blocks_wiget.dart';

class BlockProductionWidget extends StatefulWidget {
  final StakePool pool;
  final PoolStats poolStats;
  final num currentEpoch;
  final Ecosystem ecosystem;

  const BlockProductionWidget(
      {Key? key,
      required this.pool,
      required this.poolStats,
      required this.currentEpoch,
      required this.ecosystem})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BlockProductionWidgetState();
  }
}

class _BlockProductionWidgetState extends State<BlockProductionWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      BlockProductionChart(
          blockProduction: widget.poolStats.blocks!,
          poolSummary: widget.pool,
          currentEpoch: widget.currentEpoch,
          ecosystem: widget.ecosystem,
          stake: widget.poolStats.stake!),
      const SizedBox(height: 8),
      (widget.pool.l != null && widget.pool.l! > 0)
          ? PoolRecentBlocksWidget(
              poolId: widget.pool.id!,
              moreBlocksScreenTitle: "Blocks by ${widget.pool.displayName()}")
          : Container(),
      const SizedBox(height: 80)
    ]));
  }
}
