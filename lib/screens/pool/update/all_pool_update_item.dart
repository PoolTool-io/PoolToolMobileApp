import 'package:flutter/material.dart';
import 'package:pegasus_tool/models/pool_update_model.dart';
import 'package:pegasus_tool/screens/pool/pool_details.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/utils.dart';
import 'package:timeline_tile/timeline_tile.dart';

class AllPoolUpdateItem extends StatelessWidget {
  final PoolUpdate update;
  final int updateIndex;
  final int lastIndex;

  final Animation<double>? animation;

  const AllPoolUpdateItem(
      {Key? key,
      this.animation,
      required this.update,
      required this.updateIndex,
      required this.lastIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: animation!,
        child: SizeTransition(
            axis: Axis.vertical,
            sizeFactor: animation!,
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PoolDetails(
                              poolId: update.poolId!,
                            )),
                  );
                },
                child: TimelineTile(
                  isFirst: updateIndex == 0,
                  isLast: updateIndex == lastIndex,
                  indicatorStyle: IndicatorStyle(
                      color: Styles.APP_COLOR,
                      width: 30,
                      iconStyle: getIconStyle()),
                  beforeLineStyle: const LineStyle(
                    color: Styles.APP_COLOR,
                    thickness: 2,
                  ),
                  afterLineStyle: const LineStyle(
                    color: Styles.APP_COLOR,
                    thickness: 2,
                  ),
                  hasIndicator: true,
                  alignment: TimelineAlign.manual,
                  lineXY: 0.2,
                  startChild: Container(
                    constraints: const BoxConstraints(
                      minHeight: 80,
                    ),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(formatTimestampAgo(update.time),
                            style: const TextStyle(
                                fontSize: 14.0, fontStyle: FontStyle.italic))),
                  ),
                  endChild: Container(
                      constraints: const BoxConstraints(
                        minHeight: 80,
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 16.0),
                                Row(children: [
                                  Expanded(
                                      child: Text(
                                    getSubTitleText(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .color),
                                  )),
                                  Expanded(
                                      child: Text(getPoolOwnerTicker(),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 11.0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary))),
                                ]),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Text(getTitleText(),
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight:
                                                      FontWeight.normal))),
                                      const SizedBox(width: 8),
                                      Expanded(
                                          child: Text(getPoolOwnerName(),
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary)))
                                    ])
                              ]))),
                ))));
  }

  String getPoolOwnerTicker() {
    return update.ticker ?? "";
  }

  String getPoolOwnerName() {
    return update.name ?? (truncateId(update.poolId!));
  }

  String getTitleText() {
    if (update.type == "registration") {
      return "Stake Pool";
    } else if (update.type == "margin") {
      return "${update.from!} -> ${update.to!}";
    } else if (update.type == "pledge" || update.type == "fixed") {
      return "₳${update.from!} -> ₳${update.to!}";
    } else if (update.type == "retire") {
      return "In epoch ${update.retiring_epoch}";
    } else {
      return "";
    }
  }

  String getSubTitleText() {
    if (update.type == "registration") {
      return "New";
    } else if (update.type == "pledge") {
      return "Pledge";
    } else if (update.type == "margin") {
      return "Profit Margin";
    } else if (update.type == "fixed") {
      return "Cost per Epoch";
    } else if (update.type == "retire") {
      return "Retired";
    } else {
      return "Unknown update";
    }
  }

  IconStyle getIconStyle() {
    IconData iconData;
    if (update.type == "registration") {
      iconData = Icons.accessibility_new;
    } else if (update.type == "pledge") {
      iconData = Icons.account_balance;
    } else if (update.type == "margin") {
      iconData = Icons.attach_money;
    } else if (update.type == "retire") {
      iconData = Icons.wb_twighlight;
    } else {
      iconData = Icons.ac_unit;
    }
    return IconStyle(
        iconData: iconData, color: Styles.ICON_INSIDE_COLOR, fontSize: 21);
  }
}
