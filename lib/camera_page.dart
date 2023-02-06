import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import './live_camera_preview.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  late CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CameraDescription>>(
        future: availableCameras(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container();
          }

          if (!snapshot.hasData) {
            return Container();
          }

          camera = snapshot.data!.first;

          return LiveCameraPreview(
            camera: camera,
            onImage: (inputImage) {
              processImage(inputImage);
            },
          );
        });
  }

  Future processImage(InputImage inputImage) async {
    final barcodes = await _barcodeScanner.processImage(inputImage);

    if (barcodes.isEmpty) return;

    print(barcodes);
    // TODO: If barcode is detected then move to PriceResultScreen.dart
  }
}
