

import 'package:cstore_flutter/API/api_service.dart';
import 'package:cstore_flutter/models/customers.dart';
import 'package:cstore_flutter/screens/customer/components/customerDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:cstore_flutter/responsive.dart';
import 'package:cstore_flutter/screens/dashboard/components/header.dart';
import 'package:cstore_flutter/screens/main/components/side_menu.dart';
import '../../../constants.dart';
import 'components/addNewCustomer.dart';

class CustomerListScreen extends StatefulWidget {
  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Customer? selectedCustomer;

  bool isAddingNewCustomer = false;

  Future<List<Customer>> fetchCustomers(int companyId) async {
    return await ApiService().fetchCustomers(11); // Replace with the actual company ID
  }

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
        ? CustomerDetailScreen(customer: selectedCustomer!)
        : AddNewCustomerScreen();

    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(child: SideMenu()),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                primary: false,
                padding: EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    Header(scaffoldKey: _scaffoldKey),
                    SizedBox(height: defaultPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Customer List",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(width: defaultPadding),
                        ElevatedButton(
                            onPressed: () {
                              // Navigate to the AddNewProductScreen when the button is pressed
                              if (Responsive.isMobile(context)) {
                                // If it's a mobile layout, push a new screen on the navigation stack
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AddNewCustomerScreen()),
                                );
                              } else {
                                // For desktop layout, update the state to show the AddNewProductScreen
                                onAddCustomer(); // This will call your existing function to change the state
                              }
                            },
                          child: Text("Add Customer"),
                        ),
                      ],
                    ),
                    SizedBox(height: defaultPadding),
                    // ...

                    FutureBuilder<List<Customer>>(
                      future: fetchCustomers(11), // Replace 11 with the actual company ID
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          return CustomerListView(customers: snapshot.data!, onCustomerSelected: onCustomerSelected);
                        } else {
                          return Text('No customers found');
                        }
                      },
                    ),

// ...

                  ],
                ),
              ),
            ),
            if (!Responsive.isMobile(context))
              SizedBox(width: defaultPadding),
            if (!Responsive.isMobile(context))
              Expanded(
                flex: 2,
                child: isAddingNewCustomer
                    ? AddNewCustomerScreen()
                    : (selectedCustomer != null ? CustomerDetailScreen(customer: selectedCustomer!) : Container()),
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

  CustomerListView({Key? key, required this.customers, required this.onCustomerSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final Customer customer = customers[index];
        return Card(
          child: ListTile(
            title: Text(customer.name ?? 'N/A'),
            subtitle: Text(customer.email ?? 'N/A'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              if (Responsive.isMobile(context)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerDetailScreen(key: ValueKey(customer.id), customer: customer)),
                );
              } else {
                onCustomerSelected(customer);
              }
            },
          ),
        );
      },
    );
  }
}

