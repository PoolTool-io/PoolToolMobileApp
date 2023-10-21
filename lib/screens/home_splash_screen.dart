import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/common/splashscreen.dart';
import 'package:pegasus_tool/config/constants.dart';
import 'package:pegasus_tool/provider/theme_provider.dart';
import 'package:pegasus_tool/screens/main_tab_bar.dart';
import 'package:pegasus_tool/screens/onboarding/onboarding_screen.dart';
import 'package:pegasus_tool/services/navigator_service.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeSplashScreen extends StatefulWidget {
  const HomeSplashScreen({Key? key}) : super(key: key);

  @override
  HomeSplashScreenState createState() => HomeSplashScreenState();
}

class HomeSplashScreenState extends State<HomeSplashScreen> {
  bool? showOnboarding;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? prefsShownOnboarding =
        prefs.getBool(Constants.PREFS_SHOWN_ONBOARDING);

    if (kDebugMode || prefsShownOnboarding == null || !prefsShownOnboarding) {
      setState(() {
        showOnboarding = false; //TODO get this right!
      });
      prefs.setBool(Constants.PREFS_SHOWN_ONBOARDING, true);
    } else {
      setState(() {
        showOnboarding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool? darkTheme =
        Provider.of<ThemeProvider>(context, listen: true).darkTheme;

    // if (showOnboarding == null) {
    //   return Scaffold(
    //       backgroundColor: Theme.of(context).backgroundColor,
    //       body: Container());
    // }

    return SplashScreen(
      seconds: 2,
      backgroundColor: darkTheme == null
          ? Styles.BACKGROUND_COLOR_DARK
          : (darkTheme == true ? Styles.BACKGROUND_COLOR_DARK : Colors.white),
      navigateAfterSeconds: showOnboarding == null || showOnboarding!
          ? OnboardingScreen(onDoneFunc: () => {handleDoneClick()})
          : const MainTabBar(),
      title: Text(
        'Welcome to PoolTool',
        style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 20.0,
            color: darkTheme == null
                ? Colors.transparent
                : (darkTheme == true ? Styles.TEXT_COLOR_DARK : Colors.black)),
      ),
      image: const Image(height: 100, image: AssetImage('assets/logo.png')),
      loadingWidget: Container(),
      styleTextUnderTheLoader: const TextStyle(),
      photoSize: 100.0,
      loaderColor: Theme.of(context).splashColor,
    );
  }

  Future<void> handleDoneClick() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Constants.PREFS_SHOWN_ONBOARDING, true);

    GetIt.I<NavigationService>().navigateTo("home", null);
  }
}
