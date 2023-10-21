import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/main.dart';
import 'package:pegasus_tool/network/verification/verification_client.dart';
import 'package:pegasus_tool/provider/user_id_preference.dart';
import 'package:pegasus_tool/services/firebase_auth_service.dart';
import 'package:pegasus_tool/user/login_sign_up/verify_account_forgot_password_widget.dart';
import 'package:pegasus_tool/user/login_sign_up/verify_account_success_widget.dart';

class VerifyAccountWidget extends VerifyAccountForgotPasswordWidget {
  @override
  final String? password;
  @override
  final String address;

  VerifyAccountWidget({super.key, required this.address, this.password})
      : super(
          address: address,
          password: password,
          loadingContent: "Your account is being verified.\nPlease wait...",
          titlePartOne: "Verify",
          titlePartTwo: "Account",
          contactUsTitle: "Unable to Verify Account",
          getInitialVerificationStatusFunc: () =>
              getInitialVerificationStatus(address, password!),
          pollVerificationStatusFunc: () => pollVerificationStatus(address),
          buildSuccessWidget: () => const VerifyAccountSuccessWidget(),
        );

  static Future<VerificationStatus> getInitialVerificationStatus(
      String address, String password) async {
    String userId = await getUserId();
    VerificationClient verificationClient = VerificationClient(dio);
    VerificationStatusPostBody body =
        VerificationStatusPostBody(userId: userId, password: password);
    return verificationClient.postVerificationStatus(address, body);
  }

  static Future<VerificationStatus> pollVerificationStatus(
      String address) async {
    String userId = await getUserId();
    VerificationClient verificationClient = VerificationClient(dio);
    return verificationClient.getVerificationStatus(address, userId);
  }

  static Future<String> getUserId() async =>
      GetIt.I<FirebaseAuthService>().firebaseAuth.currentUser == null
          ? await UserIdPreference().getUserId()
          : GetIt.I<FirebaseAuthService>().firebaseAuth.currentUser!.uid;
}
