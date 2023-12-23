import 'package:flutter/material.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/utils.dart';
import 'package:timeline_tile/timeline_tile.dart';

class PoolUpdateItem extends StatelessWidget {
  final dynamic update;
  final int updateIndex;
  Animation<double> animation;

  PoolUpdateItem(
      {super.key,
      required this.animation,
      this.update,
      required this.updateIndex});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: animation,
        child: SizeTransition(
            axis: Axis.vertical,
            sizeFactor: animation,
            child: TimelineTile(
                isFirst: updateIndex == 0,
                isLast: update['type'] == "registration",
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
                      child: Text(formatTimestampAgo(update['time']),
                          style: const TextStyle(
                              fontSize: 14.0, fontStyle: FontStyle.italic))),
                ),
                endChild: Container(
                    constraints: const BoxConstraints(
                      minHeight: 80,
                    ),
                    child: Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(getTitleText(),
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .color)),
                              Text(getSubTitleText(),
                                  style: const TextStyle(fontSize: 15.0)),
                            ]))))));
  }

  String getTitleText() {
    if (update['type'] == "registration") {
      return timestampToDateTime(update['time']);
    } else if (update['type'] == "pledge") {
      return "Pledge";
    } else if (update['type'] == "margin") {
      return "Profit Margin";
    } else if (update['type'] == "fixed") {
      return "Cost per Epoch";
    } else if (update['type'] == "retire") {
      return "Retired";
    } else {
      return "Unknown update";
    }
  }

  String getSubTitleText() {
    if (update['type'] == "registration") {
      return "Registered";
    } else if (update['type'] == "margin") {
      return update['from'] + " -> " + update['to'];
    } else if (update['type'] == "pledge" || update['type'] == "fixed") {
      return "₳${update['from']} -> ₳${update['to']}";
    } else if (update['type'] == "retire") {
      return "In epoch ${update['retiring_epoch']}";
    } else {
      return "";
    }
  }

  IconStyle getIconStyle() {
    IconData iconData;
    if (update['type'] == "registration") {
      iconData = Icons.accessibility_new;
    } else if (update['type'] == "pledge") {
      iconData = Icons.account_balance;
    } else if (update['type'] == "margin") {
      iconData = Icons.attach_money;
    } else if (update['type'] == "retire") {
      iconData = Icons.wb_twighlight;
    } else {
      iconData = Icons.ac_unit;
    }
    return IconStyle(
        iconData: iconData, color: Styles.ICON_INSIDE_COLOR, fontSize: 21);
  }
}
