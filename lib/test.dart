Widget _buildClickableText(String text, Color textColor, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Adjust padding to match height
      decoration: text == 'Add' ? null : BoxDecoration(
        color: textColor, // Background color for 'Discount' and 'Tax'
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: text == 'Add' ? textColor : Colors.white, // Text color
        ),
      ),
    ),
  );
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    // Your existing Scaffold code
    body: Column(
      // Your existing Column code
      children: [
        // Your existing children widgets
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildClickableText(
              'Add',
              Color(0xFF9F9F9E), // Text color for 'Add'
                  () {}, // You would implement what happens when 'Add' is tapped here
            ),
            Spacer(), // This will push all other items to the right
            _buildClickableText(
              'Discount',
              Color(0xFFFC8019),
              _showAddDiscountDialog, // Call the discount dialog function when 'Discount' is tapped
            ),
            SizedBox(width: 8), // Spacing between the items
            _buildClickableText(
              'Tax',
              Color(0xFFFC8019),
              _showAddTaxDialog, // You would implement the tax dialog function here
            ),
          ],
        ),
        // Your existing Divider, Padding, and other widgets
      ],
    ),
  );
}
