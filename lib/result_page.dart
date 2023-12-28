import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key, required this.barcodes, this.image});

  final List<Barcode> barcodes;
  final Uint8List? image;

  @override
  Widget build(BuildContext context) {
    debugPrint('result page');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detected'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null)
              Image.memory(
                image!,
                width: 300,
                height: 300,
              ),
            const SizedBox(height: 20),
            Text(
              barcodes.map((e) => e.rawValue).join(', '),
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
