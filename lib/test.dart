class ProductListScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                primary: false,
                padding: EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    Header(scaffoldKey: _scaffoldKey),
                    SizedBox(height: defaultPadding),
                    Text(
                      "Product List",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: defaultPadding),
                    ProductListView(), // Correctly placed within a Column
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Product> products = [
      // ... product list ...
    ];

    return ListView.builder(
      shrinkWrap: true, // Add shrinkWrap
      physics: NeverScrollableScrollPhysics(), // Add this to keep the ListView from scrolling
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          child: ListTile(
            leading: Image.asset(
              product.imagePath,
              width: 50,
              height: 50,
            ),
            title: Text(product.name),
            subtitle: Text(product.details),
            trailing: Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }
}

class Product {
  final String name;
  final String details;
  final String imagePath;

  Product(this.name, this.details, this.imagePath);
}
