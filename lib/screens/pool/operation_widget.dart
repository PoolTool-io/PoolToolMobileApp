import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pegasus_tool/models/pool_stats.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/screens/pool/relay_info.dart';
import 'package:pegasus_tool/screens/pool/update/pool_updates_widget.dart';

class OperationWidget extends StatefulWidget {
  final PoolStats poolStats;
  final StakePool poolSummary;

  const OperationWidget(
      {super.key, required this.poolStats, required this.poolSummary});

  @override
  State<StatefulWidget> createState() {
    return _OperationWidgetState();
  }
}

class _OperationWidgetState extends State<OperationWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: <Widget>[
              RelayInfo(
                  onlineRelays: widget.poolSummary.o!,
                  offlineRelays: widget.poolSummary.oo!),
              const SizedBox(height: 8.0),
              PoolUpdatesWidget(poolId: widget.poolSummary.id!),
              const SizedBox(height: 80)
            ])));
  }
}
