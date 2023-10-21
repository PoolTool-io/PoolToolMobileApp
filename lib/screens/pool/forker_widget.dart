import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:url_launcher/url_launcher.dart';

class ForkerWidget extends StatelessWidget {
  const ForkerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 16.0, bottom: 0.0, left: 12.0, right: 12.0),
      child: Card(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 0.0, left: 8.0, right: 0.0),
            child: Row(children: const [
              Icon(
                Icons.warning,
                color: Styles.DANGER_COLOR,
                size: 24.0,
              ),
              SizedBox(width: 8),
              Expanded(
                  child: Text("Adversarial Pool",
                      style: TextStyle(fontSize: 18.0)))
            ])),
        const Divider(),
        Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 16.0, left: 8.0, right: 8.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color),
                    text:
                        "This pool operates in a way that degrades the user experience for all Yoroi and Daedalus users and reduces the rewards for all stakers by creating two or more blocks for the same slot. This behaviour might or might not be intentional. If you see this warning for an extended period, the pool has decided to ignore our request to serve the best interests of everyone. Datasource: ",
                  ),
                  TextSpan(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                      text: "pooltool.io",
                      recognizer: TapGestureRecognizer()
                        ..onTap =
                            () => launchUrl(Uri.parse("https://pooltool.io"))),
                ],
              ),
            ))
      ])),
    );
  }
}
