import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/common/bezier_container.dart';
import 'package:pegasus_tool/services/navigator_service.dart';

abstract class AuthSuccessWidget extends StatefulWidget {
  final String title;
  final String subtitle;

  const AuthSuccessWidget(
      {Key? key, required this.title, required this.subtitle})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AuthSuccessWidgetState();
  }
}

class _AuthSuccessWidgetState extends State<AuthSuccessWidget> {
  final NavigationService navigationService = GetIt.I<NavigationService>();

  Widget _continueButton() {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () {
              navigationService.goHome(context);
            },
            child: const Text("Go to My Dashboard")));
  }

  Widget _successImage() {
    return Image(
        height: MediaQuery.of(context).size.height / 8,
        image: const AssetImage('assets/green_check.png'));
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                SizedBox(height: height * .2),
                _successImage(),
                const SizedBox(height: 16),
                Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(widget.subtitle, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                _continueButton()
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
