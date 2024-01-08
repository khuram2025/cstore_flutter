import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../API/api_service.dart';
import '../../../../models/customers.dart';

class LedgerEntryList extends StatefulWidget {
  final int customerId;


  LedgerEntryList({Key? key, required this.customerId}) : super(key: key);

  @override
  State<LedgerEntryList> createState() => _LedgerEntryListState();
}

class _LedgerEntryListState extends State<LedgerEntryList> {
  late Future<List<LedgerEntry>> _ledgerEntriesFuture;

  @override
  void initState() {
    super.initState();
    _ledgerEntriesFuture = ApiService().fetchLedger(widget.customerId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Add your payment button logic here
                },
                icon: Icon(Icons.add),
                label: Text('Add Payment'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Add your filter button logic here
                },
                icon: Icon(Icons.filter_list),
                label: Text('Filter'),
              ),
            ],
          ),
        ),
        // Balance Boxes
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBalanceBox(context, Icons.download, 'In', '1200', Colors.green),
              SizedBox(width: 5), // This adds space between the boxes
              _buildBalanceBox(context, Icons.upload, 'Out', '800', Colors.red),
              SizedBox(width: 5), // This adds space between the boxes
              _buildBalanceBox(context, Icons.account_balance_wallet, 'Status', '400', Colors.blue),
            ],
          ),
        ),
        // Transaction List
        Expanded(
          child: FutureBuilder<List<LedgerEntry>>(
            future: _ledgerEntriesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final ledgerEntry = snapshot.data![index];
                    return LedgerEntryItem(ledgerEntry: ledgerEntry);
                  },
                );
              } else {
                return Text('No ledger entries found');
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceBox(BuildContext context, IconData icon, String label, String value, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: 125,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 5),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
              Text('\$$value', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ],
      ),
    );
  }
}



class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  TransactionItem({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Adjusted padding for more space
        child: IntrinsicHeight( // Use IntrinsicHeight to align columns
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Icon and In/Out text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    transaction.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                    color: transaction.isIncome ? Colors.green : Colors.red,
                    size: 24, // Increased icon size
                  ),
                  SizedBox(height: 4),
                  Text(
                    transaction.isIncome ? 'In' : 'Out',
                    style: TextStyle(
                      color: transaction.isIncome ? Colors.green : Colors.red, // Match icon color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(width: 12), // Space between the icon and the description
              // Description, Date and Amount
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      transaction.description,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20, // Increased font size for amount
                        color: transaction.isIncome ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(DateFormat('yyyy-MM-dd – kk:mm').format(transaction.date)),
                  ],
                ),
              ),
              // Edit and Delete icons
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      // TODO: Add your edit logic here
                    },
                    icon: Icon(Icons.edit, color: Colors.blue, size: 24), // Increased icon size
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Add your delete logic here
                    },
                    icon: Icon(Icons.delete, color: Colors.red, size: 24), // Increased icon size
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LedgerEntryItem extends StatelessWidget {
  final LedgerEntry ledgerEntry;

  LedgerEntryItem({Key? key, required this.ledgerEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine if the entry is income or expense
    bool isIncome = ledgerEntry.type == 'payment';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Icon and In/Out text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isIncome ? Colors.green : Colors.red,
                    size: 24,
                  ),
                  SizedBox(height: 4),
                  Text(
                    isIncome ? 'In' : 'Out',
                    style: TextStyle(
                      color: isIncome ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12),
              // Description, Date, and Amount
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID: ${ledgerEntry.id}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${ledgerEntry.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        color: isIncome ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(ledgerEntry.date))),
                  ],
                ),
              ),
              // Optionally add Edit and Delete icons if needed
              //...
            ],
          ),
        ),
      ),
    );
  }
}
