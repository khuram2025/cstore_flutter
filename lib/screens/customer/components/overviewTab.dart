import 'package:flutter/material.dart';

import '../../../models/customers.dart';
import '../../../ui.dart';


class CustomerOverviewTab extends StatelessWidget {
  final Customer customer;

  CustomerOverviewTab({Key? key, required this.customer}) : super(key: key);

  void _onEditTap(BuildContext context, String field) {
    // TODO: Implement edit functionality
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit $field'),
        content: Text('Implement editing functionality for $field'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoTile('Customer Since', customer.customerSince ?? 'N/A', context),
          _buildInfoTile('Opening Balance', '\$${customer.openingBalance?.toStringAsFixed(2)}', context, editable: true),
          _buildInfoTile('Remaining Balance', '\$${customer.remainingBalance?.toStringAsFixed(2)}', context),
          _buildInfoTile('Customer Level', customer.customerLevel ?? 'N/A', context),
          _buildInfoTile('Mobile Number', customer.mobile ?? 'N/A', context, editable: true),
          _buildInfoTile('Email', customer.email ?? 'N/A', context, editable: true),
          _buildInfoTile('Address', customer.address ?? 'N/A', context, editable: true),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, BuildContext context, {bool editable = false}) {
    return ListTile(
      title: Text(title, style: TextStyle(color: AppColors.typeDarkColor, fontWeight: FontWeight.bold)),
      subtitle: Text(value, style: TextStyle(color: AppColors.typeDarkColor)),
      trailing: editable
          ? IconButton(
        icon: Icon(Icons.edit, color: AppColors.accentColor),
        onPressed: () => _onEditTap(context, title),
      )
          : null,
      tileColor: AppColors.highlightColor,
    );
  }
}
