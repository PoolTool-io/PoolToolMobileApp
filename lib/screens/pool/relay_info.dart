import 'package:flutter/material.dart';
import 'package:pegasus_tool/common/label_value_widget.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/utils.dart';

class RelayInfo extends StatelessWidget {
  final num onlineRelays;
  final num offlineRelays;

  const RelayInfo(
      {super.key, required this.onlineRelays, required this.offlineRelays});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showRelayInfoDialog(context);
        },
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 0.0, left: 8.0, right: 0.0),
                  child: Row(children: const [
                    Icon(
                      Icons.settings_ethernet,
                      size: 24.0,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                        child: Text("Relays", style: TextStyle(fontSize: 18.0)))
                  ])),
              const Divider(),
              Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        LabelValueWidget(
                          textAlign: TextAlign.left,
                          label: "Offline",
                          value: format(offlineRelays),
                          onTapFunc: () => {showRelayInfoDialog(context)},
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Icon(
                                      Icons.cloud_off,
                                      color: Styles.DANGER_COLOR,
                                      size: 14.0,
                                    )))),
                        const Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Icon(
                                      Icons.cloud_done,
                                      color: Styles.SUCCESS_COLOR,
                                      size: 14.0,
                                    )))),
                        const SizedBox(width: 8),
                        LabelValueWidget(
                          textAlign: TextAlign.right,
                          label: "Online",
                          value: format(onlineRelays),
                          onTapFunc: () => {showRelayInfoDialog(context)},
                        )
                      ])),
            ],
          ),
        ));
  }

  void showRelayInfoDialog(BuildContext context) {
    showInfoDialog(context, "Relays",
        "Block producer nodes only connect to their own relays and form part of the Cardano network. Stake pools must be connected to at least one online relay in order to get their minted blocks into the chain. A few relays are expected to be online for a block producer for redundancy. \n\n(Connection retry: ~5 hours)");
  }
}
