import 'package:flutter/material.dart';

class InvoiceScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  InvoiceScreen({Key? key, required this.data}) : super(key: key) {
    print('InvoiceScreen constructed with data: $data'); // Add this line to check incoming data
  }

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    print('Building InvoiceScreen with data: ${widget.data}');
    String storeName = widget.data['storeName'] ?? 'ABC Store';
    String orderId = widget.data['orderId'].toString();
    String date = widget.data['date'] ?? '01-01-2023';
    String customerName = widget.data['customerName'] ?? 'John Doe';
    List<Map<String, dynamic>> items = widget.data['items'] ?? [
      {'name': 'Product A', 'quantity': 2, 'price': 10.0},
      {'name': 'Product B', 'quantity': 1, 'price': 20.0}
    ];
    double subtotal = double.tryParse(widget.data['subtotal'].toString()) ?? 0.0;
    print('InvoiceScreen Data: ${widget.data}');
    double discountValue = widget.data['discount_value'] is double
        ? widget.data['discount_value']
        : double.tryParse(widget.data['discount_value'].toString()) ?? 0.0;
    bool isDiscountPercentage = widget.data['is_discount_percentage'] == true;

    print('Discount Value: $discountValue');
    print('Is Discount Percentage: $isDiscountPercentage');

    double tax = double.tryParse(widget.data['tax'].toString()) ?? 0.0;
    double total = double.tryParse(widget.data['total'].toString()) ?? 0.0;

    String formatDiscount() {
      // This function will format the discount value correctly based on its type
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


            _buildTotalSection(
              'Discount',
              discountValue,
              additionalText: isDiscountPercentage ? "$discountValue%" : "\$$discountValue",
            ),


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
    print('Building total section: $title, Amount: $amount, Additional Text: $additionalText');
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: isTotal ? TextStyle(fontWeight: FontWeight.bold) : null),
          Text(
            (additionalText != null ? additionalText + ' - ' : '') + '\$${amount.toStringAsFixed(2)}',
            style: isTotal ? TextStyle(fontWeight: FontWeight.bold) : null,
          ),
        ],
      ),
    );
  }
}
