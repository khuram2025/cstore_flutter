import 'package:flutter/material.dart';

class InvoiceScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  InvoiceScreen({Key? key, required this.data}) : super(key: key) {
    print('InvoiceScreen constructed with data: $data'); // Add this line to check incoming data
  }


  @override
  Widget build(BuildContext context) {
    String storeName = data['storeName'] ?? 'ABC Store';
    String orderId = data['orderId'].toString();
    String date = data['date'] ?? '01-01-2023';
    String customerName = data['customerName'] ?? 'John Doe';
    List<Map<String, dynamic>> items = data['items'] ?? [
      {'name': 'Product A', 'quantity': 2, 'price': 10.0},
      {'name': 'Product B', 'quantity': 1, 'price': 20.0}
    ];
    double subtotal = double.tryParse(data['subtotal'].toString()) ?? 0.0;
    print('InvoiceScreen Data: $data');
    double discountValue = double.tryParse(data['discount_value'].toString()) ?? 0.0;
    bool isDiscountPercentage = data['is_discount_percentage'] == true; // This ensures it's a boolean

    print('Discount Value: $discountValue');
    print('Is Discount Percentage: $isDiscountPercentage');
    double tax = double.tryParse(data['tax'].toString()) ?? 0.0;
    double total = double.tryParse(data['total'].toString()) ?? 0.0;

    String formatDiscount() {
      if (isDiscountPercentage) {
        return "$discountValue%";
      } else {
        return "\$$discountValue";
      }
    }



    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        width: 300, // Width similar to a thermal printer paper
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Store: $storeName', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 5),
            Text('Customer: $customerName'),
            Text('Order ID: $orderId'),
            Text('Date: $date'),
            Divider(),
            ...items.map((item) => ListTile(
              title: Text(item['name']),
              trailing: Text('${item['quantity']} x \$${item['price']}'),
            )),
            Divider(),
            _buildTotalSection('Subtotal', subtotal),


            _buildTotalSection('Discount', discountValue, additionalText: formatDiscount()),


            _buildTotalSection('Tax', tax),
            _buildTotalSection('Total', total, isTotal: true),
            SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.spaceEvenly,
              children: [
                _buildButton(context, 'Print', Icons.print, Color(0xFFFC8019), () {}),
                _buildButton(context, 'WhatsApp', Icons.print, Color(0xFF09AA29), () {}),
                _buildButton(context, 'Save', Icons.save, Color(0xFF9F9F9E), () {}),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close', style: TextStyle(color: Color(0xFF9F9F9E))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildTotalSection(String title, double amount, {bool isTotal = false, String? additionalText}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: isTotal ? TextStyle(fontWeight: FontWeight.bold) : null),
          Text(
            '${additionalText != null ? "$additionalText - " : ""}\$${amount.toStringAsFixed(2)}',
            style: isTotal ? TextStyle(fontWeight: FontWeight.bold) : null,
          ),
        ],
      ),
    );
  }


}
