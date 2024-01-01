import 'package:flutter/material.dart';
import 'package:cstore_flutter/API/api_service.dart';

class CustomerOrdersDetailList extends StatefulWidget {
  final int customerId;

  const CustomerOrdersDetailList({Key? key, required this.customerId}) : super(key: key);

  @override
  _CustomerOrdersDetailListState createState() => _CustomerOrdersDetailListState();
}

class _CustomerOrdersDetailListState extends State<CustomerOrdersDetailList> {
  // ... [Rest of your existing code]

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: _ordersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          // Wrapping DataTable with SingleChildScrollView for vertical scrolling
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                sortColumnIndex: _sortColumnIndex,
                columnSpacing: 10.0,
                sortAscending: _isAscending,
                columns: [
                  // Your DataColumn definitions
                ],
                rows: _buildRows(snapshot.data!),
              ),
            ),
          );
        } else {
          return Text('No orders found');
        }
      },
    );
  }

// ... [Rest of your existing code]
}
