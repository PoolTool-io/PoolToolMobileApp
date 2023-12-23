import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pegasus_tool/common/bezier_container.dart';
import 'package:pegasus_tool/loading.dart';
import 'package:pegasus_tool/main.dart';
import 'package:pegasus_tool/network/auth/auth_client.dart';
import 'package:pegasus_tool/network/verification/verification_client.dart';
import 'package:pegasus_tool/provider/user_id_preference.dart';
import 'package:pegasus_tool/services/firebase_auth_service.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';
import 'package:pegasus_tool/services/firebase_messaging_service.dart';
import 'package:pegasus_tool/services/navigator_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils.dart';

abstract class VerifyAccountForgotPasswordWidget extends StatefulWidget {
  final String? password;
  final String address;
  final String loadingContent;
  final String titlePartOne;
  final String titlePartTwo;
  final String contactUsTitle;
  final Function getInitialVerificationStatusFunc;
  final Function pollVerificationStatusFunc;
  final Function buildSuccessWidget;

  const VerifyAccountForgotPasswordWidget(
      {super.key,
      required this.address,
      this.password,
      required this.loadingContent,
      required this.titlePartOne,
      required this.titlePartTwo,
      required this.contactUsTitle,
      required this.getInitialVerificationStatusFunc,
      required this.pollVerificationStatusFunc,
      required this.buildSuccessWidget});

  @override
  State<StatefulWidget> createState() {
    return _VerifyAccountForgotPasswordWidgetState();
  }
}

class _VerifyAccountForgotPasswordWidgetState
    extends State<VerifyAccountForgotPasswordWidget> {
  VerificationStatus? verificationStatus;
  bool polling = false;
  bool showTakingTooLong = false;
  final userIdPreference = UserIdPreference();
  final verificationClient = VerificationClient(dio);
  final authClient = AuthClient(dio);

  final NavigationService navigationService = GetIt.I<NavigationService>();
  final FirebaseAuthService firebaseAuthService =
      GetIt.I<FirebaseAuthService>();
  final FirebaseMessagingService firebaseMessagingService =
      GetIt.I<FirebaseMessagingService>();
  final FirebaseDatabaseService firebaseDatabaseService =
      GetIt.I<FirebaseDatabaseService>();

  @override
  void initState() {
    super.initState();
    loadVerificationStatus();
  }

  Widget _continueButton() {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () {
              setState(() {
                polling = true;
              });
              pollVerificationStatus(0);
            },
            child: const Text("Continue")));
  }

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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SizedBox(
            height: height,
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Positioned(
                      top: -height * .15,
                      right: -MediaQuery.of(context).size.width * .4,
                      child: const BezierContainer()),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: height * .2),
                        _title(),
                        SizedBox(height: height * .1),
                        buildContent()
                      ],
                    ),
                  ),
                  Positioned(top: 40, left: 0, child: _backButton())
                ],
              ),
            )));
  }

  Widget buildContent() {
    return Column(children: [
      verificationStatus != null
          ? Text(
              "To prove your ownership send ${(verificationStatus!.paymentAmount / 1000000).toStringAsFixed(3)} ADA to the following address from the account you are verifying and then click the continue button to verify your account. The ADA you send is to a wallet owned by PoolTool and is considered to be a verification fee which will be used to further develop the platform.",
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center)
          : Container(),
      const SizedBox(height: 16),
      verificationStatus != null
          ? InkWell(
              onTap: () {
                copyPaymentAddress();
              },
              child: ListTile(
                leading: Icon(Icons.content_copy,
                    color: Theme.of(context).iconTheme.color),
                title: Text(verificationStatus!.paymentToAddress,
                    style: const TextStyle(
                        fontSize: 13.0, fontStyle: FontStyle.italic)),
              ))
          : Container(),
      const SizedBox(height: 20),
      polling || verificationStatus == null ? Container() : _continueButton(),
      const SizedBox(height: 20),
      polling || verificationStatus == null
          ? const LoadingWidget()
          : Container(),
      const SizedBox(height: 20),
      polling
          ? Text(widget.loadingContent,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold))
          : Container(),
      const SizedBox(height: 32),
      verificationStatus != null && polling && showTakingTooLong
          ? const Text(
              "This is taking longer than expected! The network might be congested. If you are having difficulties please send us an email with the transaction details and we will look into this for you.",
              textAlign: TextAlign.center)
          : Container(),
      verificationStatus != null && polling && showTakingTooLong
          ? SizedBox(
              width: double.infinity,
              child: TextButton(
                  onPressed: () {
                    contactUs();
                  },
                  child: const Text(
                    "Contact Us",
                    style: TextStyle(fontSize: 12, color: Colors.greenAccent),
                  )))
          : Container()
    ]);
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: widget.titlePartOne,
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.bodyLarge,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0033AD),
          ),
          children: [
            TextSpan(
              text: widget.titlePartTwo,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontSize: 30),
            ),
          ]),
    );
  }

  void copyPaymentAddress() {
    Clipboard.setData(
        ClipboardData(text: verificationStatus!.paymentToAddress));
    showSuccessToast("Address is copied to clipboard");
  }

  void loadVerificationStatus() async {
    verificationStatus = await widget
        .getInitialVerificationStatusFunc()
        .catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioException:
          // Here's the sample to get the failed response error code and message
          final res = (obj as DioException).response;
          if (res!.statusCode == 422) {
            showInfoDialogWithCallback(
                context,
                "Error",
                "This address is already registered by a user.",
                () => Navigator.pop(context));
          } else if (res.statusCode == 400) {
            showInfoDialogWithCallback(context, "Error",
                "This is an invalid address.", () => Navigator.pop(context));
          } else {
            showUnexpectedErrorDialog();
          }
          return null;
        default:
          showUnexpectedErrorDialog();
          return null;
      }
    });

    if (verificationStatus != null) {
      if (verificationStatus!.status == "pending") {
        setState(() {
          verificationStatus = verificationStatus;
        });
      } else if (verificationStatus!.status == "verified") {
        showInfoDialogWithCallback(
            context,
            "Ops",
            "You already verified this account!",
            () => navigationService.goHome(context));
      } else {
        showInfoDialogWithCallback(
            context,
            "Error",
            "An unexpected error happened. Please try again",
            () => navigationService.goHome(context));
      }
    }
  }

  void showUnexpectedErrorDialog() {
    showInfoDialogWithCallback(
        context,
        "Error",
        "An unexpected error happened. Please try again",
        () => Navigator.pop(context));
  }

  void pollVerificationStatus(int retryCount) async {
    if (retryCount > 2) {
      setState(() {
        showTakingTooLong = true;
      });
    }

    try {
      verificationStatus = await widget.pollVerificationStatusFunc();
    } on dynamic catch (e) {
      debugPrint(e.toString());
    }

    if (verificationStatus!.status == "verified") {
      if (firebaseAuthService.firebaseAuth.currentUser == null) {
        login();
      } else {
        String userId = firebaseAuthService.firebaseAuth.currentUser!.uid;
        setGcmTokenAndNavigateToSuccess(userId);
      }
    } else {
      Future.delayed(const Duration(seconds: 10),
          () => pollVerificationStatus(retryCount + 1));
    }
  }

  void login() async {
    LoginRequest loginRequest =
        LoginRequest(address: widget.address, password: widget.password!);
    try {
      LoginResponse loginResponse = await authClient.login(loginRequest);
      UserCredential userCredential = await firebaseAuthService.firebaseAuth
          .signInWithCustomToken(loginResponse.token);
      await setGcmTokenAndNavigateToSuccess(userCredential.user!.uid);
        } on dynamic catch (_) {
      pollVerificationStatus(0);
    }
  }

  Future setGcmTokenAndNavigateToSuccess(String userId) async {
    String? token = await firebaseMessagingService.firebaseMessaging.getToken();
    await firebaseDatabaseService.firebaseDatabase
        .ref()
        .child("${getEnvironment()}/users/auth/$userId/gcm_token")
        .set(token);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget.buildSuccessWidget()),
    );
  }

  void contactUs() async {
    String userId = await userIdPreference.getUserId();
    String body =
        "TransactionID:\n\n\n\nIssue Details:\n\n\n\nAdditional information for debugging:\n $userId|${widget.address}";
    String url =
        "mailto:mike@pooltool.io?subject=${widget.contactUsTitle}&body=$body";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      debugPrint('Could not launch $url');
      showInfoDialog(context, "Contact Us",
          "Please send details of the issue with your transaction ID to mike@pooltool.io");
    }
  }
}
