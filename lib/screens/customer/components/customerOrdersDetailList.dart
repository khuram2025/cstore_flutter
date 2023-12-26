import 'package:cstore_flutter/API/api_service.dart';
import 'package:flutter/material.dart';

class CustomerOrdersDetailList extends StatefulWidget {
  final int customerId;

  const CustomerOrdersDetailList({Key? key, required this.customerId}) : super(key: key);

  @override
  _CustomerOrdersDetailListState createState() => _CustomerOrdersDetailListState();
}

class _CustomerOrdersDetailListState extends State<CustomerOrdersDetailList> {
  int _sortColumnIndex = 0;
  bool _isAscending = true;
  late Future<List<Order>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = ApiService().fetchOrdersForCustomer(widget.customerId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: _ordersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          print('Error fetching orders: ${snapshot.error}');
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              sortColumnIndex: _sortColumnIndex,
              columnSpacing: 10.0,
              sortAscending: _isAscending,
              columns: [
                DataColumn(label: Text('Image')),
                DataColumn(label: Text('Name')),
                DataColumn(
                  label: Text('Date'),
                  onSort: (columnIndex, ascending) => _sortByString(columnIndex, ascending, (o) => o.date),
                ),
                DataColumn(
                  label: Text('Transaction'),
                  onSort: (columnIndex, ascending) => _sortByString(columnIndex, ascending, (o) => o.transactionType),
                ),
                DataColumn(
                  label: Text('Total Amount'),
                  onSort: (columnIndex, ascending) => _sortByDouble(columnIndex, ascending, (o) => o.totalAmount),
                ),
              ],
              rows: _buildRows(snapshot.data!),
            ),
          );
        } else {
          return Text('No orders found');
        }
      },
    );
  }

  List<DataRow> _buildRows(List<Order> orders) {
    return orders.map<DataRow>((order) {
      return DataRow(
        cells: [
          DataCell(CircleAvatar(
            backgroundImage: NetworkImage(order.imageUrl ?? ''),
            radius: 25,
          )),
          DataCell(Text(order.customerName ?? '')),
          DataCell(Text(order.date ?? '')),
          DataCell(Text(order.transactionType ?? '')),
          DataCell(Text('\$${order.totalAmount.toString()}')),
        ],
      );
    }).toList();
  }

  void _sortByString(int columnIndex, bool ascending, String Function(Order) getField) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _isAscending = ascending;
      if (_isAscending) {
        _ordersFuture.then((orders) => orders.sort((a, b) => getField(a ?? '').compareTo(getField(b ?? ''))));
      } else {
        _ordersFuture.then((orders) => orders.sort((a, b) => getField(b ?? '').compareTo(getField(a ?? ''))));
      }
    });
  }


  void _sortByDouble(int columnIndex, bool ascending, double Function(Order) getField) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _isAscending = ascending;
      if (_isAscending) {
        // Update this sorting logic as needed
      } else {
        // Update this sorting logic as needed
      }
    });
  }
}

class Order {
  final String? imageUrl;
  final String? customerName;
  final String? mobileNumber;
  final String? date;
  final String? transactionType;
  final double totalAmount;

  Order({
    this.imageUrl,
    this.customerName,
    this.mobileNumber,
    this.date,
    this.transactionType,
    required this.totalAmount,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      imageUrl: json['imageUrl'] as String? ?? 'default_image_url',
      customerName: json['customerName'] as String? ?? 'default_name',
      mobileNumber: json['mobileNumber'] as String? ?? 'default_mobile',
      date: json['date'] as String? ?? 'default_date',
      transactionType: json['transactionType'] as String? ?? 'default_transaction',
      totalAmount: double.parse(json['totalAmount'].toString()),
    );
  }

}

