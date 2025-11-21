import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.barcodes, this.image});

  final List<Barcode> barcodes;
  final Uint8List? image;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final barcode = widget.barcodes.first.rawValue!;

    final product = getProducts().firstWhere(
      (element) => element['barcode'] == barcode,
      orElse: () => {},
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detected'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.image != null)
              Image.memory(
                widget.image!,
                width: 300,
                height: 300,
              ),
            const SizedBox(height: 20),
            Text(
              barcode,
              style: const TextStyle(fontSize: 20),
            ),
            productExists(barcode)
                ? Column(
                    children: [
                      Text(
                        product['product_name'],
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        product['price'].toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      const Text('Product does not exist'),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Add Product?'),
                      )
                    ],
                  ),
            TextButton.icon(
              icon: const Icon(Icons.home),
              label: const Text('Back to Home'),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Map> getProducts() {
    return [
      {
        "barcode": "9578545203541",
        "product_name": "Coca Cola 1.5L",
        "price": 2.50
      },
    ];
  }

  bool productExists(String barcode) {
    return getProducts().any((element) => element['barcode'] == barcode);
  }
}
