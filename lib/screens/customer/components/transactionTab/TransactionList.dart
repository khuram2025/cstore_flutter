import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

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
  double totalInAmount = 0.0;
  double totalOutAmount = 0.0;


  @override
  void initState() {
    super.initState();
    fetchLedgerAndCalculateTotals(widget.customerId);
  }


  Future<void> fetchLedgerAndCalculateTotals(int customerId) async {
    try {
      // Assign the future to _ledgerEntriesFuture so it can be used by FutureBuilder
      _ledgerEntriesFuture = ApiService().fetchLedger(customerId);

      List<LedgerEntry> ledgerEntries = await ApiService().fetchLedger(customerId);

      // Initialize totals
      double inTotal = 0.0;
      double outTotal = 0.0;

      // Iterate over the ledger entries to calculate totals
      for (var entry in ledgerEntries) {
        if (entry.type == 'in' || entry.type == 'payment') {
          inTotal += entry.amount;
        } else if (entry.type == 'out' || entry.type == 'sale') {
          outTotal += entry.amount;
        }
      }

      // Update state with calculated totals
      setState(() {
        totalInAmount = inTotal;
        totalOutAmount = outTotal;
      });
    } catch (e) {
      // Handle errors
      print('Error fetching ledger entries: $e');
    }
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
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool _allChecked = true;
        bool _manualTransactionChecked = false;
        bool _ordersChecked = false;
        bool _allInOutChecked = true;
        bool _inChecked = false;
        bool _outChecked = false;
        TextEditingController _minPriceController = TextEditingController();
        TextEditingController _maxPriceController = TextEditingController();
        String _selectedDateFilter = 'This month';



        return AlertDialog(
          title: Text('Filter Transactions'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Transaction Type Checkboxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: Text('All'),
                        value: _allChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _allChecked = value!;
                            if (_allChecked) {
                              _manualTransactionChecked = false;
                              _ordersChecked = false;
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: Text('Manual'),
                        value: _manualTransactionChecked,
                        onChanged: _allChecked ? null : (bool? value) {
                          setState(() {
                            _manualTransactionChecked = value!;
                            _allChecked = false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: Text('Orders'),
                        value: _ordersChecked,
                        onChanged: _allChecked ? null : (bool? value) {
                          setState(() {
                            _ordersChecked = value!;
                            _allChecked = false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: Text('All'),
                        value: _allInOutChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _allInOutChecked = value!;
                            if (_allInOutChecked) {
                              _manualTransactionChecked = false;
                              _ordersChecked = false;
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: Text('In'),
                        value: _manualTransactionChecked,
                        onChanged: _allChecked ? null : (bool? value) {
                          setState(() {
                            _manualTransactionChecked = value!;
                            _allChecked = false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: Text('out'),
                        value: _ordersChecked,
                        onChanged: _allChecked ? null : (bool? value) {
                          setState(() {
                            _ordersChecked = value!;
                            _allChecked = false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ],
                ),
                // add send row here
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _minPriceController,
                        decoration: InputDecoration(hintText: "Min Price"),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _maxPriceController,
                        decoration: InputDecoration(hintText: "Max Price"),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),

                // Date Filter Dropdown
                DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedDateFilter,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDateFilter = newValue!;
                    });
                  },
                  items: <String>['This month', 'Last month', 'This year', 'Custom Range']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
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
              child: Text('Apply'),
              onPressed: () {
                // TODO: Apply filter logic here
                Navigator.of(context).pop();
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
                onPressed: _showFilterDialog,
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
              _buildBalanceBox(context, Icons.download, 'In', totalInAmount, Colors.green),
              _buildBalanceBox(context, Icons.upload, 'Out', totalOutAmount, Colors.red),
              _buildBalanceBox(context, Icons.account_balance_wallet, 'Balance', totalInAmount - totalOutAmount, Colors.blue),
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

  Widget _buildBalanceBox(BuildContext context, IconData icon, String label, double value, Color backgroundColor) {
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
              Text('\$${value.toStringAsFixed(2)}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ],
      ),
    );
  }

}

class LedgerEntryItem extends StatefulWidget {
  final LedgerEntry ledgerEntry;

  LedgerEntryItem({Key? key, required this.ledgerEntry}) : super(key: key);

  @override
  State<LedgerEntryItem> createState() => _LedgerEntryItemState();
}

class _LedgerEntryItemState extends State<LedgerEntryItem> {
  @override
  Widget build(BuildContext context) {
    IconData iconData = widget.ledgerEntry.type == 'payment' ? Icons.arrow_downward : Icons.arrow_upward;
    Color iconColor = widget.ledgerEntry.type == 'payment' ? Colors.green : Colors.red;

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
                  Text('ID: ${widget.ledgerEntry.id}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                  Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.ledgerEntry.date))),
                ],
              ),
            ),

            // Amount
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('\$${widget.ledgerEntry.amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: iconColor)),


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



