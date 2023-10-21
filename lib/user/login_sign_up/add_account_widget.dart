import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pegasus_tool/common/barcode_scanner_screen.dart';
import 'package:pegasus_tool/common/bezier_container.dart';

import 'add_account_success_widget.dart';

class AddAccountWidget extends StatefulWidget {
  const AddAccountWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddAccountWidgetState();
  }
}

class _AddAccountWidgetState extends State<AddAccountWidget> {
  final addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? barcode;

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

  FormFieldValidator<String> addressValidator() {
    return (value) {
      if (value!.isEmpty || value.length < 9 || !value.startsWith("addr1")) {
        return 'Address should start with addr1...\n';
      }
      return null;
    };
  }

  Widget _submitButton() {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                navigateToSuccess();
              }
            },
            child: const Text("Continue")));
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Add',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.bodyLarge,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.greenAccent,
          ),
          children: [
            TextSpan(
              text: 'Account',
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontSize: 30),
            ),
          ]),
    );
  }

  Widget _accountNameAddress() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 24),
            const Text(
                "Find your address in the \"receive\" section of your wallet. Adding an account is safe and secure, the app does not ask for any private key or seed phrase."),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                            validator: addressValidator(),
                            controller: addressController,
                            inputFormatters: [
                              FilteringTextInputFormatter(RegExp("[A-Za-z0-9]"),
                                  allow: true),
                            ],
                            decoration: const InputDecoration(
                                labelText: "Enter your address",
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true))),
                    IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: scan,
                        iconSize: 24,
                        color: Theme.of(context).iconTheme.color)
                  ],
                ))
          ],
        ));
  }

  @override
  void dispose() {
    // nameController.dispose();
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
                  _accountNameAddress(),
                  const SizedBox(height: 20),
                  _submitButton(),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    ));
  }

  void navigateToSuccess() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddAccountSuccessWidget(
              showAccountAddedSuccess: true, address: addressController.text)),
    );
  }
}
