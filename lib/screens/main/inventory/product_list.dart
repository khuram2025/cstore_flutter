import 'package:cstore_flutter/responsive.dart';
import 'package:cstore_flutter/screens/dashboard/components/header.dart';
import 'package:cstore_flutter/screens/main/components/side_menu.dart';

import 'package:flutter/material.dart';
import '../../../constants.dart';


class ProductListScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Product> products = [
    Product('RedBull', '15 EGP - 12 PC', 'assets/images/redbull.png'),
    Product('Shampoo', '45 EGP - 30 PC', 'assets/images/shampoo.png'),
    Product('Nestlé Water', '48 EGP - 40 PC', 'assets/images/water.png'),
    Product('Lays Chips', '50 EGP - 100 PC', 'assets/images/chips.png'),
    Product('Tea', '15 EGP - 12 PC', 'assets/images/tea.png'),
    Product('Rice', '10 EGP - 13 PC', 'assets/images/rice.png'),
    Product('Oreo Cookies', '15 EGP - 12 PC', 'assets/images/oreo.png'),
    Product('Toothpaste', '25 EGP - 15 PC', 'assets/images/toothpaste.png'),
    Product('Soda', '20 EGP - 24 PC', 'assets/images/soda.png'),
    Product('Chocolate Bar', '30 EGP - 20 PC', 'assets/images/chocolate.png'),
    // Add more products as needed
  ];

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
                    ProductListView(products: products), // Correctly placed within a Column
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
  final List<Product> products;

  ProductListView({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          child: ListTile(
            leading: Image.asset(
              product.imagePath,
              width: 50,
              height: 50,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error); // Fallback icon in case of an error
              },
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
