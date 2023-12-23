import 'package:flutter/material.dart';
import 'package:pegasus_tool/styles/button_styles.dart';

import 'login_widget.dart';

class GotAnAccountWidget extends StatelessWidget {
  const GotAnAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      const Text("Already got an account?", textAlign: TextAlign.center),
      SizedBox(
          width: double.infinity,
          child: TextButton(
              style: flatButtonStyle,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginWidget()),
                );
              },
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 12, color: Colors.greenAccent),
              )))
    ]);
  }
}
