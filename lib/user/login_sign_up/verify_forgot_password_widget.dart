import 'package:pegasus_tool/network/auth/auth_client.dart';
import 'package:pegasus_tool/network/verification/verification_client.dart';
import 'package:pegasus_tool/user/login_sign_up/verify_account_forgot_password_widget.dart';

import '../../main.dart';
import 'forgot_password_success_widget.dart';

class VerifyForgotPasswordWidget extends VerifyAccountForgotPasswordWidget {
  @override
  final String address;
  @override
  final String password;

  VerifyForgotPasswordWidget(
      {super.key, required this.address, required this.password})
      : super(
          address: address,
          password: password,
          loadingContent: "Your password is being reset.\nPlease wait...",
          titlePartOne: "Forgot",
          titlePartTwo: "Password",
          contactUsTitle: "Unable to Reset Password",
          getInitialVerificationStatusFunc: () =>
              getInitialVerificationStatus(address, password),
          pollVerificationStatusFunc: () => pollVerificationStatus(address),
          buildSuccessWidget: () => const ForgotPasswordSuccessWidget(),
        );

  static Future<VerificationStatus> getInitialVerificationStatus(
      String address, String password) async {
    AuthClient authClient = AuthClient(dio);
    ForgotPasswordRequestBody body =
        ForgotPasswordRequestBody(address: address, password: password);
    return authClient.forgotPasswordPost(body);
  }

  static Future<VerificationStatus> pollVerificationStatus(
      String address) async {
    AuthClient authClient = AuthClient(dio);
    return authClient.getVerificationStatus(address);
  }
}
