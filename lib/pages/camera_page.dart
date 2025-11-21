import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sari_scan/core/data.dart';
import 'package:sari_scan/components/product_detail_overlay_content.dart';
import 'package:sari_scan/pages/product_management/register_product_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  MobileScannerController cameraController = MobileScannerController(
    facing: CameraFacing.back,
    autoStart: false, // we will start it manually in initState
  );
  Barcode? barcode;
  StreamSubscription<Object?>? _subscription;
  Timer? _clearTimer;

  @override
  void initState() {
    _subscription = cameraController.barcodes.listen(_handleBarcodes);

    super.initState();
    unawaited(cameraController.start());
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    cameraController.dispose();
    _clearTimer?.cancel();
  }

  void _handleBarcodes(BarcodeCapture barcodeCapture) {
    if (barcodeCapture.barcodes.isEmpty) {
      return;
    }
    barcode = barcodeCapture.barcodes.first;

    _clearTimer?.cancel();
    _clearTimer = Timer(const Duration(seconds: 1), () {
      setState(() {
        barcode = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    late final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(const Offset(0, -100)),
      width: MediaQuery.sizeOf(context).width,
      height: 400,
    );

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: cameraController,
            fit: BoxFit.cover,
            scanWindow: scanWindow,
            // rectangle scan window designed for barcode scanning
            // scanWindow: Rect.fromCenter(
            //   center: MediaQuery.of(context).size.center(Offset.zero),
            //   width: 250,
            //   height: 100,
            // ),
          ),
          ScanWindowOverlay(
            controller: cameraController,
            scanWindow: scanWindow,
          ),
          BarcodeOverlay(
            boxFit: BoxFit.cover,
            controller: cameraController,
          ),
          Column(
            children: [
              const Spacer(),
              StreamBuilder<BarcodeCapture>(
                stream: cameraController.barcodes,
                builder: (context, snapshot) {
                  final code = barcode?.rawValue;
                  if (code == null) {
                    return const SizedBox.shrink();
                  }

                  final product = data[code];
                  if (product == null) {
                    // No product found
                    // Register?
                    return Column(
                      children: [
                        Container(
                          color: Colors.black.withValues(alpha: 0.4),
                          padding: const EdgeInsets.all(16),
                          child: const Text(
                            'Product not found',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to add_product_page.dart
                            cameraController.stop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterProductPage(
                                  barcode: code,
                                  format: barcode!.format,
                                ),
                              ),
                            );
                            cameraController.start();
                          },
                          child: const Text('Register Product'),
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  }

                  return ProductDetailOverlayContent(
                    productName: product['name'] as String,
                    price: product['price'] as int,
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
