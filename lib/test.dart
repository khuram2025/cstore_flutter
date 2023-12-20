class _POSScreenState extends State<POSScreen> {
  List<Product> products = [];
  List<Category> categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPOSData();
  }

  void _loadPOSData() async {
    try {
      var storeId = 1; // Replace with the actual store ID
      var posData = await ApiService().fetchPOSData(storeId);
      // Process posData to populate products and categories
      setState(() {
        products = posData['products'].map<Product>((json) => Product.fromJson(json)).toList();
        categories = posData['categories'].map<Category>((name) => Category(name)).toList();
        _isLoading = false;
      });
    } catch (e) {
      // Handle errors
      print('Error fetching POS data: $e');
      setState(() => _isLoading = false);
    }
  }
// ... Rest of your code ...
}
