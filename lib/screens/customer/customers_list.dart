import 'package:cstore_flutter/responsive.dart';
import 'package:cstore_flutter/screens/customer/components/addNewCustomer.dart';
import 'package:cstore_flutter/screens/customer/components/customerDetailScreen.dart';
import 'package:cstore_flutter/screens/dashboard/components/header.dart';
import 'package:cstore_flutter/screens/main/components/side_menu.dart';

import 'package:flutter/material.dart';
import '../../../constants.dart';

class Customer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });
}

// Dummy data for customers
List<Customer> dummyCustomers = [
  Customer(
    id: '1',
    name: 'John Doe',
    email: 'john.doe@example.com',
    phone: '123-456-7890',
    address: '123 Main Street, Anytown, AT 12345',
  ),
  Customer(
    id: '2',
    name: 'Jane Smith',
    email: 'jane.smith@example.com',
    phone: '098-765-4321',
    address: '456 Oak Street, Othertown, OT 67890',
  ),
  // Add more dummy customers as needed
];


class CustomerListScreen extends StatefulWidget {
  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Customer? selectedCustomer; // The selected customer for detail view
  bool isAddingNewCustomer = false; // To determine if we are adding a new customer

  final List<Customer> customers = dummyCustomers;



  void onCustomerSelected(Customer customer) {
    setState(() {
      selectedCustomer = customer;
      isAddingNewCustomer = false;
    });
  }

  void onAddCustomer() {
    setState(() {
      selectedCustomer = null;
      isAddingNewCustomer = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget detailScreen = selectedCustomer != null
        ? CustomerDetailScreen(customer: selectedCustomer!) // selectedCustomer must be the correct Customer type
        : AddCustomerScreen();

    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context)) Expanded(child: SideMenu()),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                primary: false,
                padding: EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    Header(scaffoldKey: _scaffoldKey),

                    Expanded(
                      child: CustomerListView(
                        customers: customers,
                        onCustomerSelected: onCustomerSelected,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!Responsive.isMobile(context))
              SizedBox(width: defaultPadding),
            if (!Responsive.isMobile(context))
              Expanded(
                flex: 2,
                child: isAddingNewCustomer ? AddCustomerScreen() : (selectedCustomer != null ? CustomerDetailScreen(customer: selectedCustomer!) : Container()),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomerListView extends StatelessWidget {
  final List<Customer> customers;
  final Function(Customer) onCustomerSelected;

  CustomerListView({Key? key, required this.customers, required this.onCustomerSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return ListTile(
          title: Text(customer.name),
          subtitle: Text(customer.email),
          onTap: () => onCustomerSelected(customer),
        );
      },
    );
  }
}




// Example of using the Customer class with dummy data

