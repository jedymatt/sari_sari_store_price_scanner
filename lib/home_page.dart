import 'package:flutter/material.dart';
import 'package:sari_sari_store_price_scanner/camera_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
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
      ),
    );
  }
}
