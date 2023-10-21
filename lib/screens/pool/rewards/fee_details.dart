import 'package:flutter/material.dart';
import 'package:pegasus_tool/common/label_value_widget.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/utils.dart';

import '../alerts/fee_change_alert_widget.dart';

class FeeDetails extends StatefulWidget {
  final StakePool pool;

  const FeeDetails({Key? key, required this.pool}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FeeDetailsState();
  }
}

class _FeeDetailsState extends State<FeeDetails> {
  dynamic pool;

  @override
  void initState() {
    pool = widget.pool;
    super.initState();
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
                  Icons.account_balance,
                  size: 24.0,
                ),
                const SizedBox(width: 8),
                const Expanded(
                    child: Text("Fees", style: TextStyle(fontSize: 18.0))),
                FeeChangeAlertWidget(pool: pool)
              ])),
          const Divider(),
          Padding(
              padding: const EdgeInsets.only(
                  top: 0.0, bottom: 8.0, left: 8.0, right: 8.0),
              child: Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(
                        child: LabelValueWidget(
                            label: "Cost per Epoch",
                            value: "₳${formatLovelaces(pool.ff)}",
                            onTapFunc: () => {
                                  showInfoDialog(context, "Cost per Epoch",
                                      "A fixed fee, in ada, which the stake pool operator takes every epoch from the pool rewards to cover the costs of running a stake pool. The cost per epoch is subtracted from the total ada that is rewarded to a pool, before the operator takes their profit margin. Whatever remains is shared proportionally among the delegators.")
                                })),
                    Expanded(
                        child: LabelValueWidget(
                            label: "Profit Margin",
                            value: formattedVariableFee(pool),
                            textAlign: TextAlign.right,
                            onTapFunc: () => {
                                  showInfoDialog(context, "Profit Margin",
                                      "The percentage of total ada rewards that the stake pool operator takes before sharing the rest of the rewards between all the delegators to the pool. A lower profit margin for the operator means they are taking less, which means that delegators can expect to receive more of the rewards for their delegated stake. A private pool is a pool with a profit margin of 100%, meaning that all the rewards will go to the operator and none to the delegators.")
                                })),
                  ]),
                  // Row(
                  //     crossAxisAlignment: CrossAxisAlignment.end,
                  //     children: <Widget>[
                  //       LabelValueWidget(
                  //           label: "Pledge",
                  //           value: "₳${formatLovelaces(pool.fp)}",
                  //           onTapFunc: () => {
                  //                 showInfoDialog(context, "Pledge",
                  //                     "Pledging is an important mechanism that encourages the growth of a healthy ecosystem within the Cardano blockchain. When an operator registers a stake pool they can choose to pledge some, or all, of their ada to the pool, to make it more attractive to people that want to delegate. Although pledging is not required when setting up a stake pool, it can make the stake pool more attractive to delegators, as the higher the amount of ada that is pledged, the higher the rewards that will be paid out.\n\nThis pool has ${pool.ap >= pool.fp ? "" : "not "}met its pledge.")
                  //               }),
                  //       const SizedBox(width: 8),
                  //       Expanded(
                  //           child: Padding(
                  //               padding: const EdgeInsets.only(bottom: 8.0),
                  //               child: Align(
                  //                   alignment: Alignment.bottomLeft,
                  //                   child: Icon(
                  //                     pool.ap >= pool.fp
                  //                         ? Icons.check_circle
                  //                         : Icons.cancel,
                  //                     color: pool.ap >= pool.fp
                  //                         ? Styles.SUCCESS_COLOR
                  //                         : Styles.DANGER_COLOR,
                  //                     size: 14.0,
                  //                     semanticLabel: 'verified',
                  //                   )))),
                  //     ])
                ],
              )),
        ],
      ),
    );
  }
}
