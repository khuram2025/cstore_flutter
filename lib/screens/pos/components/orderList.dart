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

  double discountValue = 0.0;
  bool isDiscountPercentage = true;

  double _calculateDiscount() {
    if (isDiscountPercentage) {
      return _calculateSubtotal() * (discountValue / 100);
    }
    return discountValue;
  }

  TaxOption? selectedTaxOption;
  double _calculateTax() {
    if (selectedTaxOption != null) {
      return _calculateSubtotal() * (selectedTaxOption!.rate / 100);
    }
    return 0.0;
  }

  double _calculateTotal() {
    double subtotal = _calculateSubtotal();
    double discount = _calculateDiscount();
    double tax = _calculateTax();
    return subtotal - discount + tax;

  }

  List<TaxOption> taxOptionsList = [];
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
      'subtotal': _calculateSubtotal().toStringAsFixed(2),
      'discount_value': discountValue.toStringAsFixed(2),
      'is_discount_percentage': isDiscountPercentage,
      'tax_ids': selectedTaxOption != null ? [selectedTaxOption!.id] : [],
      'total_price': _calculateTotal().toStringAsFixed(2) // Include the total price after discount and taxes
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
    _fetchTaxOptions();
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
  Future<void> _fetchTaxOptions() async {
    try {
      List<TaxOption> taxes = await ApiService().fetchTaxes(11);
      setState(() {
        taxOptionsList = taxes;
      });
    } catch (e) {
      // Handle errors
      print('Error fetching taxes: $e');
    }
  }





  void _updateCustomerInfo(Customer? customer) {
    setState(() {
      customerName = customer?.name ?? 'Walk In Customer';
      customerPhoneNumber = customer?.mobile ?? '000'; // Assuming Customer model has phoneNumber
    });
  }
  double _calculateSubtotal() {
    double subtotal = 0.0;
    for (var item in widget.selectedItems) {
      subtotal += double.parse(item.product.salePrice) * item.quantity;
    }
    return subtotal;
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
                    taxOptions: taxOptionsList,
                    onTaxSelected: (TaxOption selectedTax) {
                      // Handle tax selection with TaxOption object
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
                      Text('${_calculateSubtotal().toStringAsFixed(2)} EGP'),
                    ],
                  ),
                  if (discountValue > 0) // Display only if discount is applied
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Discount'),
                        SizedBox(width: 8), // Gap between label and discount value
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                isDiscountPercentage ? '$discountValue%' : '\$${discountValue.toStringAsFixed(2)}',
                                style: TextStyle(color: Colors.red),
                              ),
                              Spacer(), // Pushes the negative discount amount to the end
                              Text('-\$${_calculateDiscount().toStringAsFixed(2)}', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tax'),
                      SizedBox(width: 8), // Gap between label and dropdown
                      // Wrap the dropdown in a limited width Container
                      Container(
                        constraints: BoxConstraints(maxWidth: 150), // Set a maximum width for the dropdown
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<TaxOption>(
                            isDense: true, // Reduce the vertical size of the button
                            value: selectedTaxOption,
                            onChanged: (newValue) {
                              setState(() {
                                selectedTaxOption = newValue;
                              });
                            },
                            items: taxOptionsList.map((TaxOption tax) {
                              return DropdownMenuItem<TaxOption>(
                                value: tax,
                                child: Text(
                                  "${tax.name} (${tax.rate}%)",
                                  style: TextStyle(color: Color(0xFFFC8019)),
                                ),
                              );
                            }).toList(),
                            icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                          ),
                        ),
                      ),
                      Spacer(), // Pushes the tax value to the end
                      Text('${_calculateTax().toStringAsFixed(2)} EGP', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total'),
                      Text('${_calculateTotal().toStringAsFixed(2)} EGP', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
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
    // Default to percentage
    String selectedDiscountType = '%';
    TextEditingController discountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(16.0),
              content: Container(
                height: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add Discount', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        _buildDiscountTypeButton(setState, '\$', selectedDiscountType, discountController),
                        SizedBox(width: 8),
                        _buildDiscountTypeButton(setState, '%', selectedDiscountType, discountController),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: discountController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Color(0xFF9f9f9e))),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildActionButtons(context, setState, discountController, selectedDiscountType),
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
        }),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selectedDiscountType == type ? Color(0xFFFC8019) : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: selectedDiscountType == type ? Colors.transparent : Color(0xFF9f9f9e)),
          ),
          child: Text(
            type,
            textAlign: TextAlign.center,
            style: TextStyle(color: selectedDiscountType == type ? Colors.white : Color(0xFF9f9f9e)),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, StateSetter setState, TextEditingController discountController, String selectedDiscountType) {
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
            double enteredDiscount = double.tryParse(discountController.text) ?? 0.0;
            setState(() {
              discountValue = enteredDiscount;
              isDiscountPercentage = selectedDiscountType == '%';
            });
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
  final List<TaxOption> taxOptions;
  final void Function(TaxOption) onTaxSelected;
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





