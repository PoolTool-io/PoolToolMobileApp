import 'package:flutter/material.dart';
import 'package:pegasus_tool/user/legacy/add_accounts.dart';

//TODO remove this and just use AddAccountsWidget
class UnauthenticatedDashboardWidget extends StatefulWidget {
  final Function onAllAccountsRemoved;

  const UnauthenticatedDashboardWidget(
      {Key? key, required this.onAllAccountsRemoved})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UnauthenticatedDashboardWidgetState();
  }
}

class _UnauthenticatedDashboardWidgetState
    extends State<UnauthenticatedDashboardWidget> {
  @override
  Widget build(BuildContext context) {
    return const AddAccountsWidget();
  }
}
