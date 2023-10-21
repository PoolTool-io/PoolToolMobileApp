import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/services/firebase_messaging_service.dart';
import 'package:pegasus_tool/styles/theme_data.dart';

import 'color_loader.dart';

class SplashScreen extends StatefulWidget {
  final int seconds;
  final Text title;
  final Color backgroundColor;
  final TextStyle styleTextUnderTheLoader;
  final dynamic navigateAfterSeconds;
  final double photoSize;
  final dynamic onClick;
  final Color loaderColor;
  final Image image;
  final Widget loadingWidget;
  final ImageProvider? imageBackground;
  final Gradient? gradientBackground;

  const SplashScreen(
      {super.key,
      required this.loaderColor,
      required this.seconds,
      required this.photoSize,
      this.onClick,
      this.navigateAfterSeconds,
      this.title = const Text(''),
      this.backgroundColor = Colors.white,
      this.styleTextUnderTheLoader = const TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
      required this.image,
      this.loadingWidget = const Text(""),
      this.imageBackground,
      this.gradientBackground});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  FirebaseMessagingService firebaseMessagingService =
      GetIt.I<FirebaseMessagingService>();

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: widget.seconds), () {
      if (firebaseMessagingService.pushNotificationReceived) {
        return;
      }
      if (widget.navigateAfterSeconds is String) {
        // It's fairly safe to assume this is using the in-built material
        // named route component
        Navigator.of(context).pushReplacementNamed(widget.navigateAfterSeconds);
      } else if (widget.navigateAfterSeconds is Widget) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => widget.navigateAfterSeconds));
      } else {
        throw ArgumentError(
            'widget.navigateAfterSeconds must either be a String or Widget');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: widget.onClick,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              // decoration: new BoxDecoration(
              //   image: new DecorationImage(
              //     fit: BoxFit.cover,
              //     image: widget.imageBackground,
              //   ),
              //   gradient: widget.gradientBackground,
              //   color: widget.backgroundColor,
              // ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: widget.photoSize,
                        child: Container(child: widget.image),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      widget.title
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const ColorLoader(dotThreeColor: Styles.APP_COLOR),
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      widget.loadingWidget
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
