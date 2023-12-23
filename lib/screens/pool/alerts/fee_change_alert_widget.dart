import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/common/color_loader.dart';
import 'package:pegasus_tool/models/fee_alert_model.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/repository/fee_alert_repository.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/utils.dart';

class FeeChangeAlertWidget extends StatefulWidget {
  final StakePool pool;

  const FeeChangeAlertWidget({super.key, required this.pool});

  @override
  State<StatefulWidget> createState() {
    return _FeeChangeAlertWidgetState();
  }
}

class _FeeChangeAlertWidgetState extends State<FeeChangeAlertWidget> {
  FeeAlertRepository feeAlertRepository = GetIt.I<FeeAlertRepository>();

  StreamSubscription? alertValueSubscription;
  StreamSubscription? alertDeletionSubscription;
  bool isLoading = true;
  FeeAlert? feeAlert;

  @override
  void initState() {
    super.initState();
    initAlert();
  }

  void initAlert() async {
    feeAlertRepository.initAlert(widget.pool.id!);

    feeAlertRepository.alertValueStream.listen(updateAlert);
    feeAlertRepository.alertDeletionStream.listen(updateAlert);
  }

  void updateAlert(FeeAlert? updatedFeeAlert) {
    if (mounted) {
      setState(() {
        isLoading = false;
        feeAlert = updatedFeeAlert;
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
    feeAlertRepository.addAlert(widget.pool)?.catchError((err) {
      showErrorToast("An error occurred. Please try again!$err");
      setState(() {
        isLoading = false;
      });
    });
  }

  void deleteAlert() async {
    feeAlertRepository.deleteAlert(widget.pool.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      isLoading
          ? const ColorLoader(dotThreeColor: Styles.APP_COLOR)
          : Switch(
              value: feeAlert != FeeAlert(),
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
            feeAlert != FeeAlert()
                ? Icons.notifications_active_sharp
                : Icons.notifications_none_outlined,
            size: 24.0,
          )),
      const SizedBox(width: 8),
    ]);
  }

  void showDialog(BuildContext context) => showInfoDialog(
      context,
      "Fee Change Alert",
      "Stake pool operators are free to change their fees and can increase or lower their pledge any time. You will be notified when this pool changes its fees or pledge.");
}
