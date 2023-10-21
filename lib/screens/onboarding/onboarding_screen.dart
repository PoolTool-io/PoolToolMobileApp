import 'package:flutter/material.dart';
import 'package:sk_onboarding_screen/flutter_onboarding.dart';
import 'package:sk_onboarding_screen/sk_onboarding_screen.dart';

class OnboardingScreen extends StatelessWidget {
  final Function onDoneFunc;

  OnboardingScreen({Key? key, required this.onDoneFunc}) : super(key: key);

  final pages = [
    SkOnboardingModel(
        title: 'Choose your Stake Pool',
        description:
            'Easily find your ideal Stake Pool by applying the filters that match your criteria',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/onboarding1.jpg'),
    SkOnboardingModel(
        title: 'Track Your Rewards',
        description: 'See exactly when and how much your Stake Pool earns you',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/onboarding2.jpg'),
    SkOnboardingModel(
        title: 'Get Notifications',
        description:
            'Fee change, saturation, new block, reward alerts and more. PoolTool has you covered!',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/onboarding3.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SKOnboardingScreen(
        bgColor: Colors.white,
        themeColor: const Color(0xFF0033AD),
        pages: pages,
        skipClicked: (value) {
          onDoneFunc();
        },
        getStartedClicked: (value) {
          onDoneFunc();
        },
      ),
    );
  }
}
