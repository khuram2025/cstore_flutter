import 'package:cstore_flutter/screens/pos/pos.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  final List<OrderItem> selectedItems;
  final Function(OrderItem) onItemQuantityChanged;

  OrderScreen({
    Key? key,
    required this.selectedItems,
    required this.onItemQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: selectedItems.length,
              itemBuilder: (context, index) {
                final item = selectedItems[index];
                return ProductOrderItem(
                  productName: item.product.name,
                  productPrice: '${item.product.salePrice} EGP',
                  productImage: item.product.imageUrl,
                  quantity: item.quantity,
                  onQuantityChanged: () {
                    // Call the onItemQuantityChanged with the updated item
                    onItemQuantityChanged(item);
                  },
                );
              },

            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal'),
                    Text('215 EGP'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tax (14%)'),
                    Text('30 EGP'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total'),
                    Text('245 EGP', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity, // make button full width
                  child: ElevatedButton(
                    child: Text('Checkout'),
                    onPressed: () {
                      // TODO: Implement checkout logic
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class ProductOrderItem extends StatelessWidget {
  final String productName;
  final String productPrice;
  final String productImage;
  int quantity;
  final Function onQuantityChanged;

  ProductOrderItem({
    Key? key,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.quantity,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(productImage, width: 50, height: 50),
      title: Text(productName),
      subtitle: Text(productPrice),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              if (quantity > 1) {
                quantity--;
                onQuantityChanged();
              }
            },
          ),
          Text(quantity.toString()),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              quantity++;
              onQuantityChanged();
            },
          ),
        ],
      ),
    );
  }
}


class OrderItem {
  final Product product;
  int quantity;

  OrderItem({required this.product, this.quantity = 1});

  // Calculate the total price for this item
  double get totalPrice => double.parse(product.salePrice) * quantity;
}
