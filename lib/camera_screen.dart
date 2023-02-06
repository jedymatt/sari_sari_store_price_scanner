import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:sari_sari_price_scanner/live_camera_preview.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  late CameraDescription camera;

  @override
  void initState() {
    super.initState();

    _setCamera();
  }

  @override
  Widget build(BuildContext context) {
    return LiveCameraPreview(
      camera: camera,
      onImage: (inputImage) {},
    );
  }

  Future _setCamera() async {
    camera = (await availableCameras()).first;
  }

  Future processImage(InputImage inputImage) async {
    final barcodes = await _barcodeScanner.processImage(inputImage);

    print(barcodes);
    // TODO: If barcode is detected then move to PriceResultScreen.dart
  }
}
