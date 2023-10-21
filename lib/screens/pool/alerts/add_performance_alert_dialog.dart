import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/common/color_loader.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';
import 'package:pegasus_tool/services/firebase_messaging_service.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/utils.dart';

class AddPerformanceAlertDialog extends StatefulWidget {
  final String poolId;

  const AddPerformanceAlertDialog({Key? key, required this.poolId})
      : super(key: key);

  @override
  AddPerformanceAlertDialogState createState() =>
      AddPerformanceAlertDialogState();
}

class AddPerformanceAlertDialogState extends State<AddPerformanceAlertDialog> {
  int _value = 70;
  bool loading = false;
  final FirebaseMessagingService firebaseMessagingService =
      GetIt.I<FirebaseMessagingService>();
  final FirebaseDatabaseService firebaseDatabaseService =
      GetIt.I<FirebaseDatabaseService>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
      padding: const EdgeInsets.only(
          left: 16.0, top: 16.0, right: 16.0, bottom: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(Icons.add_alert, size: 24),
                SizedBox(width: 8),
                Text(
                  'Performance Alert',
                  style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )
              ]),
          const SizedBox(height: 20),
          const Text(
              "Get notified when this pool closes an epoch below a certain performance value. Remember that performance ratings make more sense over a longer period of time."),
          const SizedBox(height: 30),
          Slider(
              value: _value.toDouble(),
              min: 1.0,
              max: 100.0,
              divisions: 99,
              activeColor: Theme.of(context).colorScheme.secondary,
              inactiveColor: Styles.INACTIVE_COLOR,
              label: "$_value%",
              onChanged: (double newValue) {
                setState(() {
                  _value = newValue.round();
                });
              },
              semanticFormatterCallback: (double newValue) {
                return '${newValue.round()} %';
              }),
          const Center(
              child: Text("Use the slider to set your preferred limit.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13.0,
                      fontStyle: FontStyle.italic,
                      color: Styles.INACTIVE_COLOR))),
          const SizedBox(height: 30),
          loading
              ? const ColorLoader(dotThreeColor: Styles.APP_COLOR)
              : Row(children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel",
                      )),
                  Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(
                                  color: Styles.ICON_INSIDE_COLOR)),
                          onPressed: () {
                            setState(() {
                              loading = true;
                            });
                            addAlert(context);
                          },
                          child: Text('Alert me below $_value%')))
                ])
        ],
      ),
    ));
  }

  void addAlert(BuildContext context) async {
    String? token = await firebaseMessagingService.firebaseMessaging.getToken();

    Map alert = PerformanceAlert(limit: _value).toMap();

    firebaseDatabaseService.firebaseDatabase
        .ref()
        .child("ITN1")
        .child("legacy_alerts")
        .child(widget.poolId)
        .child("performance")
        .child(token!)
        .set(alert)
        .catchError((err) {
      showErrorToast("An error occurred. Please try again!$err");
      setState(() {
        loading = false;
      });
    }).then((snapshot) => Navigator.pop(context));
  }
}

void showAddPerformanceAlertDialog(context, String poolId) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AddPerformanceAlertDialog(poolId: poolId);
      });
}

class PerformanceAlert {
  final num limit;

  PerformanceAlert({required this.limit});

  Map<String, dynamic> toMap() {
    return {'limit': limit};
  }
}
