import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pegasus_tool/common/label_value_widget.dart';
import 'package:pegasus_tool/user/legacy/account.dart';
import 'package:pegasus_tool/utils.dart';

import 'add_account_action_button.dart';

class AccountsListWidget extends StatelessWidget {
  final dynamic accounts;
  final num currentEpoch;
  final User user;
  final List<String> userVerifiedAddresses;
  final bool isRewardProcessing;

  const AccountsListWidget(
      {super.key,
      this.accounts,
      required this.currentEpoch,
      required this.user,
      required this.userVerifiedAddresses,
      required this.isRewardProcessing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Material(
            color: Theme.of(context).colorScheme.background,
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 0.0, left: 8.0, right: 8.0),
                child: SingleChildScrollView(
                    child: Column(
                  children: getAccountWidgets(context),
                )))),
        floatingActionButton: const AddWalletActionButton());
  }

  List<Widget> getAccountWidgets(BuildContext context) {
    var accountWidgets = <Widget>[];

    if (accounts.length > 1) {
      accountWidgets.add(accountsTotalView(context));
    }

    try {
      accounts.forEach((name, account) {
        if (account != null) {
          debugPrint("account: $account");
          accountWidgets.add(AccountWidget(
              account: account,
              currentEpoch: currentEpoch,
              userVerifiedAddresses: userVerifiedAddresses,
              isRewardProcessing: isRewardProcessing));
        }
      });
    } on dynamic catch (_) {
      accounts.forEach((account) {
        if (account != null) {
          debugPrint("account: $account");
          accountWidgets.add(AccountWidget(
              account: account,
              currentEpoch: currentEpoch,
              userVerifiedAddresses: userVerifiedAddresses));
        }
      });
    }
    accountWidgets.add(watchThisSpaceCard());
    accountWidgets.add(const SizedBox(height: 80));
    return accountWidgets;
  }

  Widget accountsTotalView(BuildContext context) {
    var totalRewards = 0.0;
    accounts.forEach((name, account) {
      if (account != null) {
        var rewards = account['rewards'];
        if (rewards != null) {
          try {
            rewards.forEach((epoch, p) {
              if (p != null) {
                var rewards = p['stakeRewards'].toDouble() / 1000000 +
                    p['operatorRewards'].toDouble() / 1000000;
                if (int.parse(epoch) != (currentEpoch - 1)) {
                  totalRewards += rewards;
                }
              }
            });
          } on dynamic catch (_) {
            try {
              rewards.forEach((p) {
                if (p != null) {
                  var rewards = p['stakeRewards'].toDouble() / 1000000 +
                      p['operatorRewards'].toDouble() / 1000000;
                  if (int.parse(p['epoch']) != currentEpoch - 1) {
                    totalRewards += rewards;
                  }
                }
              });
            } on dynamic catch (_) {}
          }
        }
      }
    });
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Card(
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LabelValueWidget(
                        onTapFunc: () {
                          showInfoDialog(context, "Total Rewards",
                              "The sum of the rewards in all the accounts. This figure does not include estimated rewards for upcoming epochs.");
                        },
                        label: "Total rewards in accounts",
                        value: "₳${format(totalRewards)}"),
                  ])))
    ]);
  }

  Widget watchThisSpaceCard() {
    return const Card(
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Padding(
            padding: EdgeInsets.only(
                top: 8.0, bottom: 0.0, left: 8.0, right: 0.0),
            child: Row(children: [
              Icon(
                Icons.dashboard_customize,
                size: 24.0,
              ),
              SizedBox(width: 8),
              Expanded(
                  child: Text("Stay tuned!", style: TextStyle(fontSize: 18.0)))
            ])),
        Divider(),
        Padding(
            padding: EdgeInsets.all(8),
            child: Text(
                "A more personalised dashboard showing you detailed information about your accounts and more is currently being built so watch this space and look out for app updates! In the meantime verify your addresses and make good use of the new chat features.")),
      ]),
    );
  }
}
