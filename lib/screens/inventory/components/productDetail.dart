import 'package:cstore_flutter/API/api_service.dart';
import 'package:cstore_flutter/screens/inventory/product_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Ensure you have added flutter_svg in your pubspec.yaml

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final int productId;


  const ProductDetailScreen({Key? key, required this.product, required this.productId})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Map<String, dynamic>> productDetailFuture;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    productDetailFuture = ApiService().fetchProductDetail(widget.productId);
    selectedIndex = 0; // Reset to the first tab ('Overview')
    _updateProductDetails();
  }


  void _updateProductDetails() {
    productDetailFuture = ApiService().fetchProductDetail(widget.productId);
    // Any other setup for new product
  }

  @override
  void didUpdateWidget(ProductDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.productId != oldWidget.productId) {
      _updateProductDetails();
    }
  }


  @override
  Widget build(BuildContext context) {
    // Dummy data for icons, replace with your actual assets
    final String emailIcon = 'assets/icons/email.svg';
    final String smsIcon = 'assets/icons/sms.svg';
    final String callIcon = 'assets/icons/call.svg';
    final String houseImagePath =
        widget.product.imageUrl; // Use your Product's image path

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Property Information'),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // TODO: Implement edit functionality
              },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,


          children: [
            Image.network(
              houseImagePath,
              width: MediaQuery.of(context).size.width,
              height: 250,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              widget.product.name,
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              widget.product.description,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ActionButton(icon: emailIcon, label: 'EMAIL', onTap: () {}),
                ActionButton(icon: smsIcon, label: 'SMS', onTap: () {}),
                ActionButton(icon: callIcon, label: 'CALL', onTap: () {}),
              ],
            ),
            Divider(),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Align(
                alignment: Alignment.centerLeft, // Align TabBar to the left
                child: TabBar(
                  isScrollable: true,
                  // Enable horizontal scrolling
                  indicatorColor: Colors.green,
                  // Color for the indicator
                  indicatorSize: TabBarIndicatorSize.tab,
                  // Indicator size as per tab
                  labelPadding: EdgeInsets.symmetric(horizontal: 12.0),
                  // Reduce left and right padding of each tab
                  tabs: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.zero,
                      child: Tab(
                        icon: Icon(Icons.visibility, size: 16),
                        // Example icon, replace with your own icon
                        text: 'Overview',
                      ),
                    ),
                    Tab(
                      icon: Icon(Icons.storage, size: 16),
                      // Example icon, replace with your own icon
                      text: 'Stock Status',
                    ),
                    Tab(
                      icon: Icon(Icons.attach_money, size: 16),
                      // Example icon, replace with your own icon
                      text: 'Sale',
                    ),
                    Tab(
                      icon: Icon(Icons.shopping_cart, size: 16),
                      // Example icon, replace with your own icon
                      text: 'Purchase',
                    ),
                    Tab(
                      icon: Icon(Icons.analytics, size: 16),
                      // Example icon, replace with your own icon
                      text: 'Analytics',
                    ),
                    Tab(
                      icon: Icon(Icons.report, size: 16),
                      // Example icon, replace with your own icon
                      text: 'Reports',
                    ),
                    // ... add more tabs as needed ...
                  ],
                ),
              ),
            ),

            // Expanded widget to take the remaining space for TabBarView
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
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: SvgPicture.asset(icon),
      label: Text(label),
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        primary: Colors.green,
        onPrimary: Colors.white,
      ),
    );
  }
}
