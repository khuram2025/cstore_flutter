import 'package:cstore_flutter/screens/customer/customers_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Ensure flutter_svg is added in your pubspec.yaml

class CustomerDetailScreen extends StatelessWidget {
  final Customer customer;

  const CustomerDetailScreen({Key? key, required this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data for icons, replace with your actual assets
    final String emailIcon = 'assets/icons/email.svg';
    final String phoneIcon = 'assets/icons/phone.svg';
    final String locationIcon = 'assets/icons/location.svg';

    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Information'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // TODO: Implement edit functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              // Placeholder for customer image
              radius: 50.0,
              backgroundImage: AssetImage('assets/images/customer_placeholder.png'),
            ),
            SizedBox(height: 20),
            Text(
              customer.name,
              style: Theme.of(context).textTheme.headline5?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Contact Information',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Divider(),
            ListTile(
              leading: SvgPicture.asset(emailIcon),
              title: Text(customer.email),
            ),
            ListTile(
              leading: SvgPicture.asset(phoneIcon),
              title: Text("Customer Contact"),
            ),
            ListTile(
              leading: SvgPicture.asset(locationIcon),
              title: Text(customer.address),
            ),
            // Add more fields as necessary
          ],
        ),
      ),
    );
  }
}

