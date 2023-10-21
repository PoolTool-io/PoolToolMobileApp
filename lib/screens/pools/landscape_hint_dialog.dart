import 'package:flutter/material.dart';
import 'package:pegasus_tool/config/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandscapeHintDialog extends StatefulWidget {
  const LandscapeHintDialog({Key? key}) : super(key: key);

  @override
  LandscapeHintDialogState createState() => LandscapeHintDialogState();
}

class LandscapeHintDialogState extends State<LandscapeHintDialog> {
  bool dontShowAgain = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, top: 16.0, right: 16.0, bottom: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.remove_red_eye,
                        size: 24, color: Theme.of(context).iconTheme.color),
                    const SizedBox(width: 8),
                    Text(
                      'Hint!',
                      style: TextStyle(
                          fontSize: 21.0,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )
                  ]),
              const SizedBox(height: 20),
              CheckboxListTile(
                  title:
                      const Text("Rotate your device to reveal more columns"),
                  subtitle:
                      const Text("Tick checkbox to never see this hint again"),
                  value: dontShowAgain,
                  onChanged: (newValue) {
                    setState(() {
                      dontShowAgain = newValue!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading),
              TextButton(
                  onPressed: () {
                    if (dontShowAgain) {
                      updateFlagAndPop();
                    }
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Got it!",
                  ))
            ],
          ),
        ));
  }

  void updateFlagAndPop() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Constants.PREFS_DONT_SHOW_LANDSCAPE_HINT, true);
  }
}

void showLandscapeHintDialog(context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LandscapeHintDialog();
      });
}
