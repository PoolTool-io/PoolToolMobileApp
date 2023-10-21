import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/models/my_address_model.dart';
import 'package:pegasus_tool/screens/dashboard/verified_account_widget.dart';
import 'package:pegasus_tool/services/firebase_auth_service.dart';

class AccountWidgets extends StatelessWidget {
  final List<MyAddress>? verifiedAddresses;
  final bool isRewardProcessing;
  final num currentEpoch;
  final FirebaseAuthService firebaseAuthService =
      GetIt.I<FirebaseAuthService>();

  AccountWidgets(
      {Key? key,
      required this.verifiedAddresses,
      required this.isRewardProcessing,
      required this.currentEpoch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (verifiedAddresses == null) {
      return Container();
    }

    List<Widget> accounts = [];

    for (MyAddress myAddress in verifiedAddresses!) {
      accounts.add(VerifiedAccountWidget(
          isRewardProcessing: isRewardProcessing,
          user: firebaseAuthService.firebaseAuth.currentUser!,
          stakeKeyHash: myAddress.address,
          nickname: myAddress.nickname,
          currentEpoch: currentEpoch));
    }

    accounts.add(const SizedBox(height: 72));

    return Column(children: accounts);
  }
}
