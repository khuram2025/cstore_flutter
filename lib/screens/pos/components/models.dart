import 'package:flutter/material.dart';

import '../pos.dart';

class OrderItem {
  final Product product;
  int quantity;

  OrderItem({required this.product, this.quantity = 1});

  // Calculate the total price for this item
  double get totalPrice => double.parse(product.salePrice) * quantity;
}

class TaxOption {
  final int id;
  final String name;
  final double rate;

  TaxOption({required this.id, required this.name, required this.rate});

  static TaxOption fromJson(Map<String, dynamic> json) {
    return TaxOption(
      id: json['id'],
      name: json['name'],
      rate: double.parse(json['rate'].toString()), // Convert to string and then to double
    );
  }
}

