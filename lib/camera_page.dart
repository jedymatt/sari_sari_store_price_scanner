import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sari_sari_store_price_scanner/result_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  MobileScannerController cameraController = MobileScannerController(
    returnImage: true,
    facing: CameraFacing.back,
  );
  bool hasResult = false;

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        controller: cameraController,
        startDelay: true,
        onDetect: (capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
          }

          await cameraController.stop();
          if (!mounted) return;
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ResultPage(
                barcodes: barcodes,
                image: image,
              ),
            ),
          );
          await cameraController.start();
        },
      ),
    );
  }
}
