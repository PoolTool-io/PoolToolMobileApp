import 'package:flutter/material.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:url_launcher/url_launcher.dart';

class BroughtToYouByWidget extends StatelessWidget {
  final bool forcedDarkTheme; // For splash screen colors
  const BroughtToYouByWidget({
    super.key,
    this.forcedDarkTheme = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("brought to you by",
          style: TextStyle(
              fontSize: 16.0,
              color: forcedDarkTheme ? Styles.TEXT_COLOR_DARK : null)),
      const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(children: [
          InkWell(
              onTap: () => {launchUrl(Uri.parse("https://pooltool.io/about"))},
              child: const Image(
                  height: 60, image: AssetImage('assets/love_logo.png'))),
          const SizedBox(height: 8),
          Text("LOVE",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: forcedDarkTheme ? Styles.TEXT_COLOR_DARK : null))
        ]),
        // SizedBox(width: 32),
      ]),
    ]);
  }
}
