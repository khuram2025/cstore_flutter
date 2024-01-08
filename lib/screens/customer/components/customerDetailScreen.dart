import 'package:cstore_flutter/models/customers.dart';
import 'package:cstore_flutter/screens/customer/components/customerOrdersDetailList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Ensure you have added flutter_svg in your pubspec.yaml

class CustomerDetailScreen extends StatefulWidget {
  final Customer customer;

  const CustomerDetailScreen({Key? key, required this.customer})
      : super(key: key);

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didUpdateWidget(CustomerDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.customer.id != oldWidget.customer.id) {
      // Reset the tab index to 0 when a new customer is selected
      _tabController.animateTo(0);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // Dummy data for icons, replace with your actual assets
    final String emailIcon = 'assets/icons/email.svg';
    final String smsIcon = 'assets/icons/sms.svg';
    final String callIcon = 'assets/icons/call.svg';
    final String customerLevelIcon = 'assets/icons/star.svg'; // Example icon for customer level

    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Customer Information'),
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
            SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: widget.customer.imagePath != null
                      ? NetworkImage(widget.customer.imagePath!) as ImageProvider<Object>
                      : AssetImage('path/to/default/image.jpg') as ImageProvider<Object>,
                  radius: 50,
                ),


                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.customer.name ?? 'N/A',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(customerLevelIcon, width: 20, height: 20),
                        Text(' Level 1'),
                      ],
                    ),
                  ],
                ),
              ],
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
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: _tabController,
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
                      text: 'Orders',
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
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Customer Details Tab
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: SvgPicture.asset(emailIcon),
                          title: Text(widget.customer.email ?? 'N/A'),
                        ),
                        ListTile(
                          leading: SvgPicture.asset(callIcon),
                          title: Text(widget.customer.mobile ?? 'N/A'),
                        ),
                        ListTile(
                          leading: Icon(Icons.location_on),
                          title: Text(widget.customer.address ?? 'N/A'),
                        ),
                      ],
                    ),
                  ),
                  widget.customer.id != null
                      ? CustomerOrdersDetailList(customerId: widget.customer.id!)
                      : Center(child: Text('Customer ID is unavailable')),
                  // Customer Orders Tab


                  // Customer Activity Tab
                  Center(child: Text('Customer Activity Content')),
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

