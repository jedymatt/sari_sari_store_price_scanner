import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sari_scan/add_product_barcode_page.dart';
import 'package:sari_scan/result_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  MobileScannerController cameraController = MobileScannerController(
    facing: CameraFacing.back,
  );

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: make the price dynamic
    final productName = 'Coca-Cola 1.5L';
    final price = 0;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: cameraController,
            fit: BoxFit.cover,
            onDetect: (capture) async {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                debugPrint('Barcode found! ${barcode.rawValue}');
              }
            },
            // overlay builder product name and price
            overlayBuilder: (context, controller) {
              return Column(
                children: [
                  const Spacer(),
                  Container(
                    color: Colors.black.withOpacity(0.4),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          productName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '₱ $price',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   bottom: 0,
          //   child: Container(
          //     color: Colors.black.withOpacity(0.4),
          //     padding: const EdgeInsets.all(16),
          //     child: Column(
          //       children: [
          //         Text(
          //           productName,
          //           textAlign: TextAlign.center,
          //           style: const TextStyle(
          //             color: Colors.white,
          //             fontSize: 18,
          //             fontWeight: FontWeight.w500,
          //           ),
          //         ),
          //         Text(
          //           '₱ $price',
          //           textAlign: TextAlign.center,
          //           style: const TextStyle(
          //             color: Colors.white,
          //             fontSize: 24,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
