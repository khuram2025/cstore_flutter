class _POSScreenState extends State<POSScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isOrderScreenVisible = false;

  void toggleOrderScreen() {
    setState(() {
      isOrderScreenVisible = !isOrderScreenVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 850;
    bool shouldShowFloatingButton = isMobile && !isOrderScreenVisible;

    return Scaffold(
      key: _scaffoldKey,
      // Rest of your scaffold properties...
      floatingActionButton: shouldShowFloatingButton
          ? FloatingActionButton.extended(
        onPressed: toggleOrderScreen,
        label: Text('Proceed with order 3 Items \$5000'),
        icon: Icon(Icons.shopping_cart),
      )
          : null,
      bottomNavigationBar: shouldShowFloatingButton
          ? BottomAppBar(
        // BottomAppBar properties...
      )
          : null,
      body: isOrderScreenVisible || !isMobile
          ? OrderScreen() // Show OrderScreen when isOrderScreenVisible is true or on non-mobile screens
          : SafeArea(
        // Your SafeArea widget and its children...
      ),
    );
  }
}

class OrderScreen extends StatelessWidget {
  // Your OrderScreen implementation...

  @override
  Widget build(BuildContext context) {
    // Build your order screen UI here
    return Scaffold(
      // The rest of your order screen content...
    );
  }
}
