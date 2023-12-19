import 'package:cstore_flutter/responsive.dart';
import 'package:cstore_flutter/screens/dashboard/components/header.dart';
import 'package:cstore_flutter/screens/dashboard/components/storage_details.dart';
import 'package:cstore_flutter/screens/inventory/components/AddNewProduct.dart';
import 'package:cstore_flutter/screens/inventory/components/productDetail.dart';
import 'package:cstore_flutter/screens/main/components/side_menu.dart';

import 'package:flutter/material.dart';
import '../../../constants.dart';


class ProductListScreen extends StatefulWidget {
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  Product? selectedProduct; // The selected product for detail view
  bool isAddingNewProduct = false; // To determine if we are adding a new product




  final List<Product> products = [
    Product(
      name: 'RedBull',
      barcode: '1234567890123',
      quantity: '50',
      category: 'Beverages',
      salePrice: '15 EGP',
      purchasePrice: '12 EGP',
      description: 'Energy Drink',
      expirationDate: '2023-12-31',
      imagePath: 'assets/images/redbull.png',
    ),
    // Add more dummy Product instances as needed
    // ...
  ];

  final List<Category> categories = [
    Category('Beverages'),
    Category('Candy'),
    Category('Packaged Food'),
    Category('Home'),
  ];
  void onProductSelected(Product product) {
    setState(() {
      selectedProduct = product;
      isAddingNewProduct = false;
    });
  }

  void onAddProduct() {
    setState(() {
      selectedProduct = null;
      isAddingNewProduct = true;
    });
  }


  bool isActiveCategory(Category category) {
  // Implement your logic to determine if a category is active
  // This is just an example, you can replace it with your actual logic
  return category.name == 'Beverages';
  }

  @override
  Widget build(BuildContext context) {
    Widget detailScreen = selectedProduct != null
        ? ProductDetailScreen(product: selectedProduct!) // selectedProduct must be the correct Product type
        : AddNewProductScreen();

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
              flex: 3,
              child: SingleChildScrollView(
                primary: false,
                padding: EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    Header(scaffoldKey: _scaffoldKey),
                    SizedBox(height: defaultPadding),

                    Row(
                      children: [
                        SizedBox(width: defaultPadding),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search Product',
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        SizedBox(width: defaultPadding),
                      ],
                    ),

                    SizedBox(height: defaultPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories:',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        ElevatedButton(
                          onPressed: () {
// TODO: Add your 'Add Category' logic here
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text('Add Category'),
                        ),
                      ],
                    ),
                    SizedBox(height: defaultPadding),

                    Row(
                      children: [



                        // Add Horizontal Scroll View
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                            child: Wrap(
                              spacing: 5.0, // Space between categories
                              children: [
                                // Loop through categories and create buttons
                                for (final category in categories)
                                  ElevatedButton(
                                    onPressed: () {}, // Add your category selection logic here
                                    style: ElevatedButton.styleFrom(

                                      onPrimary: isActiveCategory(category) ? Colors.blue : Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        side: BorderSide(color: Colors.grey[300]!),
                                      ),
                                    ),
                                    child: Text(category.name),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: defaultPadding),
                      ],
                    ),


                    SizedBox(height: defaultPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Product List",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(width: defaultPadding),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to the AddNewProductScreen when the button is pressed
                            if (Responsive.isMobile(context)) {
                              // If it's a mobile layout, push a new screen on the navigation stack
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddNewProductScreen()),
                              );
                            } else {
                              // For desktop layout, update the state to show the AddNewProductScreen
                              onAddProduct(); // This will call your existing function to change the state
                            }
                          },
                          child: Text("Add Product"),
                        ),



                      ],
                    ),
                    SizedBox(height: defaultPadding),

                    ProductListView(products: products, onProductSelected: onProductSelected,), // Correctly placed within a Column
                  ],
                ),
              ),
            ),
            if (!Responsive.isMobile(context))
              SizedBox(width: defaultPadding),
            // On Mobile means if the screen is less than 850 we don't want to show it
            if (!Responsive.isMobile(context))
            Expanded(
              flex: 2,

              child: isAddingNewProduct ? AddNewProductScreen() : (selectedProduct != null ? ProductDetailScreen(product: selectedProduct!) : Container()),
            )
          ],
        ),
      ),
    );
  }
}

class ProductListView extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onProductSelected;

  ProductListView({Key? key, required this.products, required this.onProductSelected,}) : super(key: key);

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
            subtitle: Text('product.details'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              if (Responsive.isMobile(context)) {
                // If in mobile view, push the ProductDetailScreen onto the navigation stack
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)),
                );
              } else {
                // For larger screens, use onProductSelected to update the state
                onProductSelected(product);
              }
            },
          ),
        );
      },
    );
  }
}

class Product {
  final String name;
  final String barcode;
  final String quantity;
  final String category;
  final String salePrice;
  final String purchasePrice;
  final String description;
  final String expirationDate;
  final String imagePath;

  Product({
    required this.name,
    required this.barcode,
    required this.quantity,
    required this.category,
    required this.salePrice,
    required this.purchasePrice,
    required this.description,
    required this.expirationDate,
    required this.imagePath,
  });
}



class Category {
  final String name;

  Category(this.name);
}