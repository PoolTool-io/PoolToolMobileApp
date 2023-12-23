import 'package:flutter/material.dart';

class BlockListHeader extends StatelessWidget {
  final bool showLeader;
  const BlockListHeader({super.key, required this.showLeader});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(
            child: InkWell(
                child: Align(
                    heightFactor: 3,
                    alignment: Alignment.center,
                    child: Text("Time",
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold))))),
        const Expanded(
            child: InkWell(
                child: Align(
                    heightFactor: 3,
                    alignment: Alignment.center,
                    child: Text("Slot",
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold))))),
        if (showLeader)
          const Expanded(
              child: InkWell(
                  child: Align(
                      heightFactor: 3,
                      alignment: Alignment.center,
                      child: Text("Leader",
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.bold))))),
        const Expanded(
            child: InkWell(
                child: Align(
                    heightFactor: 3,
                    alignment: Alignment.center,
                    child: Text("Output (₳)",
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold))))),
        const Expanded(
            child: InkWell(
                child: Align(
                    heightFactor: 3,
                    alignment: Alignment.center,
                    child: Text("Txs",
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold))))),
        const Expanded(
            child: InkWell(
                child: Align(
                    heightFactor: 3,
                    alignment: Alignment.center,
                    child: Text("Fees (₳)",
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold))))),
      ],
    );
  }
}
