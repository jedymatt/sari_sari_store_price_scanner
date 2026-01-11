import 'package:flutter/material.dart';
import 'package:sari_scan/db.dart';
import 'package:sari_scan/models.dart';
import 'package:sari_scan/pages/camera_page.dart';

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
      body: FutureBuilder(
          future: queryProducts(),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final products = asyncSnapshot.data ?? [];

            if (products.isEmpty) {
              return const Center(child: Text('No products found.'));
            }

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(products[index]);
              },
            );
          }),
    );
  }
}
