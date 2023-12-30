import 'package:flutter/material.dart';

import '../pos.dart';

class OrderItem {
  final Product product;
  int quantity;

  OrderItem({required this.product, this.quantity = 1});

  // Calculate the total price for this item
  double get totalPrice => double.parse(product.salePrice) * quantity;
}

