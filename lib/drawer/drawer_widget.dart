import 'dart:async';
import 'dart:io';

import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/drawer/about.dart';
import 'package:pegasus_tool/drawer/drawer_item.dart';
import 'package:pegasus_tool/provider/theme_provider.dart';
import 'package:pegasus_tool/services/firebase_auth_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerWidget extends StatefulWidget {
  final ThemeProvider themeProvider;

  const DrawerWidget({
    Key? key,
    required this.themeProvider,
  }) : super(key: key);

  @override
  DrawerWidgetState createState() => DrawerWidgetState();
}

class DrawerWidgetState extends State<DrawerWidget> {
  bool _isLoggedIn = false;
  StreamSubscription<bool>? isLoggedInStreamSubscription;
  FirebaseAuthService firebaseAuthService = GetIt.I<FirebaseAuthService>();

  @override
  initState() {
    super.initState();

    _isLoggedIn = firebaseAuthService.isLoggedIn;

    isLoggedInStreamSubscription =
        firebaseAuthService.isLoggedInStream.listen((event) {
      setState(() {
        _isLoggedIn = event;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    isLoggedInStreamSubscription?.cancel();
  }

  requestReview() {
    if (Platform.isIOS) {
      AppReview.openIosReview(appId: "1495556387", compose: true);
    } else {
      AppReview.openGooglePlay();
    }
  }

  void logout() async {
    firebaseAuthService.logout();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: true);

    return Drawer(
      child: Container(
        color: Theme.of(context).cardColor,
        child: ListView(
          children: <Widget>[
            DrawerItem(
                label: "Bugs & Feature Requests",
                icon: Icons.bug_report,
                action: () => launchUrl(Uri.parse(
                    "https://github.com/PegasusPool/pegasus-tool-features/issues/new/choose"))),
//            DrawerItem(label: "Follow us on Twitter", icon: Icons.speaker_notes, action: () => launch("https://twitter.com/PegasusPool")),
            /*DrawerItem(label: "Glossary", icon: Icons.book, target: Glossary()),*/
            DrawerItem(
                label: "Telegram",
                icon: Icons.speaker_notes,
                action: () => launchUrl(Uri.parse("https://t.me/pooltool"))),
            DrawerItem(
                label: "Privacy Policy",
                icon: Icons.account_balance,
                action: () =>
                    launchUrl(Uri.parse("https://pooltool.io/privacy"))),
            DrawerItem(
                label: "Rate the App",
                icon: Icons.star,
                action: () => requestReview()),
            const DrawerItem(label: "About", icon: Icons.info, target: About()),
            DrawerItem(
                label: "Dark Mode",
                icon: Icons.nightlight_round,
                trailing: Switch(
                  activeColor: Colors.greenAccent,
                  onChanged: (val) {},
                  value: themeProvider.darkTheme!,
                ),
                action: () {
                  themeProvider.darkTheme = !themeProvider.darkTheme!;
                }),
            !_isLoggedIn
                ? Container()
                : DrawerItem(
                    label: "Sign out",
                    icon: Icons.account_box,
                    action: () {
                      logout();
                    }),
          ],
        ),
      ),
    );
  }
}
