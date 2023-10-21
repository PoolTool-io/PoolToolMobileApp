import 'package:flutter/material.dart';

class Glossary extends StatelessWidget {
  const Glossary({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar: AppBar(title: const Text("Glossary")),
            body: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                    child:
                        Text("Coming soon!", textAlign: TextAlign.center)))));
  }
}
