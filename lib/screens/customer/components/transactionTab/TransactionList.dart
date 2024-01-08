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

  void _showAddPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Define variables for form fields
        final _amountController = TextEditingController();
        String _selectedTransactionType = 'in';
        String _notes = '';

        return AlertDialog(
          title: Text('Add Payment'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _amountController,
                  decoration: InputDecoration(hintText: "Amount"),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                DropdownButton<String>(
                  value: _selectedTransactionType,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedTransactionType = newValue!;
                    });
                  },
                  items: <String>['in', 'out']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                TextField(
                  decoration: InputDecoration(hintText: "Notes"),
                  onChanged: (value) {
                    _notes = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (_amountController.text.isNotEmpty) {
                  final double amount = double.tryParse(_amountController.text) ?? 0.0;
                  final manualTransaction = ManualTransaction(
                    customerId: widget.customerId,
                    amount: amount,
                    transactionType: _selectedTransactionType,
                    date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    notes: _notes,
                  );

                  ApiService().addManualTransaction(manualTransaction).then((_) {
                    // Close the dialog after successfully adding the transaction
                    Navigator.of(context).pop();

                    // Update the state to reflect new transaction
                    setState(() {
                      _ledgerEntriesFuture = ApiService().fetchLedger(widget.customerId);
                    });
                  }).catchError((error) {
                    // Handle the error here
                    print('Error adding manual transaction: $error');
                  });
                } else {
                  print('Amount field is empty');
                }
              },

            ),

          ],
        );
      },
    );
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
                onPressed: _showAddPaymentDialog,
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



class LedgerEntryItem extends StatelessWidget {
  final LedgerEntry ledgerEntry;

  LedgerEntryItem({Key? key, required this.ledgerEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconData = ledgerEntry.type == 'payment' ? Icons.arrow_downward : Icons.arrow_upward;
    Color iconColor = ledgerEntry.type == 'payment' ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon
            Icon(iconData, color: iconColor, size: 24),
            SizedBox(width: 12),

            // ID and Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text('ID: ${ledgerEntry.id}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                  Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(ledgerEntry.date))),
                ],
              ),
            ),

            // Amount
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('\$${ledgerEntry.amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: iconColor)),


              ],
            ),

            // Edit and Delete icons (Vertical Alignment)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    // TODO: Add your edit logic here
                  },
                  icon: Icon(Icons.edit, color: Colors.blue, size: 16),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Add your delete logic here
                  },
                  icon: Icon(Icons.delete, color: Colors.red, size: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



