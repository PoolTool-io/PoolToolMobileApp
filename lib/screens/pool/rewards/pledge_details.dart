import 'package:flutter/material.dart';
import 'package:pegasus_tool/common/label_value_widget.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/screens/pool/alerts/pledge_alert_widget.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/utils.dart';

class PledgeDetails extends StatefulWidget {
  final StakePool pool;

  const PledgeDetails({Key? key, required this.pool}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PledgeDetailsState();
  }
}

class _PledgeDetailsState extends State<PledgeDetails> {
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
                  Icons.fact_check,
                  size: 24.0,
                ),
                const SizedBox(width: 8),
                const Expanded(
                    child: Text("Pledge", style: TextStyle(fontSize: 18.0))),
                PledgeAlertWidget(pool: pool)
              ])),
          const Divider(),
          Padding(
              padding: const EdgeInsets.only(
                  top: 0.0, bottom: 8.0, left: 8.0, right: 8.0),
              child: Column(
                children: <Widget>[
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        LabelValueWidget(
                            label: "Pledge",
                            value: "₳${formatLovelaces(pool.fp)}",
                            onTapFunc: () => {
                                  showInfoDialog(context, "Pledge",
                                      "Pledging is an important mechanism that encourages the growth of a healthy ecosystem within the Cardano blockchain. When an operator registers a stake pool they can choose to pledge some, or all, of their ada to the pool, to make it more attractive to people that want to delegate. Although pledging is not required when setting up a stake pool, it can make the stake pool more attractive to delegators, as the higher the amount of ada that is pledged, the higher the rewards that will be paid out.\n\nThis pool has ${pool.ap >= pool.fp ? "" : "not "}met its pledge.")
                                }),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Icon(
                                      pool.ap >= pool.fp
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: pool.ap >= pool.fp
                                          ? Styles.SUCCESS_COLOR
                                          : Styles.DANGER_COLOR,
                                      size: 14.0,
                                      semanticLabel: 'verified',
                                    )))),
                      ])
                ],
              )),
        ],
      ),
    );
  }
}
