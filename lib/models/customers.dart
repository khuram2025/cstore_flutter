import 'package:flutter/material.dart';



class Customer {
  final int id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? imagePath;

  Customer({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.imagePath,
  });

  // Factory constructor for creating a new Customer instance from a map
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'] as String?, // Assuming 'name' is the JSON field for the customer's name
      email: json['email'] as String?, // Same assumption for 'email'
      phone: json['phone'] as String?, // Same assumption for 'phone'
      address: json['address'] as String?, // Same assumption for 'address'
      imagePath: json['imagePath'] as String?, // Same assumption for 'imagePath'
    );
  }

  // Method to convert Customer instance to a map (useful for sending data back to the server)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'imagePath': imagePath,
    };
  }
}
