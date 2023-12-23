import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/drawer/drawer_widget.dart';
import 'package:pegasus_tool/provider/theme_provider.dart';
import 'package:pegasus_tool/screens/dashboard/dashboard_proxy.dart';
import 'package:pegasus_tool/screens/explorer/explorer_widget.dart';
import 'package:pegasus_tool/screens/favorites/favorites.dart';
import 'package:pegasus_tool/screens/pools/pools_widget.dart';
import 'package:pegasus_tool/services/firebase_auth_service.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:provider/provider.dart';

class MainTabBar extends StatefulWidget {
  const MainTabBar({super.key});

  @override
  MainTabBarState createState() => MainTabBarState();
}

class MainTabBarState extends State<MainTabBar> {
  int currentPage = 0;

  GlobalKey bottomNavigationKey = GlobalKey();
  bool didRunAnimation = false;
  PoolsWidget? poolsWidget;
  String appBarTitle = "Dashboard";
  bool hasCheckedForceUpgrade = false;
  bool isLoggedIn = false;

  final FirebaseAuthService firebaseAuthService =
      GetIt.I<FirebaseAuthService>();
  final FirebaseDatabaseService firebaseDatabaseService =
      GetIt.I<FirebaseDatabaseService>();

  @override
  void initState() {
    super.initState();
    firebaseDatabaseService.firebaseDatabase.setPersistenceEnabled(false);
    init();
  }

  void init() async {
    var user = firebaseAuthService.firebaseAuth.currentUser;
    if (user != null) {
      //String token = await user.getIdToken(false);
      //login address: addr1qy5nha0duumfpa407sntuycfeyy0f3xn3tjg0ww0whdzuxkz6dlxpqhca3freqtejk23yvmn4xcmayjvhd6h2lq388sqcjch9l
      //debugPrint("Token: " + token);
    }
    setState(() {
      isLoggedIn = user != null;
    });
  }

  void checkForceUpdate(BuildContext context) async {
    // if (!hasCheckedForceUpgrade) {
    //   var packageInfo = await PackageInfo.fromPlatform();
    //   var platform = Platform.isIOS ? "ios" : "android";
    //   var minimumBuildNumber = await firebaseDatabase
    //       .ref()
    //       .child(getEnvironment() + '/minimum_build_number/$platform')
    //       .once();
    //   if (minimumBuildNumber?.value != null) {
    //     var appBuildNumber = int.parse(packageInfo.buildNumber);
    //     if (appBuildNumber < minimumBuildNumber.value) {
    //       showDialog(
    //           context: context,
    //           barrierDismissible: false,
    //           builder: (_) {
    //             return WillPopScope(
    //                 onWillPop: () {
    //                   return Future.value(false);
    //                 },
    //                 child: new AlertDialog(
    //                   title: new Text("New version available!"),
    //                   content: new Text(
    //                       "Update to the latest version of the app to get the best user experience and the newest features."),
    //                   actions: <Widget>[
    //                     FlatButton(
    //                       child: Text('Update it!'),
    //                       onPressed: () {
    //                         LaunchReview.launch(
    //                             androidAppId: "com.pegasus.tool",
    //                             iOSAppId: "1495556387",
    //                             writeReview: false);
    //                       },
    //                     )
    //                   ],
    //                 ));
    //           });
    //     }
    //     hasCheckedForceUpgrade = true;
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: true);
    checkForceUpdate(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: Text(appBarTitle)),
      body: Container(
        child: _getPage(currentPage),
      ),
      bottomNavigationBar: SafeArea(
        child: ClipRect(
          clipper: _Clipper(),
          child: FancyBottomNavigation(
            barBackgroundColor: Theme.of(context).bottomAppBarTheme.color,
            inactiveIconColor: Styles.APP_COLOR,
            circleColor: Styles.APP_COLOR,
            textColor: Theme.of(context).textTheme.bodyLarge!.color,
            tabs: [
              TabData(iconData: Icons.dashboard, title: "Dashboard"),
              TabData(iconData: Icons.explore, title: "Explorer"),
              TabData(iconData: Icons.public, title: "Pools"),
              TabData(iconData: Icons.star, title: "Favorites")
            ],
            initialSelection: 0,
            key: bottomNavigationKey,
            onTabChangedListener: (position) {
              setState(() {
                currentPage = position;
                switch (currentPage) {
                  case 0:
                    appBarTitle = "Dashboard";
                    break;
                  case 1:
                    appBarTitle = "Explorer";
                    break;
                  case 2:
                    appBarTitle = "Pools";
                    break;
                  default:
                    appBarTitle = "Favorites";
                }
              });
            },
          ),
        ),
      ),
      drawer: DrawerWidget(themeProvider: themeProvider),
    );
  }

  _getPage(int page) {
    Widget widget;
    switch (page) {
      case 0:
        widget = const DashboardProxyWidget();
        break;
      case 1:
        widget = const ExplorerWidget();
        didRunAnimation = true;
        break;
      case 2:
        poolsWidget ??= const PoolsWidget();
        widget = poolsWidget!;
        break;
      default:
        widget = const FavoritesWidget();
    }
    return widget;
  }

  // requestReview() {
  //   if (Platform.isIOS) {
  //     AppReview.openIosReview(appId: "1495556387", compose: true);
  //   } else {
  //     AppReview.openGooglePlay();
  //   }
  // }

  // void logout() async {
  //   await firebaseAuth.signOut();
  //   setState(() {
  //     isLoggedin = false;
  //     FlutterRestart.restartApp();
  //   });
  // }
}

class _Clipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, -size.height, size.width, size.height * 2);

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}
