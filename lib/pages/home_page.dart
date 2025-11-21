import 'package:flutter/material.dart';
import 'package:sari_scan/pages/camera_page.dart';
import 'package:sari_scan/pages/product_management/manage_products_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/icon-transparent.png',
              width: 40,
              height: 40,
            ),
            const Text('Sari Scan'),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Open Camera'),
              onPressed: () {
                // Navigator.pushNamed(context, '/camera');
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CameraPage(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Manage Products'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ManageProductsPage(),
                  ),
                );
              },
            ),
            const ElevatedButton(
              onPressed: null,
              child: Text('Mga Utang (Coming Soon)'),
            ),
          ],
        ),
      ),
    );
  }
}
