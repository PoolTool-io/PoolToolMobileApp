import 'auth_success_widget.dart';

class ForgotPasswordSuccessWidget extends AuthSuccessWidget {
  const ForgotPasswordSuccessWidget({super.key})
      : super(
            title: "Your password has now been successfully changed",
            subtitle: "You are now logged in.");
}
