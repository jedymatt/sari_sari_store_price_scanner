import 'package:flutter/material.dart';

class PriceResultScreen extends StatelessWidget {
  const PriceResultScreen({super.key, required this.barcodeValue});
  final String barcodeValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(barcodeValue),
        ],
      ),
    );
  }
}
