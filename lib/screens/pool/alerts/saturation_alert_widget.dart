import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/common/color_loader.dart';
import 'package:pegasus_tool/config/constants.dart';
import 'package:pegasus_tool/models/saturation_alert_model.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/repository/saturation_alert_repository.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/utils.dart';

class SaturationAlertWidget extends StatefulWidget {
  final StakePool pool;

  const SaturationAlertWidget({super.key, required this.pool});

  @override
  State<StatefulWidget> createState() {
    return _SaturationAlertWidgetState();
  }
}

class _SaturationAlertWidgetState extends State<SaturationAlertWidget> {
  SaturationAlertRepository saturationAlertRepository =
      GetIt.I<SaturationAlertRepository>();

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
    saturationAlertRepository.initAlert(widget.pool.id!);

    saturationAlertRepository.alertValueStream.listen(updateAlert);
    saturationAlertRepository.alertDeletionStream.listen(updateAlert);
  }

  void updateAlert(SaturationAlert? saturationAlert) {
    if (mounted) {
      setState(() {
        isLoading = false;
        alert = saturationAlert;
      });
    }
  }

  @override
  void dispose() {
    if (alertDeletionSubscription != null) {
      alertDeletionSubscription!.cancel();
    }

    if (alertValueSubscription != null) {
      alertValueSubscription!.cancel();
    }

    super.dispose();
  }

  void addAlert() async {
    saturationAlertRepository.addAlert(widget.pool)?.catchError((err) {
      showErrorToast("An error occurred. Please try again!$err");
      setState(() {
        isLoading = false;
      });
    });
  }

  void deleteAlert() async {
    saturationAlertRepository.deleteAlert(widget.pool.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      isLoading
          ? const ColorLoader(dotThreeColor: Styles.APP_COLOR)
          : Switch(
              value: alert != const SaturationAlert(),
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
            alert != const SaturationAlert()
                ? Icons.notifications_active_sharp
                : Icons.notifications_none_outlined,
            color: Theme.of(context).colorScheme.secondary,
            size: 24.0,
          )),
      const SizedBox(width: 8),
    ]);
  }

  void showDialog(BuildContext context) => showInfoDialog(
      context,
      "Saturation Alert",
      "${Constants.SATURATION_INFO} You will be notified when this pool gets saturated.");
}
