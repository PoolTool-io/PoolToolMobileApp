import 'package:flutter/material.dart';
import 'package:pegasus_tool/user/login_sign_up/add_account_widget.dart';
import 'package:pegasus_tool/user/login_sign_up/got_an_account_widget.dart';
import 'package:pegasus_tool/user/login_sign_up/login_sign_up_widget.dart';

class AddAccountsWidget extends StatelessWidget {
  const AddAccountsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Material(
            color: Theme.of(context).colorScheme.background,
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(children: [
                      const SizedBox(height: 32),
                      Image(
                          height: MediaQuery.of(context).size.height / 5,
                          image: const AssetImage('assets/onboarding2.png')),
                      const SizedBox(height: 32),
                      const Text(ADD_ACCOUNT_INTRO_TEXT,
                          textAlign: TextAlign.center),
                      const SizedBox(height: 32),
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AddAccountWidget()),
                                );
                              },
                              child: const Text("Add Account"))),
                      const SizedBox(height: 8),
                      const GotAnAccountWidget(),
                    ])))));
  }
}
