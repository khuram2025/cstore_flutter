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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                sortColumnIndex: _sortColumnIndex,
                columnSpacing: 10.0,
                sortAscending: _isAscending,
                columns: [


                  DataColumn(
                    label: Text('Date'),
                    onSort: (columnIndex, ascending) => _sortByString(columnIndex, ascending, (o) => o.date ?? ''),
                  ),
                  DataColumn(
                    label: Text('Transaction'),
                    onSort: (columnIndex, ascending) => _sortByString(columnIndex, ascending, (o) => o.transactionType ?? ''),
                  ),
                  DataColumn(label: Text('Paid\$')),
                  DataColumn(label: Text('Credit\$')),
                  DataColumn(
                    label: Text('Total\$'),
                    onSort: (columnIndex, ascending) => _sortByDouble(columnIndex, ascending, (o) => o.totalAmount),
                  ),
                  DataColumn(label: Icon(Icons.receipt)),
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

  List<DataRow> _buildRows(List<Order> orders) {
    return orders.map((order) {
      return DataRow(
        cells: [
          DataCell(Text(order.date ?? '')),
          DataCell(Container(
            padding: EdgeInsets.all(8),
            color: _getTransactionTypeColor(order.transactionType),
            child: Text(
              order.transactionType ?? '',
              style: TextStyle(color: _getTextColor(order.transactionType)),
            ),
          )),
          DataCell(Text('\$${order.paidAmount.toStringAsFixed(2)}')), // Ensure proper string formatting
          DataCell(Text('\$${order.creditAmount.toStringAsFixed(2)}')), // Ensure proper string formatting
          DataCell(Text('\$${order.totalAmount.toStringAsFixed(2)}')), // Added missing Total Amount cell
          DataCell(IconButton(
            icon: Icon(Icons.receipt),
            onPressed: () {
              // TODO: Implement navigation to invoice details
            },
          )),
        ],
      );
    }).toList();
  }


  void _sortByString(int columnIndex, bool ascending, String Function(Order) getField) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _isAscending = ascending;
      if (_isAscending) {
        _ordersFuture.then((orders) => orders.sort((a, b) => getField(a).compareTo(getField(b))));
      } else {
        _ordersFuture.then((orders) => orders.sort((a, b) => getField(b).compareTo(getField(a))));
      }
    });
  }


  void _sortByDouble(int columnIndex, bool ascending, double Function(Order) getField) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _isAscending = ascending;
      _ordersFuture = _ordersFuture.then((orders) {
        if (_isAscending) {
          orders.sort((a, b) => getField(a).compareTo(getField(b)));
        } else {
          orders.sort((a, b) => getField(b).compareTo(getField(a)));
        }
        return orders; // return the sorted list
      });
    });
  }
  Color _getTransactionTypeColor(String? type) {
    switch (type) {
      case 'Partial':
        return Color(0xFFFC8019).withOpacity(0.1);
      case 'Cash':
        return Color(0xFF09AA29).withOpacity(0.1);
      case 'Credit':
        return Color(0xFF9F9F9E).withOpacity(0.1);
      default:
        return Colors.transparent;
    }
  }

  Color _getTextColor(String? type) {
    switch (type) {
      case 'Partial':
      case 'Cash':
      case 'Credit':
        return Colors.black;
      default:
        return Colors.grey;
    }
  }

}

class Order {
  final String? date;
  final String? transactionType;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final double creditAmount;

  Order({
    this.date,
    this.transactionType,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.creditAmount,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      date: json['date'] as String? ?? 'default_date',
      transactionType: json['transactionType'] as String? ?? 'default_transaction',
      totalAmount: _parseDouble(json['totalAmount']),
      paidAmount: _parseDouble(json['paidAmount']),
      remainingAmount: _parseDouble(json['remainingAmount']),
      creditAmount: _parseDouble(json['creditAmount']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) {
      return 0.0; // default value if null
    }
    try {
      return double.parse(value.toString());
    } catch (e) {
      return 0.0; // default value in case of parsing error
    }
  }
}


