import 'package:flutter/material.dart';

class AddProductDetailsPage extends StatelessWidget {
  const AddProductDetailsPage(this.barcode, {super.key});

  final String barcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product Details'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Barcode: $barcode'),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Product Name',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Product Price',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Add product to database
              Navigator.of(context)
                ..pop()
                ..pop();
            },
            child: const Text('Add Product'),
          ),
        ],
      ),
    );
  }
}
