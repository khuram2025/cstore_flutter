import 'package:flutter/material.dart';



class Customer {
  final int? id;
  final String? name;
  final String? email;
  final String? mobile;
  final String? address;
  final String? imagePath;
  final int? storeId;  // Add store ID

  Customer({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.address,
    this.imagePath,
    this.storeId,
  });

  // Factory constructor for creating a new Customer instance from a map
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'] as String?, // Assuming 'name' is the JSON field for the customer's name
      email: json['email'] as String?, // Same assumption for 'email'
      mobile: json['mobile'] as String?, // Same assumption for 'phone'
      address: json['address'] as String?, // Same assumption for 'address'
      imagePath: json['imagePath'] as String?, // Same assumption for 'imagePath'
    );
  }

  // Method to convert Customer instance to a map (useful for sending data back to the server)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
      'address': address,
      'imagePath': imagePath,
    };
  }
}
