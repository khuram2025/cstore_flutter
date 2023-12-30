import 'package:cstore_flutter/API/api_service.dart';
import 'package:cstore_flutter/models/customers.dart';
import 'package:cstore_flutter/screens/pos/components/models.dart';
import 'package:cstore_flutter/screens/pos/components/order_actions_row.dart';
import 'package:cstore_flutter/screens/pos/components/product_tax_discount_row.dart';
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
  void onDiscountChanged(double discountValue, bool isPercentage) {
    // Logic to handle discount change
    // Update state or perform calculations as needed
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
  void _onAddDiscountTap() {
    // TODO: Implement functionality to add a discount
  }

  void handleDiscountChange(double discountValue, bool isPercentage) {
    // Implement your logic for discount change
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
                    taxOptions: ["Tax 1", "Tax 2", "Tax 3"],
                    onTaxSelected: (selectedTax) {
                      // Handle tax selection
                    },
                    onDiscountChanged: handleDiscountChange,
                    discountController: TextEditingController(),
                  );
                },
              ),
            ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),

            height: 50, // Set the height of the container
            decoration: BoxDecoration(
              color: Color(0xFFFFF3E8), // A lighter shade similar to Amber Sae for the background
              borderRadius: BorderRadius.circular(10), // Rounded corners

            ),
            child: OrderActionsRow(
              onAddTap: () {
                // TODO: Implement add action
              },
              onDiscountTap: _showAddDiscountDialog,
              onTaxTap: _showAddDiscountDialog, // Assuming you have a method for this
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
  void _showAddDiscountDialog() {
    String selectedDiscountType = '%'; // Default to percentage
    TextEditingController discountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder( // Use StatefulBuilder to update the state inside the dialog
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(16.0),
              content: Container(
                height: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Discount',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        // Dollar button
                        _buildDiscountTypeButton(setState, '\$', selectedDiscountType, discountController),
                        SizedBox(width: 8),
                        // Percentage button
                        _buildDiscountTypeButton(setState, '%', selectedDiscountType, discountController),
                        SizedBox(width: 8),
                        // Input field
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: discountController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 0), // Adjust field content padding
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: Color(0xFF9f9f9e)),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    // Cancel and Add buttons
                    _buildActionButtons(context),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDiscountTypeButton(StateSetter setState, String type, String selectedDiscountType, TextEditingController controller) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          selectedDiscountType = type;
          controller.clear(); // Clear the input when changing discount type
        }),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10), // Give some vertical padding
          decoration: BoxDecoration(
            color: selectedDiscountType == type ? Color(0xFFFC8019) : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: selectedDiscountType == type ? Colors.transparent : Color(0xFF9f9f9e)),
          ),
          child: Text(
            type,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selectedDiscountType == type ? Colors.white : Color(0xFF9f9f9e),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton('Cancel', Color(0xFFFC8019), () {
            Navigator.of(context).pop();
          }),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildActionButton('Add', Color(0xFF09aa29), () {
            // TODO: Implement add logic
            Navigator.of(context).pop();
          }),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: Colors.white)),
      style: TextButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }




}



class ProductOrderItem extends StatefulWidget {
  final Product product;
  final String productName;
  final String productPrice;
  final String productImage;
  int quantity;
  final void Function(int) onQuantityChange;
  final void Function() onRemove;

  final List<String> taxOptions;
  final void Function(String) onTaxSelected;
  final void Function(double, bool) onDiscountChanged;
  final TextEditingController discountController;

  ProductOrderItem({
    Key? key,
    required this.product,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.quantity,
    required this.onQuantityChange,
    required this.onRemove,
    required this.taxOptions,
    required this.onTaxSelected,
    required this.onDiscountChanged,
    required this.discountController,
  }) : super(key: key);

  @override
  _ProductOrderItemState createState() => _ProductOrderItemState();
}

class _ProductOrderItemState extends State<ProductOrderItem> {
  bool isExpanded = false; // Flag to control visibility of ProductTaxDiscountRow

  void _toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: _toggleExpansion, // Toggle expansion on tap
          leading: Image.network(widget.productImage, width: 50, height: 50),
          title: Text(widget.productName),
          subtitle: Text(widget.productPrice),
          trailing: Wrap(
            spacing: 12,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: widget.quantity > 1 ? () => widget.onQuantityChange(widget.quantity - 1) : null,
              ),
              Text(widget.quantity.toString()),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => widget.onQuantityChange(widget.quantity + 1),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: widget.onRemove,
              ),
            ],
          ),
        ),
        if (isExpanded) // Show ProductTaxDiscountRow only if isExpanded is true
          ProductTaxDiscountRow(
            taxOptions: widget.taxOptions,
            onTaxSelected: widget.onTaxSelected,
            onDiscountChanged: widget.onDiscountChanged,
            discountController: widget.discountController,
          ),
      ],
    );
  }
}





