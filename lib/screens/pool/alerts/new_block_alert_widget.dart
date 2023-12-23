import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/common/color_loader.dart';
import 'package:pegasus_tool/models/block_alert_model.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/repository/block_alert_repository.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/utils.dart';

class NewBlockAlertWidget extends StatefulWidget {
  final StakePool pool;

  const NewBlockAlertWidget({super.key, required this.pool});

  @override
  State<StatefulWidget> createState() {
    return _NewBlockAlertWidgetState();
  }
}

class _NewBlockAlertWidgetState extends State<NewBlockAlertWidget> {
  BlockAlertRepository blockAlertRepository = GetIt.I<BlockAlertRepository>();

  StreamSubscription? alertValueSubscription;
  StreamSubscription? alertDeletionSubscription;
  bool isLoading = true;
  dynamic alert;

  @override
  void initState() {
    super.initState();
    initAlert();
  }

  void initAlert() async {
    blockAlertRepository.initAlert(widget.pool.id!);

    blockAlertRepository.alertValueStream.listen(updateAlert);
    blockAlertRepository.alertDeletionStream.listen(updateAlert);

    // String? token = await firebaseMessaging.getToken();
    //
    // DatabaseReference alertRef = firebaseDatabase
    //     .ref()
    //     .child(getEnvironment())
    //     .child("legacy_alerts")
    //     .child(widget.pool.id!)
    //     .child("block_production")
    //     .child(token!);
    // alertRef.keepSynced(true);
    // alertDeletionSubscription = alertRef.onChildRemoved.listen(updateAlert);
    // alertValueSubscription = alertRef.onValue.listen(updateAlert);
  }

  void updateAlert(BlockAlert blockAlert) {
    if (mounted) {
      setState(() {
        isLoading = false;
        alert = blockAlert;
      });
    }
  }

  @override
  void dispose() {
    alertDeletionSubscription?.cancel();
    alertValueSubscription?.cancel();
    super.dispose();
  }

  void addAlert() async {
    blockAlertRepository.addAlert(widget.pool)?.catchError((err) {
      showErrorToast("An error occurred. Please try again!$err");
      setState(() {
        isLoading = false;
      });
    });
  }

  void deleteAlert() async {
    blockAlertRepository.deleteAlert(widget.pool.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      isLoading
          ? const ColorLoader(dotThreeColor: Styles.APP_COLOR)
          : Switch(
              value: alert != BlockAlert(),
              activeColor: Theme.of(context).colorScheme.secondary,
              inactiveTrackColor: Theme.of(context).disabledColor,
              onChanged: (newValue) {
                if (newValue == true) {
                  showDialog(context);
                  addAlert();
                } else {
                  deleteAlert();
                }
              }),
      InkWell(
          onTap: () => {showDialog(context)},
          child: Icon(
            alert != BlockAlert()
                ? Icons.notifications_active_sharp
                : Icons.notifications_none_outlined,
            size: 24.0,
          )),
      const SizedBox(width: 8),
    ]);
  }

  void showDialog(BuildContext context) => showInfoDialog(
      context,
      "Block Production Alert",
      "A stake pool elected as a slot leader is responsible for producing new blocks for the Cardano network. If the stake pool does not produce a block, the slot will remain empty and the blockchain will not be extended. You will be notified when this pool creates a new block.");
}
