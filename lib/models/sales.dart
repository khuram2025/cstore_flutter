import 'package:flutter/material.dart';



class Sale {
  final int orderId;
  final String customerName;
  final String customerMobile;
  final int quantitySold;
  final double sellingPrice;
  final double totalPrice;

  Sale({
    required this.orderId,
    required this.customerName,
    required this.customerMobile,
    required this.quantitySold,
    required this.sellingPrice,
    required this.totalPrice,
  });

  // Add a method to parse JSON data
  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      orderId: json['order_id'],
      customerName: json['customer_name'],
      customerMobile: json['customer_mobile'],
      quantitySold: json['quantity_sold'],
      sellingPrice: json['selling_price'],
      totalPrice: json['total_price'],
    );
  }
}