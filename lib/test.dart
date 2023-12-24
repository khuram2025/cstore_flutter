import 'package:flutter/material.dart';
// ... other imports ...

class CustomerListScreen extends StatefulWidget {
  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Customer? selectedCustomer;
  bool isAddingNewCustomer = false;

  Future<List<Customer>> fetchCustomers() async {
    // Implement the function to fetch customers from your API
    // Example:
    // return await fetchCustomersApi();
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
            // ... other code ...
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                primary: false,
                padding: EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    Header(scaffoldKey: _scaffoldKey),
                    SizedBox(height: defaultPadding),
                    // ... other code ...
                    FutureBuilder<List<Customer>>(
                      future: fetchCustomers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if (snapshot.hasData) {
                          return CustomerListView(
                            customers: snapshot.data!,
                            onCustomerSelected: onCustomerSelected,
                          );
                        } else {
                          return Text("No customers found");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            // ... other code ...
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
            title: Text(customer.name),
            subtitle: Text(customer.email),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              onCustomerSelected(customer);
            },
          ),
        );
      },
    );
  }
}
