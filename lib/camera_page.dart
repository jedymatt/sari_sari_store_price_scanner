import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sari_scan/product_detail_overlay_content.dart';

const data = {
  '5449000000996': {'name': 'Coca-Cola 1.5L', 'price': 50},
};

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
    return Scaffold(
      body: MobileScanner(
        controller: cameraController,
        fit: BoxFit.cover,
        // overlay builder product name and price
        overlayBuilder: (context, controller) {
          return Column(
            children: [
              const Spacer(),
              StreamBuilder<BarcodeCapture>(
                stream: cameraController.barcodes,
                builder: (context, snapshot) {
                  if (barcode == null) {
                    return const SizedBox.shrink();
                  }

                  final code = barcode!.rawValue ?? '---';
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
                          onPressed: () {},
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
          );
        },
      ),
    );
  }
}
