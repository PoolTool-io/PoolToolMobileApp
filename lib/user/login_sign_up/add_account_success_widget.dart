import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/common/bezier_container.dart';
import 'package:pegasus_tool/services/firebase_auth_service.dart';
import 'package:pegasus_tool/user/login_sign_up/verify_account_widget.dart';

class AddAccountSuccessWidget extends StatefulWidget {
  final String address;
  final bool showAccountAddedSuccess;

  const AddAccountSuccessWidget(
      {Key? key, required this.address, required this.showAccountAddedSuccess})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddAccountSuccessWidgetState();
  }
}

class _AddAccountSuccessWidgetState extends State<AddAccountSuccessWidget> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  FirebaseAuthService firebaseAuthService = GetIt.I<FirebaseAuthService>();

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            const Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _continueButton() {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () {
              if (getUser() != null || _formKey.currentState!.validate()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VerifyAccountWidget(
                          address: widget.address,
                          password: passwordController.text.trim())),
                );
              }
            },
            child: const Text("Continue")));
  }

  Widget _successImage() {
    return Image(
        height: MediaQuery.of(context).size.height / 10,
        image: const AssetImage('assets/green_check.png'));
  }

  Widget _verifyImage() {
    return Image(
        height: MediaQuery.of(context).size.height / 10,
        image: const AssetImage('assets/green_shield.png'));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SizedBox(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: const BezierContainer()),
          SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                SizedBox(height: height * .2),
                widget.showAccountAddedSuccess
                    ? _successImage()
                    : _verifyImage(),
                const SizedBox(height: 32),
                const Text(
                    "To be able to track the rewards of this account, receive notifications and have private chats with pool owners you need to verify the ownership of the account by sending a small amount of ADA to a specific account from the wallet you've taken your address.",
                    textAlign: TextAlign.center),
                const SizedBox(height: 16),
                getUser() == null
                    ? const Text(
                        "To get started enter a password you wish to use to login to PoolTool:",
                        textAlign: TextAlign.center)
                    : Container(),
                getUser() == null
                    ? Form(
                        key: _formKey,
                        child: Column(children: <Widget>[
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: TextFormField(
                                          validator: passwordValidator(),
                                          controller: passwordController,
                                          obscureText: true,
                                          decoration: const InputDecoration(
                                              labelText: "Password",
                                              border: InputBorder.none,
                                              fillColor: Color(0xfff3f3f4),
                                              filled: true))),
                                ],
                              )),
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: TextFormField(
                                          validator: passwordValidator(),
                                          controller: confirmPasswordController,
                                          obscureText: true,
                                          decoration: const InputDecoration(
                                              labelText: "Confirm Password",
                                              border: InputBorder.none,
                                              fillColor: Color(0xfff3f3f4),
                                              filled: true))),
                                ],
                              )),
                        ]))
                    : Container(),
                const SizedBox(height: 20),
                _continueButton()
              ],
            ),
          )),
          Positioned(top: 40, left: 0, child: _backButton())
        ],
      ),
    ));
  }

  User? getUser() => firebaseAuthService.firebaseAuth.currentUser;

  FormFieldValidator<String> passwordValidator() {
    return (value) {
      if (value!.trim().length < 8) {
        return 'Password must be at least 8 characters!';
      }
      if (passwordController.text != confirmPasswordController.text) {
        return 'The passwords do not match!';
      }
      return null;
    };
  }
}
