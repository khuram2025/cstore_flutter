class InvoiceScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  InvoiceScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ... other code

    // Debug print statements
    print('InvoiceScreen Data: $data');
    double discountValue = double.tryParse(data['discount_value'].toString()) ?? 0.0;
    bool isDiscountPercentage = data['is_discount_percentage'] ?? false;

    // Print the discount value and whether it's a percentage
    print('Discount Value: $discountValue');
    print('Is Discount Percentage: $isDiscountPercentage');

    // ... rest of the code
  }

// ... rest of the InvoiceScreen code
}
