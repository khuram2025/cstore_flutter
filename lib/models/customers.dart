import 'package:flutter/material.dart';


class Customer {
  final int? id;
  final String? name;
  final String? email;
  final String? mobile;
  final String? address;
  final String? imagePath;
  final int? storeId;
  final double? openingBalance;
  final String? customerSince; // New field
  final double? remainingBalance; // New field
  final String? customerLevel; // New field

  Customer({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.address,
    this.imagePath,
    this.storeId,
    this.openingBalance,
    this.customerSince,
    this.remainingBalance,
    this.customerLevel,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    final openingBalanceJson = json['openingBalance'];
    double? openingBalance;
    if (openingBalanceJson != null) {
      if (openingBalanceJson is Map && openingBalanceJson.containsKey('\$Decimal')) {
        String decimalString = openingBalanceJson['\$Decimal'];
        openingBalance = double.tryParse(decimalString);
      } else if (openingBalanceJson is String) {
        openingBalance = double.tryParse(openingBalanceJson);
      } else {
        openingBalance = openingBalanceJson.toDouble();
      }
    }
    final remainingBalance = _parseDecimal(json['remaining_balance']);
    return Customer(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      mobile: json['mobile'] ?? 'N/A',
      address: json['address'] ?? 'N/A',
      imagePath: json['imagePath'] ?? 'path/to/default/image.png',
      storeId: json['store_id'] ?? 1,
      openingBalance: openingBalance,
      customerSince: json['customer_since'] ?? 'Unknown',
      remainingBalance: remainingBalance,
      customerLevel: json['customer_level'] ?? 'Standard',
    );
  }
  static double? _parseDecimal(dynamic value) {
    if (value == null) return null;
    // Check if the value is a Map and if it contains a key that resembles 'Decimal'
    if (value is Map && value.containsKey('\$Decimal')) {
      return double.tryParse(value['\$Decimal']);
    }
    return double.tryParse(value.toString());
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'address': address,
      'imagePath': imagePath,
      'store_id': storeId,
      'opening_balance': openingBalance ?? 0.0,
      'customer_since': customerSince,
      'remaining_balance': remainingBalance ?? 0.0,
      'customer_level': customerLevel,
    };
  }
}



class Transaction {
  final int id;
  final DateTime date;
  final String description;
  final double amount;
  final bool isIncome; // True for income, false for expense

  Transaction({
    required this.id,
    required this.date,
    required this.description,
    required this.amount,
    required this.isIncome,
  });
}
class LedgerEntry {
  final int id;
  final String type;
  final String date;
  final double amount;

  LedgerEntry({
    required this.id,
    required this.type,
    required this.date,
    required this.amount,
  });

  factory LedgerEntry.fromJson(Map<String, dynamic> json) {
    return LedgerEntry(
      id: json['id'] as int,
      type: json['type'] as String,
      date: json['date'] as String,
      amount: double.parse(json['amount'].toString()),
    );
  }

}

class ManualTransaction {
  final int customerId;
  final double amount;
  final String transactionType;
  final String date; // Assuming date is in 'yyyy-MM-dd' format
  final String notes;

  ManualTransaction({
    required this.customerId,
    required this.amount,
    required this.transactionType,
    required this.date,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'amount': amount,
      'transaction_type': transactionType,
      'transaction_date': date,
      'notes': notes,
    };
  }
}
