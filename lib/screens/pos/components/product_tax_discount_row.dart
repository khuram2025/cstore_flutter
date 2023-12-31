import 'package:flutter/material.dart';

import 'models.dart';

class ProductTaxDiscountRow extends StatefulWidget {
  final List<TaxOption> taxOptions;  // Dummy data for tax options
  final void Function(TaxOption) onTaxSelected;
  final void Function(double, bool) onDiscountChanged;
  final TextEditingController discountController;

  ProductTaxDiscountRow({
    Key? key,
    required this.taxOptions,
    required this.onTaxSelected,
    required this.onDiscountChanged,
    required this.discountController,
  }) : super(key: key);

  @override
  _ProductTaxDiscountRowState createState() => _ProductTaxDiscountRowState();
}

class _ProductTaxDiscountRowState extends State<ProductTaxDiscountRow> {
  bool isPercentage = true; // Tracks whether the discount is a percentage or amount
  TaxOption? selectedTaxOption;

  void _toggleDiscountType(bool percentageSelected) {
    setState(() {
      isPercentage = percentageSelected;
      widget.onDiscountChanged(double.tryParse(widget.discountController.text) ?? 0.0, isPercentage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          _buildDropdownContainer(),
          SizedBox(width: 10),
          _buildDiscountContainer(),
        ],
      ),
    );
  }

  Widget _buildDropdownContainer() {
    return Expanded(
      child: Container(
        height: 30,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF9F9F9E)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<TaxOption>(
            isExpanded: true,
            value: selectedTaxOption, // You need to manage this state
            hint: Text("Select Tax"),
            items: widget.taxOptions.map((TaxOption taxOption) {
              return DropdownMenuItem<TaxOption>(
                value: taxOption,
                // Display both name and rate in the dropdown item
                child: Text("${taxOption.name} (${taxOption.rate}%)"),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedTaxOption = newValue;
              });
              widget.onTaxSelected(newValue!); // Pass the selected TaxOption object
            },
          ),
        ),

      ),
    );
  }

  Widget _buildDiscountContainer() {
    return Expanded(
      child: Container(
        height: 30,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF9F9F9E)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.discountController,
                decoration: InputDecoration(
                  labelText: 'Discount',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  double discount = double.tryParse(value) ?? 0.0;
                  widget.onDiscountChanged(discount, isPercentage);
                },
              ),
            ),
            _buildDiscountToggleButton(Icons.percent, isPercentage),
            _buildDiscountToggleButton(Icons.attach_money, !isPercentage),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountToggleButton(IconData icon, bool isActive) {
    return InkWell(
      onTap: () => _toggleDiscountType(isActive),
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isActive ? Color(0xFFFC8019) : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(icon, color: isActive ? Colors.white : Color(0xFF9F9F9E)),
      ),
    );
  }
}
