class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  TransactionList({Key? key, required this.transactions}) : super(key: key);

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
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBalanceBox('In', '1200', Colors.green),
              _buildBalanceBox('Out', '800', Colors.red),
              _buildBalanceBox('Status', '400', Colors.blue),
            ],
          ),
        ),
        // Transaction List
        Expanded(
          child: ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              return TransactionItem(transaction: transactions[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceBox(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('\$$value', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
