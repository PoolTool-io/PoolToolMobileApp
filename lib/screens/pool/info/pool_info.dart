import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pegasus_tool/common/label_value_widget.dart';
import 'package:pegasus_tool/models/pool_stats.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class PoolInfo extends StatelessWidget {
  final PoolStats poolStats;
  final StakePool poolSummary;

  const PoolInfo({Key? key, required this.poolStats, required this.poolSummary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 0.0, left: 8.0, right: 0.0),
              child: Row(children: [
                const Icon(
                  Icons.info,
                  size: 24.0,
                ),
                const SizedBox(width: 8),
                const Expanded(
                    child:
                        Text("Information", style: TextStyle(fontSize: 18.0))),
                Text("ID: ${truncateId(poolSummary.id!)}..."),
                const SizedBox(width: 8),
                InkWell(
                    onTap: () => {
                          showSuccessToast(
                              "${"Pool ID ${poolSummary.id!}"} is copied to clipboard"),
                          Clipboard.setData(
                              ClipboardData(text: poolSummary.id!))
                        },
                    child: const Icon(Icons.content_copy)),
                const SizedBox(width: 8),
              ])),
          const Divider(),
          Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                    child: LabelValueWidget(
                        label: "Rank",
                        value: "#${poolSummary.r?.toString() ?? "0"}")),
                (poolSummary.i == true)
                    ? const Expanded(
                        child: LabelValueWidget(
                            textAlign: TextAlign.right,
                            label: "Verified ITN Pool",
                            valueIcon: Icon(
                              Icons.verified_user,
                              color: Styles.SUCCESS_COLOR,
                              size: 18.0,
                            )))
                    : (poolSummary.xx == true)
                        ? const Expanded(
                            child: LabelValueWidget(
                                textAlign: TextAlign.right,
                                label: "Imposter Pool",
                                valueIcon: Icon(
                                  Icons.warning,
                                  color: Styles.DANGER_COLOR,
                                  size: 18.0,
                                )))
                        : Container()
              ])),
          poolStats.description != null && poolStats.description != ""
              ? const Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Divider())
              : Container(),
          poolStats.description != null && poolStats.description != ""
              ? Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
                  child:
                      Text(poolStats.description!, textAlign: TextAlign.left))
              : Container(),
          hasPublicMessage()
              ? const Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Divider())
              : Container(),
          hasPublicMessage() ? renderPublicMessage() : Container()
        ],
      ),
    );
  }

  bool hasPublicMessage() =>
      poolStats.publicNote != null && poolStats.publicNote!.isNotEmpty;

  Widget renderPublicMessage() => Html(
        data: poolStats.publicNote,
        onLinkTap: (url, context, attributes) {
          launchUrl(Uri.parse(url!));
        },
      );
}
