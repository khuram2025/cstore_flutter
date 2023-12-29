import 'package:flutter/material.dart';

class OrderSummarySection extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double discount;
  final double total;

  OrderSummarySection({
    Key? key,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the colors from the provided color palette
    const accentColor = Color(0xFFFC8019);
    const popColor = Color(0xFF09AA29);
    const highlightColor = Color(0xFFFFF2E8);
    const typeDarkColor = Color(0xFF171826);
    const typeFadedColor = Color(0xFF9F9F9E);
    const separatorsColor = Color(0xFFF5F5F5);

    // Styles for text
    final headlineStyle = TextStyle(
      color: typeDarkColor,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );

    final textStyle = TextStyle(
      color: typeFadedColor,
      fontSize: 16,
    );

    final buttonStyle = ElevatedButton.styleFrom(
      primary: popColor,
      onPrimary: Colors.white,
    );

    return Container(
      color: highlightColor, // Background color for the section
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', subtotal, textStyle),
          _buildSummaryRow('Discount', discount, textStyle),
          _buildSummaryRow('Tax', tax, textStyle),
          Divider(color: separatorsColor),
          _buildSummaryRow('Total', total, headlineStyle),
          SizedBox(height: 16),
          ElevatedButton(
            style: buttonStyle,
            onPressed: () {
              // TODO: Implement the order submission logic
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text('Proceed', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, TextStyle textStyle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle),
          Text('\$${amount.toStringAsFixed(2)}', style: textStyle),
        ],
      ),
    );
  }
}
