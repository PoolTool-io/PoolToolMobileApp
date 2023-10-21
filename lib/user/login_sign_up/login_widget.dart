import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/network/auth/auth_client.dart';
import 'package:pegasus_tool/services/firebase_auth_service.dart';

import '../../utils.dart';
import 'login_forgot_password_widget.dart';

class LoginWidget extends LoginForgotPasswordWidget {
  LoginWidget({Key? key})
      : super(
          key: key,
          submitButtonTitle: "Login",
          onSubmitClickedAction: (context, address, password, setLoadingFunc) =>
              login(context, address, password, setLoadingFunc),
          titlePartOne: "Log",
          titlePartTwo: "In",
          explanationText: null,
          showForgotPasswordOption: true,
        );
}

void login(context, address, password, Function setLoadingFunc) async {
  FirebaseAuthService firebaseAuthService = GetIt.I<FirebaseAuthService>();

  LoginRequest loginRequest =
      LoginRequest(address: address, password: password);

  setLoadingFunc(true);

  try {
    bool isLoggedIn = await firebaseAuthService.login(loginRequest);
    if (isLoggedIn) {
      Navigator.pop(context);
    } else {
      showInfoDialog(
          context, "Error", "Something went wrong! Please try again.");
    }

    setLoadingFunc(false);
  } on dynamic catch (_) {
    setLoadingFunc(false);
    showInfoDialog(context, "Error", "Invalid address or password");
  }
}
