import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Assuming this is the structure of your Sale data
class Sale {
  final int orderId;
  final String customerName;
  final String customerMobile;
  final int quantitySold;
  final double sellingPrice;
  final double totalPrice;

  Sale({
    required this.orderId,
    required this.customerName,
    required this.customerMobile,
    required this.quantitySold,
    required this.sellingPrice,
    required this.totalPrice,
  });

  // Add a method to parse JSON data
  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      orderId: json['order_id'],
      customerName: json['customer_name'],
      customerMobile: json['customer_mobile'],
      quantitySold: json['quantity_sold'],
      sellingPrice: json['selling_price'],
      totalPrice: json['total_price'],
    );
  }
}

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final int productId;
  final List<Sale> sales; // Add this line

  const ProductDetailScreen({
    Key? key,
    required this.product,
    required this.productId,
    required this.sales, // Add this line
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this); // Adjusted length
  }

  @override
  Widget build(BuildContext context) {
    // ... existing code ...

    // Replace one of the TabBarView children with ProductSalesList
    return TabBarView(
      controller: _tabController,
      children: [
        // ... other tabs ...
        ProductSalesList(sales: widget.sales), // Add this line for the "Sale" tab
        // ... other tabs ...
      ],
    );
  }
}

// This widget will display the list of sales
class ProductSalesList extends StatelessWidget {
  final List<Sale> sales;

  const ProductSalesList({Key? key, required this.sales}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sales.length,
      itemBuilder: (context, index) {
        final sale = sales[index];
        return ListTile(
          title: Text('Order ID: ${sale.orderId}'),
          subtitle: Text('Customer: ${sale.customerName} (${sale.customerMobile})'),
          trailing: Text('Total: \$${sale.totalPrice.toStringAsFixed(2)}'),
        );
      },
    );
  }
}


// ... existing code ...

Expanded(
child: TabBarView(
children: [
Center(child: Text('Overview Content')),
// ... other tabs ...

// Sale Tab
FutureBuilder<Map<String, dynamic>>(
future: productDetailFuture,
builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.waiting) {
return Center(child: CircularProgressIndicator());
} else if (snapshot.hasError) {
return Center(child: Text('Error: ${snapshot.error}'));
} else if (snapshot.hasData) {
var productDetail = snapshot.data!;
var sales = productDetail['sales'] as List<dynamic>; // Cast to List

return ListView.builder(
itemCount: sales.length,
itemBuilder: (context, index) {
var sale = sales[index];
return ListTile(
title: Text('Order ID: ${sale['order_id']}'),
subtitle: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text('Customer Name: ${sale['customer_name']}'),
Text('Mobile: ${sale['customer_mobile']}'),
Text('Quantity Sold: ${sale['quantity_sold']}'),
Text('Selling Price: ${sale['selling_price']}'),
Text('Total Price: ${sale['total_price']}'),
],
),
);
},
);
} else {
return Center(child: Text('No sales data available'));
}
},
),

// ... other tabs ...
],
),
),

// ... existing code ...
