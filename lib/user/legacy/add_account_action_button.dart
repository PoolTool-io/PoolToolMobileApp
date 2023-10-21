import 'package:flutter/material.dart';
import 'package:pegasus_tool/user/login_sign_up/add_account_widget.dart';

class AddWalletActionButton extends StatelessWidget {
  const AddWalletActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddAccountWidget()),
          );
        });
  }
}
