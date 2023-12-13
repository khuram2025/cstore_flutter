class _CustomerListScreenState extends State<CustomerListScreen> {
  // ... existing code ...

  @override
  Widget build(BuildContext context) {
    // ... existing Scaffold and Row code ...

    Expanded(
      flex: 3,
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(scaffoldKey: _scaffoldKey),
            // ... other widgets ...

            // Wrap CustomerListView in Expanded
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

    // ... remaining parts of the Row ...
  }
}
