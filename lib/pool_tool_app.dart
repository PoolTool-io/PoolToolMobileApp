import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/provider/theme_provider.dart';
import 'package:pegasus_tool/repository/stake_pools_repository.dart';
import 'package:pegasus_tool/screens/home_splash_screen.dart';
import 'package:pegasus_tool/screens/main_tab_bar.dart';
import 'package:pegasus_tool/screens/pool/chat/chat_room_screen.dart';
import 'package:pegasus_tool/screens/pool/pool_details.dart';
import 'package:pegasus_tool/services/firebase_analytics_service.dart';
import 'package:pegasus_tool/services/navigator_service.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:provider/provider.dart';

class PoolToolApp extends StatefulWidget {
  const PoolToolApp({Key? key}) : super(key: key);

  @override
  PoolToolAppState createState() => PoolToolAppState();
}

class PoolToolAppState extends State<PoolToolApp> with WidgetsBindingObserver {
  NavigationService navigationService = GetIt.I<NavigationService>();
  FirebaseAnalyticsService firebaseAnalyticsService =
      GetIt.I<FirebaseAnalyticsService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        debugPrint('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        StakePoolsRepository stakePoolsRepository =
            GetIt.I<StakePoolsRepository>();
        stakePoolsRepository.getStakePools();
        debugPrint('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        debugPrint('appLifeCycleState paused');
        break;
      case AppLifecycleState.detached:
        debugPrint('appLifeCycleState detached');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigationService.navigatorKey,
        home: const HomeSplashScreen(),
        theme: Styles.themeData(
            Provider.of<ThemeProvider>(context, listen: true).darkTheme ??
                false,
            context),
        onGenerateRoute: (routeSettings) {
          switch (routeSettings.name) {
            case 'poolDetails':
              return MaterialPageRoute(
                  builder: (context) =>
                      PoolDetails(poolId: routeSettings.arguments! as String));
            case 'chatRoom':
              return MaterialPageRoute(
                  builder: (context) => ChatRoomScreen(
                      poolId: routeSettings.arguments.toString().split("|")[0],
                      roomId:
                          routeSettings.arguments.toString().split("|")[1]));
            case 'home':
            default:
              return MaterialPageRoute(
                  builder: (context) => const MainTabBar());
          }
        },
        navigatorObservers: [
          FirebaseAnalyticsObserver(
              analytics: firebaseAnalyticsService.firebaseAnalytics),
          navigationService.routeObserver
        ]);
  }
}
