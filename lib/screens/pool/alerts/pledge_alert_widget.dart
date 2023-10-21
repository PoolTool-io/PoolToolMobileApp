import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/common/color_loader.dart';
import 'package:pegasus_tool/models/pledge_alert_model.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/repository/pledge_alert_repository.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/utils.dart';

class PledgeAlertWidget extends StatefulWidget {
  final StakePool pool;

  const PledgeAlertWidget({Key? key, required this.pool}) : super(key: key);

  @override
  PledgeAlertWidgetState createState() => PledgeAlertWidgetState();
}

class PledgeAlertWidgetState extends State<PledgeAlertWidget> {
  PledgeAlertRepository pledgeAlertRepository =
      GetIt.I<PledgeAlertRepository>();

  StreamSubscription? alertValueSubscription;
  StreamSubscription? alertDeletionSubscription;

  bool isLoading = true;

  PledgeAlert? pledgeAlert;

  @override
  void initState() {
    super.initState();
    initAlert();
  }

  void initAlert() async {
    pledgeAlertRepository.initAlert(widget.pool.id!);

    pledgeAlertRepository.alertValueStream.listen(updateAlert);
    pledgeAlertRepository.alertDeletionStream.listen(updateAlert);
  }

  void updateAlert(PledgeAlert? updatedPledgeAlert) {
    if (mounted) {
      setState(() {
        isLoading = false;
        pledgeAlert = updatedPledgeAlert;
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
    pledgeAlertRepository.addAlert(widget.pool)?.catchError((err) {
      showErrorToast("An error occurred. Please try again!$err");
      setState(() {
        isLoading = false;
      });
    });
  }

  void deleteAlert() async {
    pledgeAlertRepository.deleteAlert(widget.pool.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      isLoading
          ? const ColorLoader(dotThreeColor: Styles.APP_COLOR)
          : Switch(
              value: pledgeAlert != PledgeAlert(),
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
            pledgeAlert != PledgeAlert()
                ? Icons.notifications_active_sharp
                : Icons.notifications_none_outlined,
            size: 24.0,
          )),
      const SizedBox(width: 8),
    ]);
  }

  void showDialog(BuildContext context) => showInfoDialog(
      context,
      "Pledge Alert",
      "Stake pool operators are free to increase or decrease their pledge any time. You will be notified when this pool changes its pledge or does not honour its pledge.");
}
