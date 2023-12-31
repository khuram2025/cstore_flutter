void _showAddDiscountDialog() {
  // Default to percentage
  String selectedDiscountType = '%';
  TextEditingController discountController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(16.0),
            content: Container(
              height: 130,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add Discount', style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      _buildDiscountTypeButton(setState, '\$', selectedDiscountType, discountController),
                      SizedBox(width: 8),
                      _buildDiscountTypeButton(setState, '%', selectedDiscountType, discountController),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: discountController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Color(0xFF9f9f9e))),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildActionButtons(context, setState, discountController, selectedDiscountType),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildDiscountTypeButton(StateSetter setState, String type, String selectedDiscountType, TextEditingController controller) {
  return Expanded(
    child: GestureDetector(
      onTap: () => setState(() {
        selectedDiscountType = type;
      }),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selectedDiscountType == type ? Color(0xFFFC8019) : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: selectedDiscountType == type ? Colors.transparent : Color(0xFF9f9f9e)),
        ),
        child: Text(
          type,
          textAlign: TextAlign.center,
          style: TextStyle(color: selectedDiscountType == type ? Colors.white : Color(0xFF9f9f9e)),
        ),
      ),
    ),
  );
}

// Rest of your code remains the same
