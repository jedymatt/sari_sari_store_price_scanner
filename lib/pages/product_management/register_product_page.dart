import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart' hide Barcode;
import 'package:barcode_widget/barcode_widget.dart';
import 'package:sari_scan/core/data.dart';
import 'package:sari_scan/core/mobile_scanner_format_to_barcode_widget.dart';

class RegisterProductPage extends StatefulWidget {
  const RegisterProductPage({
    super.key,
    required this.barcode,
    required this.format,
  });
  final String barcode;
  final BarcodeFormat format;

  @override
  State<RegisterProductPage> createState() => _RegisterProductPageState();
}

class _RegisterProductPageState extends State<RegisterProductPage> {
  String name = '';
  String description = '';
  num price = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
            child: Text('Register Product ${widget.barcode}'),
          ),
          BarcodeWidget(
            data: widget.barcode,
            barcode: mobileScannerFormatToBarcodeWidget(widget.format),
            width: 200,
            height: 100,
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Product Name',
            ),
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Product Description',
            ),
            onChanged: (value) {
              setState(() {
                description = value;
              });
            },
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Product Price',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                price = num.tryParse(value) ?? 0;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              // Save product
              data[widget.barcode] = {
                'name': name,
                'description': description,
                'price': price,
                'barcode': widget.barcode,
              };

              Navigator.pop(context);
            },
            child: const Text('Save Product'),
          ),
        ],
      ),
    );
  }
}
