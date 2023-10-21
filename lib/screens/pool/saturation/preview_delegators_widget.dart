import 'package:flutter/material.dart';
import 'package:pegasus_tool/common/list_model.dart';
import 'package:pegasus_tool/models/delegator_model.dart';
import 'package:pegasus_tool/models/live_delegators_model.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/utils.dart';

import 'all_delegators_widget.dart';

class PreviewDelegatorsWidget extends StatelessWidget {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late final ListModel<dynamic> _list;
  final StakePool poolSummary;
  final LiveDelegators? liveDelegators;

  PreviewDelegatorsWidget({
    Key? key,
    required this.liveDelegators,
    required this.poolSummary,
  }) : super(key: key) {
    if (liveDelegators != null) {
      _list = ListModel<dynamic>(
        listKey: _listKey,
        initialItems: [],
        removedItemBuilder: _buildRemovedItem,
      );

      liveDelegators!.delegators!.sort((k1, k2) {
        return k2.v!.compareTo(k1.v!);
      });

      int range = liveDelegators!.delegators!.length > 4
          ? 3
          : liveDelegators!.delegators!.length;

      for (var element in liveDelegators!.delegators!.getRange(0, range)) {
        _insert(element);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return liveDelegators != null && liveDelegators!.delegators!.isNotEmpty
        ? Column(children: <Widget>[
            getBlockListHeader(),
            getList(),
            getMoreButton(context),
          ])
        : Container();
  }

  Widget getList() {
    return AnimatedList(
        key: _listKey,
        initialItemCount: _list.length,
        itemBuilder: _buildItem,
        reverse: true,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true);
  }

  void _insert(dynamic delegator) {
    _list.insert(0, delegator);
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return DelegatorItemWidget(animation: animation, delegator: _list[index]);
  }

  Widget _buildRemovedItem(
      dynamic delegator, BuildContext context, Animation<double> animation) {
    return DelegatorItemWidget(animation: animation, delegator: delegator);
  }

  Widget getMoreButton(BuildContext context) {
    return (liveDelegators!.delegators!.length > 4)
        ? SizedBox(
            height: 48,
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllDelegatorsWidget(
                              sortedDelegators: liveDelegators!.delegators!,
                              poolSummary: poolSummary)));
                },
                child: const Card(
                    child: InkWell(
                        child: Align(
                            alignment: Alignment.center,
                            child: Text("More...",
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold)))))))
        : Container();
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
          Text(" ${liveDelegators!.delegators!.length} Delegators",
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

class DelegatorItemWidget extends StatelessWidget {
  final Delegator delegator;
  final Animation<double> animation;

  const DelegatorItemWidget(
      {Key? key, required this.animation, required this.delegator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: SizedBox(
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
        ),
      ),
    );
  }
}
