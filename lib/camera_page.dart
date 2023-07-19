import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:sari_sari_store_price_scanner/price_result_screen.dart';
import './camera_manager.dart';
import './live_camera_preview.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  final CameraManager _cameraManager = Get.find<CameraManager>();
  bool cameraPause = false;

  @override
  void dispose() {
    super.dispose();
    _barcodeScanner.close();
  }

  @override
  Widget build(BuildContext context) {
    return LiveCameraPreview(
      camera: _cameraManager.camera,
      onImage: processImage,
    );
  }

  Future processImage(InputImage inputImage) async {
    final barcodes = await _barcodeScanner.processImage(inputImage);

    if (barcodes.isEmpty) return;

    if (!mounted) return;

    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return PriceResultScreen(
          barcodeValue: barcodes.first.rawValue!,
        );
      },
    ));
  }
}
