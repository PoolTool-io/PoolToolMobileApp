import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class BarcodeScannerScreen extends StatefulWidget {
  final Function(String) onScanFunc;

  const BarcodeScannerScreen({super.key, required this.onScanFunc});

  @override
  BarcodeScannerScreenState createState() => BarcodeScannerScreenState();
}

class BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  late String qr;

  bool qrRead = false;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Scan a QR code'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Center(
              child: QrCamera(
                onError: (context, error) => Text(
                  error.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
                qrCodeCallback: (code) {
                  if (!qrRead) {
                    qrRead = true;
                    widget.onScanFunc(code!);
                    Navigator.pop(context);
                  }
                },
              ),
            )),
          ],
        ),
      ),
    ));
  }
}
