import 'package:flutter/material.dart';
import 'package:sari_scan/add_product_barcode_page.dart';
import 'package:sari_scan/camera_page.dart';
import 'package:sari_scan/data.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(this.product, {super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        // Uri.encodeFull('https://placehold.co/150?text=${product.name}'),
        'https://picsum.photos/200/200?random=${DateTime.now().millisecondsSinceEpoch}',
      ),
      title: Text(
        product.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('₱ ${product.price}'),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          // Navigate to edit product page
        },
      ),
    );
  }
}

class ManageProductsPage extends StatelessWidget {
  const ManageProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> products =
        data.values.map((productMap) => Product.fromMap(productMap)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CameraPage()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(products[index]);
        },
      ),
    );
  }
}

class Product {
  final String name;
  final num price;
  final String barcode;

  Product({required this.name, required this.price, required this.barcode});

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] as String,
      price: map['price'] as num,
      barcode: map['barcode'] as String,
    );
  }
}
