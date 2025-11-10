import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final phpFormat = NumberFormat.currency(
  locale: 'en_PH',
  symbol: '₱',
);

class ProductDetailOverlayContent extends StatelessWidget {
  const ProductDetailOverlayContent({
    super.key,
    required this.productName,
    required this.price,
  });

  final String productName;
  final int price;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.4),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            productName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            phpFormat.format(price),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
