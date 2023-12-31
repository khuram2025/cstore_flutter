import 'package:flutter/material.dart';

class OrderActionsRow extends StatelessWidget {
  final VoidCallback onAddTap;
  final VoidCallback onDiscountTap;
  final VoidCallback onTaxTap;


  OrderActionsRow({
    Key? key,
    required this.onAddTap,
    required this.onDiscountTap,
    required this.onTaxTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildClickableText(
          'Add',
          Color(0xFF9F9F9E),
          onAddTap,
        ),
        Spacer(),
        _buildClickableText(
          'Discount',
          Color(0xFFFC8019),
          onDiscountTap,
        ),
        SizedBox(width: 8),
        _buildClickableText(
          'Tax',
          Color(0xFFFC8019),
          onTaxTap,
        ),
      ],
    );
  }

  Widget _buildClickableText(String text, Color textColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: textColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
