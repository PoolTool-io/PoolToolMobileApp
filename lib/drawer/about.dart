import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pegasus_tool/common/brought_to_you_by_widget.dart';
import 'package:pegasus_tool/styles/theme_data.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
          return Material(
              child: Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  appBar: AppBar(title: const Text("About")),
                  body: SingleChildScrollView(
                      child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(children: [
                            const SizedBox(height: 10),
                            const Image(
                                height: 100,
                                image: AssetImage('assets/logo.png')),
                            const SizedBox(height: 30),
                            const Text(
                                "PoolTool is an online platform built to facilitate the interaction between Stake Pool Operators and their stakeholders. Our goal is to provide our users with useful tools and the most up-to-date information on Cardano, including staking, in-depth research and exclusive offers from SPOs."),
                            const SizedBox(height: 60),
                            const BroughtToYouByWidget(),
                            const SizedBox(height: 60),
                            Text("App version: ${snapshot.data?.version}",
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontStyle: FontStyle.italic,
                                    color: Styles.INACTIVE_COLOR_DARK)),
                          ])))));
        });
  }
}
