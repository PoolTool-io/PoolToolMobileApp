import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/loading.dart';
import 'package:pegasus_tool/screens/dashboard/authenticated_dashboard_widget.dart';
import 'package:pegasus_tool/screens/dashboard/unauthenticated_dashboard_widget.dart';
import 'package:pegasus_tool/services/firebase_auth_service.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';
import 'package:pegasus_tool/services/firebase_messaging_service.dart';
import 'package:pegasus_tool/services/navigator_service.dart';
import 'package:pegasus_tool/user/login_sign_up/login_sign_up_widget.dart';
import 'package:pegasus_tool/utils.dart';

class DashboardProxyWidget extends StatefulWidget {
  const DashboardProxyWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DashboardProxyWidgetState();
  }
}

class _DashboardProxyWidgetState extends State<DashboardProxyWidget>
    with RouteAware {
  User? user;
  bool? isLoggedIn;
  dynamic accounts;
  late Function onAllAccountsRemoved;

  NavigationService navigationService = GetIt.I<NavigationService>();
  FirebaseAuthService firebaseAuthService = GetIt.I<FirebaseAuthService>();
  FirebaseDatabaseService firebaseDatabaseService =
      GetIt.I<FirebaseDatabaseService>();
  FirebaseMessagingService firebaseMessagingService =
      GetIt.I<FirebaseMessagingService>();
  StreamSubscription<bool>? isLoggedInStreamSubscription;

  @override
  void initState() {
    super.initState();

    isLoggedInStreamSubscription =
        firebaseAuthService.isLoggedInStream.listen((event) {
      setState(() {
        isLoggedIn = event;
      });
    });

    onAllAccountsRemoved = () => reloadData();
    loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    navigationService.routeObserver
        .subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    navigationService.routeObserver.unsubscribe(this);
    isLoggedInStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  void didPopNext() {
    reloadData();
  }

  void reloadData() {
    setState(() {
      isLoggedIn = null;
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      return const LoadingWidget();
    }
    if (isLoggedIn == true) {
      return const AuthenticatedDashboardWidget();
    } else if (accounts != null) {
      return UnauthenticatedDashboardWidget(
          onAllAccountsRemoved: onAllAccountsRemoved);
    } else {
      return const LoginSignUpWidget();
    }
  }

  loadData() async {
    user = firebaseAuthService.firebaseAuth.currentUser;
    String? token = await firebaseMessagingService.firebaseMessaging.getToken();
    DatabaseReference accountsRef = firebaseDatabaseService.firebaseDatabase
        .ref()
        .child(getEnvironment())
        .child("legacy_users")
        .child(token!)
        .child("accounts");
    accounts = (await accountsRef.once()).snapshot.value;
    if (mounted) {
      setState(() {
        isLoggedIn = user != null;
      });
    }
  }
}
