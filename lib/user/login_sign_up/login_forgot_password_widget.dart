// import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pegasus_tool/common/barcode_scanner_screen.dart';
import 'package:pegasus_tool/common/bezier_container.dart';
import 'package:pegasus_tool/loading.dart';

import 'forgot_password_widget.dart';

abstract class LoginForgotPasswordWidget extends StatefulWidget {
  final String submitButtonTitle;
  final Function onSubmitClickedAction;
  final String titlePartOne;
  final String titlePartTwo;
  final String? explanationText;
  final bool showForgotPasswordOption;

  const LoginForgotPasswordWidget(
      {super.key,
      required this.submitButtonTitle,
      required this.onSubmitClickedAction,
      required this.titlePartOne,
      required this.titlePartTwo,
      this.explanationText,
      required this.showForgotPasswordOption});

  @override
  State<StatefulWidget> createState() {
    return _LoginForgotPasswordWidgetState();
  }
}

class _LoginForgotPasswordWidgetState extends State<LoginForgotPasswordWidget> {
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? barcode;
  bool loading = false;

  void updateLoadingState(bool loading) {
    setState(() {
      this.loading = loading;
    });
  }

  FormFieldValidator<String> passwordValidator() {
    return (value) {
      if (value!.length < 8) {
        return 'Please enter your password';
      }
      return null;
    };
  }

  FormFieldValidator<String> addressValidator() {
    return (value) {
      if (value!.isEmpty || value.length < 9) {
        return 'Please enter a valid address\n';
      }
      return null;
    };
  }

  @override
  void dispose() {
    passwordController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future scan() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BarcodeScannerScreen(
              onScanFunc: (code) => {setState(() => barcode = code)})),
    );
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

  Widget _submitButton() {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSubmitClickedAction(context, addressController.text,
                    passwordController.text, updateLoadingState);
              }
            },
            child: Text(widget.submitButtonTitle)));
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
            color: Theme.of(context).colorScheme.secondary,
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

  Widget _addressPasswordWidget() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            widget.explanationText != null
                ? Text(widget.explanationText!)
                : Container(),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                            validator: addressValidator(),
                            controller: addressController,
                            readOnly: false,
                            focusNode: FocusNode(),
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                            autofocus: false,
                            enableInteractiveSelection: true,
                            inputFormatters: [
                              FilteringTextInputFormatter(RegExp("[A-Za-z0-9]"),
                                  allow: true),
                            ],
                            decoration: const InputDecoration(
                                labelText: "Wallet Address",
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true))),
                    IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: scan,
                        iconSize: 24,
                        color: Theme.of(context).iconTheme.color)
                  ],
                )),
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
                ))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (barcode != null) {
      addressController.text = barcode!;
      barcode = null;
    }
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _title(),
                  const SizedBox(height: 50),
                  _addressPasswordWidget(),
                  loading ? const LoadingWidget() : Container(),
                  const SizedBox(height: 20),
                  _submitButton(),
                  widget.showForgotPasswordOption
                      ? SizedBox(
                          width: double.infinity,
                          child: TextButton(
                              onPressed: () {
                                if (!loading) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPasswordWidget()),
                                  );
                                }
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              )))
                      : Container(),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    ));
  }
}
