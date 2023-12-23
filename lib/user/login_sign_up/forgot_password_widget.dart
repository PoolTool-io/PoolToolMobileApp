import 'package:flutter/material.dart';

import 'login_forgot_password_widget.dart';
import 'verify_forgot_password_widget.dart';

class ForgotPasswordWidget extends LoginForgotPasswordWidget {
  const ForgotPasswordWidget({super.key})
      : super(
            submitButtonTitle: "Continue",
            onSubmitClickedAction: navigateToVerifyForgotPasswordWidget,
            titlePartOne: "Forgot",
            titlePartTwo: "Password",
            explanationText:
                "Specify your stake key and a new password. Then proceed to send the fee to verify and we will update your account to the new password.",
            showForgotPasswordOption: false);

  static navigateToVerifyForgotPasswordWidget(BuildContext context,
      String address, String password, updateLoadingState) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerifyForgotPasswordWidget(
                address: address, password: password)));
  }
}
