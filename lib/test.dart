class _POSScreenState extends State<POSScreen> {
  // ...

  // All products fetched initially.
  List<Product> allProducts = [];

  // ...

  @override
  void initState() {
    super.initState();
    _loadPOSData();
  }

  void _loadPOSData() async {
    // ...
    // When data is fetched successfully
    setState(() {
      allProducts = productData.map((json) => Product.fromJson(json)).toList();
      // Initially, display all products
      products = List.from(allProducts); // Make a copy of the list.
      // ...
    });
  }

  void _filterProducts(String categoryName) {
    setState(() {
      activeCategory = categoryName;
      if (categoryName != 'All Categories') {
        // Apply filter on the allProducts to get the filtered list
        products = allProducts.where((product) => product.category == categoryName).toList();
      } else {
        // Reset to the full products list if "All Categories" is selected
        products = List.from(allProducts);
      }
    });
  }

  // ...

  @override
  Widget build(BuildContext context) {
    // ...
    return Scaffold(
      // ...
      body: isOrderScreenVisible
          ? OrderScreen(
        // ...
      )
          : SafeArea(
        child: Row(
          // ...
          children: [
            // ...
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                // ...
                child: Column(
                  children: [
                    // ...
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _buildCategoryChips(),
                    ),
                    SizedBox(height: defaultPadding),
                    ProductListView(
                      products: products,
                      onProductClick: addToOrder,
                    ),
                    // ...
                  ],
                ),
              ),
            ),
            // ...
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildChoiceChip('All Categories', activeCategory == 'All Categories'),
        ...categories.map(
              (category) => _buildChoiceChip(category.name, activeCategory == category.name),
        ),
      ],
    );
  }

  Widget _buildChoiceChip(String categoryName, bool isSelected) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: ChoiceChip(
        label: Text(categoryName),
        selected: isSelected,
        onSelected: (selected) {
          _filterProducts(categoryName);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
