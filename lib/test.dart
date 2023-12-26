class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Map<String, dynamic>> productDetailFuture;

  @override
  void initState() {
    super.initState();
    productDetailFuture = ApiService().fetchProductDetail(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    // ... existing code ...

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        // ... existing AppBar, Image, and other widgets ...

        Expanded(
          child: TabBarView(
            children: [
              Center(child: Text('Overview Content')),
              FutureBuilder<Map<String, dynamic>>(
                future: productDetailFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    var productDetail = snapshot.data!;
                    // Calculate low stock threshold percentage
                    var lowStockThresholdPercentage = (productDetail['low_stock_threshold'] / productDetail['opening_stock']) * 100;
                    return Column(
                      children: [
                        ListTile(
                          title: Text('Opening Stock'),
                          trailing: Text('${productDetail['opening_stock']}'),
                        ),
                        ListTile(
                          title: Text('Low Stock Threshold (%)'),
                          trailing: Text('${lowStockThresholdPercentage.toStringAsFixed(2)}%'),
                        ),
                        ListTile(
                          title: Text('Current Stock'),
                          trailing: Text('${productDetail['current_stock']}'),
                        ),
                        // Add more information as needed
                      ],
                    );
                  } else {
                    return Center(child: Text('No data available'));
                  }
                },
              ),
              Center(child: Text('Sale Content')),
              Center(child: Text('Purchase Content')),
              Center(child: Text('Analytics Content')),
              Center(child: Text('Reports Content')),
              // ... add more tab views as needed ...
            ],
          ),
        ),
      ),
    );
  }
}
