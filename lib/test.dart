// Define the colors
const grey = Color(0xFF9F9F9E);
const amberSea = Color(0xFFFC8019);
const green = Color(0xFF09AA29);

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Column(
        // Other widgets...
        Expanded(
          // Other widgets...
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildPaymentOption('Cash', Icons.monetization_on, grey, () {
                // Handle Cash Payment Logic
              }),
              _buildPaymentOption('Credit', Icons.credit_card, amberSea, () {
                // Handle Credit Payment Logic
              }),
              _buildPaymentOption('Multiple Pay', Icons.payment, green, () {
                // Handle Multiple Payment Logic
              }),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildPaymentOption(String title, IconData icon, Color bgColor, VoidCallback onPressed) {
  return Expanded(
    child: InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: Colors.white, size: 30),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
}
