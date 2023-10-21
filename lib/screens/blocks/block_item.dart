import 'package:flutter/material.dart';
import 'package:pegasus_tool/screens/blocks/block_details.dart';
import 'package:pegasus_tool/utils.dart';

class BlockItemWidget extends StatelessWidget {
  final bool showLeader;
  final dynamic block;
  final Animation<double> animation;

  const BlockItemWidget(
      {Key? key,
      required this.animation,
      required this.block,
      required this.showLeader})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BlockDetails(
                        blockNumber: block.block.toString(),
                        epoch: block.epoch.toString(),
                      )),
            );
          },
          child: SizedBox(
            height: 60.0,
            child: Card(
                child: Row(children: [
              const SizedBox(width: 8),
              Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(formatTimestampAgo(block.time),
                          style: const TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.normal)))),
              Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(format(block.slot),
                          style: const TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.normal)))),
              if (showLeader)
                Expanded(
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                            block.leaderPoolTicker ??
                                truncateId(block.leaderPoolId.toString()),
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: block.leaderPoolTicker != null
                                    ? FontWeight.bold
                                    : FontWeight.normal)))),
              Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(formatLovelaces(block.output),
                          style: const TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.normal)))),
              Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(block.transactions.toString(),
                          style: const TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.normal)))),
              Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(formatLovelaces(block.fees),
                          style: const TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.normal)))),
            ])),
          ),
        ),
      ),
    );
  }
}
