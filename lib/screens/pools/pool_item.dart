import 'package:flutter/material.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/screens/pool/pool_details.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/utils.dart';

class PoolItemWidget extends StatelessWidget {
  final StakePool pool;
  final num? currentEpoch;

  const PoolItemWidget({Key? key, required this.pool, this.currentEpoch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 52,
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PoolDetails(
                          poolId: pool.id!,
                        )),
              );
            },
            child: Card(
                child: Row(children: [
              Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 2),
                                  Text(pool.r?.toString() ?? "   ",
                                      style: const TextStyle(
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.normal)),
                                  const SizedBox(width: 2),
                                  pool.forker == true ||
                                          pool.xx == true ||
                                          (pool.retiredEpoch != null &&
                                              pool.retiredEpoch! >
                                                  currentEpoch!)
                                      ? const Icon(
                                          Icons.warning,
                                          color: Styles.DANGER_COLOR,
                                          size: 11.0,
                                          semanticLabel: 'warning',
                                        )
                                      : pool.i == true
                                          ? const Icon(
                                              Icons.verified_user,
                                              color: Styles.SUCCESS_COLOR,
                                              size: 11.0,
                                              semanticLabel: 'verified',
                                            )
                                          : const SizedBox(width: 2.0),
                                  pool.c != null && pool.c is bool && pool.c
                                      ? const Icon(
                                          Icons.chat,
                                          color: Styles.APP_COLOR,
                                          size: 11.0,
                                          semanticLabel: 'chat ready',
                                        )
                                      : const SizedBox(width: 2.0)
                                ]),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(pool.t ?? "",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                          ],
                        ),
                      ))),
              /*  isLandscape(context)
                  ? */
              Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                          "${getEpochBlocs(pool, currentEpoch!)} / ${pool.l ?? 0}",
                          style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight:
                                  FontWeight.normal)))) /*  : Container()*/,
              Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(lifetimeROS(pool),
                          style: const TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.normal)))),
              /*isLandscape(context)
                  ? */
              Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              getIcon(pool, feeTear(pool)),
                              color: getColorForTear(feeTear(pool)),
                              size: 12.0,
                              semanticLabel: 'Fee',
                            ),
                            const SizedBox(width: 2),
                            Text(formattedVariableFee(pool),
                                style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal))
                          ]))) /* : Container()*/,
              /*Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              getIcon(pool, performanceTear(pool)),
                              color: getColor(pool, performanceTear(pool)),
                              size: 12.0,
                              semanticLabel: 'Performance',
                            ),
                            SizedBox(width: 2),
                            Text(formattedPerformance(pool),
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal))
                          ]))),*/
              Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              getIcon(pool, stakeTear(pool)),
                              color: getColorForTear(stakeTear(pool)),
                              size: 12.0,
                              semanticLabel: 'Live Stake',
                            ),
                            const SizedBox(width: 2),
                            Text(formatLovelaces(pool.ls),
                                style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal))
                          ])))
            ]))));
  }
}
