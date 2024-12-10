import 'package:flutter/material.dart';
import 'package:sari_scan/add_product_barcode_page.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(this.product, {super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        'https://via.placeholder.com/150?text=${product.name}',
      ),
      title: Text(
        product.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('₱ ${product.price}'),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {},
      ),
    );
  }
}

class ManageProductsPage extends StatelessWidget {
  const ManageProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> products = [
      Product(name: 'Happy', price: 1, barcode: '1234567890'),
      Product(name: 'Sky Flakes', price: 8, barcode: '1234567891'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddProductBarcodePage()),
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
}
