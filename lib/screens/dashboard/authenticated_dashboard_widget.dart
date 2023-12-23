import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/loading.dart';
import 'package:pegasus_tool/main.dart';
import 'package:pegasus_tool/models/my_address_model.dart';
import 'package:pegasus_tool/network/pivot_rewards/pivot_rewards_client.dart';
import 'package:pegasus_tool/repository/mary_db_sync_status_repository.dart';
import 'package:pegasus_tool/repository/my_addresses_repository.dart';
import 'package:pegasus_tool/screens/dashboard/account_widgets.dart';
import 'package:pegasus_tool/services/firebase_auth_service.dart';
import 'package:pegasus_tool/user/login_sign_up/add_account_widget.dart';

class AuthenticatedDashboardWidget extends StatefulWidget {
  const AuthenticatedDashboardWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthenticatedDashboardWidgetState();
  }
}

class _AuthenticatedDashboardWidgetState
    extends State<AuthenticatedDashboardWidget> {
  StreamSubscription? verifiedAccountsSubscription;

  bool isLoading = true;
  bool isRewardProcessing = true;
  List<MyAddress>? verifiedAddresses;
  late num currentEpoch;

  MaryDbSyncStatusRepository maryDbSyncStatusRepository =
      GetIt.I<MaryDbSyncStatusRepository>();
  FirebaseAuthService firebaseAuthService = GetIt.I<FirebaseAuthService>();
  MyAddressesRepository myAddressesRepository =
      GetIt.I<MyAddressesRepository>();

  @override
  void initState() {
    super.initState();
    maryDbSyncStatusRepository.getMaryDbSyncStatus().then((maryDbSyncStatus) {
      if (mounted) {
        setState(() {
          currentEpoch = maryDbSyncStatus.epochNo!;
          isRewardProcessing =
              maryDbSyncStatus.waitstakeCompleteEpoch != (currentEpoch + 1);
        });
        initAccounts();
      }
    }, onError: (Object o) {});
  }

  @override
  void dispose() {
    verifiedAccountsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingWidget()
        : Scaffold(
            body: Material(
                color: Theme.of(context).colorScheme.background,
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 0.0, left: 8.0, right: 8.0),
                        child: AccountWidgets(
                          currentEpoch: currentEpoch,
                          isRewardProcessing: isRewardProcessing,
                          verifiedAddresses: verifiedAddresses,
                        )))),
            floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddAccountWidget()),
                  );
                }));
  }

  void pivotRewards(stakeKey) async {
    PivotRewardsClient pivotRewardsClient = PivotRewardsClient(dio);
    PivotRewardsRequest pivotRewardsRequest =
        PivotRewardsRequest(stake_key: stakeKey);
    await pivotRewardsClient.pivotRewards(pivotRewardsRequest);
  }

  void initAccounts() async {
    verifiedAccountsSubscription =
        myAddressesRepository.getMyAddresses().listen((addresses) {
      setState(() {
        isLoading = false;
        verifiedAddresses = addresses;

        for (var address in addresses) {
          pivotRewards(address.address);
        }
      });
    });
  }
}
