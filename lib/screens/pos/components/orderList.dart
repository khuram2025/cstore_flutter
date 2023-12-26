import 'package:cstore_flutter/API/api_service.dart';
import 'package:cstore_flutter/models/customers.dart';
import 'package:cstore_flutter/screens/pos/pos.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  final List<OrderItem> selectedItems;
  final Function(OrderItem) onItemQuantityChanged;

  OrderScreen({
    Key? key,
    required this.selectedItems,
    required this.onItemQuantityChanged,
  }) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  void _onItemQuantityChanged(OrderItem updatedItem) {
    setState(() {
      int index = widget.selectedItems.indexWhere((item) => item.product.id == updatedItem.product.id);
      if (index != -1) {
        widget.selectedItems[index] = updatedItem; // Update the item
      }
    });
  }
  void _handleQuantityChange(int index, int newQuantity) {
    setState(() {
      widget.selectedItems[index].quantity = newQuantity;
    });
  }
  String customerName = 'Walk In Customer';
  String customerPhoneNumber = ''; // Add this line
  Future<void> _submitOrder() async {
    var orderData = _prepareOrderData();
    try {
      var response = await ApiService().submitOrderData(11, orderData);
      // Handle the response here
    } catch (e) {
      // Handle any errors here
    }
  }

  double _calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var item in widget.selectedItems) {
      totalPrice += double.parse(item.product.salePrice) * item.quantity;
    }
    return totalPrice;
  }

  Map<String, dynamic> _prepareOrderData() {
    List<Map<String, dynamic>> items = widget.selectedItems.map((item) {
      return {
        'product_id': item.product.id,
        'quantity': item.quantity,
        // Add other product details if needed
      };
    }).toList();

    return {
      'customer_id': selectedCustomer?.id, // Include the selected customer's ID
      'items': items,
      'total_price': _calculateTotalPrice().toString(), // Include the total price
    };
  }



  Widget _buildCustomerInfoContainer() {
    return InkWell(
      onTap: () {
        // TODO: Navigate to another screen to change customer info
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/user_icon.png'), // Placeholder for user icon
            ),
            SizedBox(width: 10),
            Text(
              customerName,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Customer? selectedCustomer; // Selected customer
  List<Customer> customers = []; // List of customers

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    try {
      var response = await ApiService().fetchCustomers(11); // Assuming this returns List<Customer>
      setState(() {
        customers = response;
        selectedCustomer = customers.firstWhere((cust) => cust.name == 'Walk In Customer', orElse: () => customers.first);
        _updateCustomerInfo(selectedCustomer);
      });
    } catch (e) {
      // Handle errors
    }
  }
  void _updateCustomerInfo(Customer? customer) {
    setState(() {
      customerName = customer?.name ?? 'Walk In Customer';
      customerPhoneNumber = customer?.mobile ?? '000'; // Assuming Customer model has phoneNumber
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [
            DropdownButton<Customer>(
              value: selectedCustomer,
              onChanged: (Customer? newValue) {
                _updateCustomerInfo(newValue); // Update customer info when a new customer is selected
                setState(() {
                  selectedCustomer = newValue;
                });
              },
              items: customers.map<DropdownMenuItem<Customer>>((Customer customer) {
                return DropdownMenuItem<Customer>(
                  value: customer,
                  child: Text(customer.name ?? 'N/A'),
                );
              }).toList(),
            ),
            Text("Order Summary"),
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedItems.length,
                itemBuilder: (context, index) {
                  final item = widget.selectedItems[index];
                  return ProductOrderItem(
                    product: item.product,
                    productName: item.product.name,
                    productPrice: '${item.product.salePrice} EGP',
                    productImage: item.product.imageUrl,
                    quantity: item.quantity,
                    onQuantityChange: (newQuantity) => _handleQuantityChange(index, newQuantity),
                    onRemove: () => _removeItemFromOrder(context, index),
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
                      onPressed: _submitOrder,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removeItemFromOrder(BuildContext context, int index) {
    // You may want to show a confirmation dialog before removing
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove Item"),
          content: Text("Do you want to remove this item from the order?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Remove"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog first
                setState(() {
                  widget.selectedItems.removeAt(index); // Correct usage of setState
                });
              },
            ),
          ],
        );
      },
    );
  }
}
class ProductOrderItem extends StatelessWidget {
  final Product product;
  final String productName;
  final String productPrice;
  final String productImage;
  int quantity;
  final void Function(int) onQuantityChange;
  final void Function() onRemove;

  ProductOrderItem({
    Key? key,
    required this.product,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.quantity,
    required this.onQuantityChange,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(productImage, width: 50, height: 50),
      title: Text(productName),
      subtitle: Text(productPrice),
      trailing: Wrap(
        spacing: 12, // space between two icons
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: quantity > 1 ? () {
              onQuantityChange(quantity - 1); // Pass the updated quantity
            } : null,
          ),
          Text(quantity.toString()),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              onQuantityChange(quantity + 1); // Pass the updated quantity
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onRemove, // Call the onRemove function when this button is pressed
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
