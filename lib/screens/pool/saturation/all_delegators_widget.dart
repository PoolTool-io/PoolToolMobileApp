import 'package:flutter/material.dart';
import 'package:pegasus_tool/models/delegator_model.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/utils.dart';

class AllDelegatorsWidget extends StatelessWidget {
  final List<Delegator?> sortedDelegators;
  final StakePool poolSummary;

  const AllDelegatorsWidget(
      {super.key, required this.sortedDelegators, required this.poolSummary});

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar:
                AppBar(title: Text(getPoolName(poolSummary.id!, poolSummary))),
            body: Material(
                color: Theme.of(context).colorScheme.background,
                child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Column(children: <Widget>[
                      getBlockListHeader(),
                      getList()
                    ])))));
  }

  Widget getList() {
    return Flexible(
        child: ListView.builder(
            itemCount: sortedDelegators.length,
            itemBuilder: (BuildContext context, int index) {
              return _DelegatorItemWidget(delegator: sortedDelegators[index]!);
            }));
  }

  Widget getBlockListHeader() {
    return Row(
      children: <Widget>[
        const SizedBox(width: 8),
        const Expanded(
            child: InkWell(
                child: Align(
                    heightFactor: 3,
                    alignment: Alignment.centerLeft,
                    child: Text("Stake key",
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold))))),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(
            Icons.people_outline,
            size: 24.0,
          ),
          const SizedBox(width: 8),
          Text(" ${sortedDelegators.length} Delegators",
              style:
                  const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
        ]),
        const Expanded(
            child: InkWell(
                child: Align(
                    heightFactor: 3,
                    alignment: Alignment.centerRight,
                    child: Text("Amount",
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold))))),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _DelegatorItemWidget extends StatelessWidget {
  final Delegator delegator;

  const _DelegatorItemWidget({required this.delegator});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: Card(
          child: Row(children: [
        const SizedBox(width: 8),
        Expanded(
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("${delegator.k!.substring(1, 15)}...",
                    style: const TextStyle(
                        fontSize: 13.0, fontWeight: FontWeight.normal)))),
        Expanded(
            child: Align(
                alignment: Alignment.centerRight,
                child: Text("₳${formatLovelaces(delegator.v)}",
                    style: const TextStyle(
                        fontSize: 13.0, fontWeight: FontWeight.normal)))),
        const SizedBox(width: 8),
      ])),
    );
  }
}
