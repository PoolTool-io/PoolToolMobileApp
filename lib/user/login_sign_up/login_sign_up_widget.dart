import 'package:flutter/material.dart';
import 'package:pegasus_tool/user/login_sign_up/add_account_widget.dart';
import 'package:pegasus_tool/user/login_sign_up/got_an_account_widget.dart';

class LoginSignUpWidget extends StatefulWidget {
  const LoginSignUpWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginSignUpWidgetState();
  }
}

//TODO refresh this page in onResume - user might have registered / logged in in the meantime

class _LoginSignUpWidgetState extends State<LoginSignUpWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(children: [
              const SizedBox(height: 32),
              Image(
                  height: MediaQuery.of(context).size.height / 5,
                  image: const AssetImage('assets/onboarding2.png')),
              const SizedBox(height: 32),
              const Text(ADD_ACCOUNT_INTRO_TEXT, textAlign: TextAlign.center),
              const SizedBox(height: 32),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddAccountWidget()),
                        );
                      },
                      child: const Text("Add Account"))),
              const SizedBox(height: 32),
              const GotAnAccountWidget(),
            ])));
  }
}

const ADD_ACCOUNT_INTRO_TEXT =
    "Track your rewards, get notified when rewards are distributed and access premium services offered by Stake Pool Operators. Add an account by typing or scanning an address from the wallet you used to delegate to your chosen pool. You can find this address in the \"receive\" section in Daedalus or Yoroi. Adding an account is safe and secure, the app does not ask for any private key or seed and as per our privacy policy, we don't collect any data that is sufficient to identify you. You can add as many accounts as you wish.";

const List<Color> signInGradients = [
  Color(0xFF0EDED2),
  Color(0xFF03A0FE),
];

const List<Color> signUpGradients = [
  Color(0xFFFF9945),
  Color(0xFFFc6076),
];
