import 'package:flutter/material.dart';

import 'common/color_loader.dart';
import 'styles/theme_data.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Colors.transparent),
        child: const Align(
            alignment: Alignment.center,
            child: ColorLoader(dotThreeColor: Styles.APP_COLOR)));
  }
}
