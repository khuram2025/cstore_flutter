import 'dart:convert';
import 'package:cstore_flutter/models/customers.dart';
import 'package:cstore_flutter/screens/customer/components/customerOrdersDetailList.dart';
import 'package:cstore_flutter/screens/customer/customers_list.dart';
import 'package:cstore_flutter/screens/pos/components/models.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://app.channab.com/';

  Future<Map<String, dynamic>> login(String mobile, String password) async {
    print('Sending to API: Mobile: $mobile, Password: $password'); // Add this line

    final response = await http.post(
      Uri.parse(baseUrl + 'account/api/mobile-login/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'mobile': mobile,
        'password': password,
      }),
    );

    print('Response Status Code: ${response.statusCode}'); // Add this line
    print('Response Body: ${response.body}'); // Add this line

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login. Status code: ${response.statusCode}');
    }
  }


  Future<Map<String, dynamic>> signup(String fullName, String email, String mobile, String password) async {
    print('Sending to API: Full Name: $fullName, Email: $email, Mobile: $mobile, Password: $password');

    final response = await http.post(
      Uri.parse(baseUrl + 'account/api/mobile-signup/'), // Replace with your actual endpoint
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'full_name': fullName,
        'email': email, // Since email is optional, ensure it handles null correctly
        'mobile': mobile,
        'password': password,
      }),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to signup. Status code: ${response.statusCode}');
    }
  }


  Future<List<dynamic>> fetchProducts(int companyId) async {
    final response = await http.get(
      Uri.parse(baseUrl + 'companies/api/inventory/11/'), // Adjust the URL as needed
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['store_products']; // Assuming 'store_products' is the key
    } else {
      throw Exception('Failed to fetch products. Status code: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchProductDetail(int storeProductId) async {
    final response = await http.get(
      Uri.parse(baseUrl + 'companies/api/store-products/$storeProductId/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Return the product detail
    } else {
      throw Exception('Failed to fetch product details. Status code: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchPOSData(int storeId) async {
    final response = await http.get(
      Uri.parse(baseUrl + 'companies/api/pos/$storeId/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Return the entire response body as a Map
    } else {
      throw Exception('Failed to load POS data');
    }
  }

  Future<dynamic> submitOrderData(int storeId, Map<String, dynamic> orderData) async {
    // Print the order data to the console for debugging
    print('Submitting order data: ${jsonEncode(orderData)}');

    final response = await http.post(
      Uri.parse(baseUrl + 'companies/api/submit-order/$storeId/'), // Updated endpoint with storeId
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      // Optionally, log the error or handle it as required
      print('Error submitting order: ${response.body}');
      throw Exception('Failed to submit order. Status code: ${response.statusCode}');
    }
  }


  Future<List<Customer>> fetchCustomers(int companyId) async {
    final response = await http.get(
      Uri.parse(baseUrl + 'companies/api/companies/11/customers/'), // Adjust URL as needed
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    print('Response Body Customer: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> customersJson = json.decode(response.body)['customers'];
      return customersJson.map((json) => Customer.fromJson(json)).toList();
    } else {
      print('Error fetching customers');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to fetch customers. Status code: ${response.statusCode}');
    }
  }

  Future<List<TaxOption>> fetchTaxes(int companyId) async {
    final response = await http.get(
      Uri.parse(baseUrl + 'companies/api/companies/$companyId/taxes/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      print(decodedResponse); // Print the decoded JSON for debugging

      List<dynamic> taxesJson = decodedResponse['taxes']; // Assuming 'taxes' is the key
      return taxesJson.map((json) => TaxOption.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch taxes. Status code: ${response.statusCode}');
    }
  }


  Future<Customer> fetchCustomerDetails(int companyId, int customerId) async {
    final response = await http.get(
      Uri.parse(baseUrl + 'companies/api/companies/$companyId/customers/$customerId/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    print('Response Body Customer: ${response.body}');

    if (response.statusCode == 200) {
      return Customer.fromJson(json.decode(response.body));
    } else {
      print('Error fetching customer details');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to fetch customer details. Status code: ${response.statusCode}');
    }
  }
  Future<List<Order>> fetchOrdersForCustomer(int customerId) async {
    final response = await http.get(
      Uri.parse(baseUrl + 'companies/api/$customerId/orders'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      // Check if jsonResponse is a map and contains 'orders'
      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('orders')) {
        // Extract the list of orders
        List<dynamic> ordersJson = jsonResponse['orders'];
        return ordersJson.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Unexpected JSON format');
      }
    } else {
      throw Exception('Failed to fetch orders. Status code: ${response.statusCode}');
    }
  }

  Future<List<LedgerEntry>> fetchLedger(int customerId) async {
    final response = await http.get(
      Uri.parse(baseUrl + 'companies/api/$customerId/ledger'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      // Check if jsonResponse is a map and contains 'ledger_entries'
      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('ledger_entries')) {
        // Extract the list of ledger entries
        List<dynamic> ledgerEntriesJson = jsonResponse['ledger_entries'];
        return ledgerEntriesJson.map((json) => LedgerEntry.fromJson(json)).toList();
      } else {
        throw Exception('Unexpected JSON format');
      }
    } else {
      throw Exception('Failed to fetch ledger entries. Status code: ${response.statusCode}');
    }
  }




  Future<void> addCustomer(Customer customer) async {
    final jsonData = jsonEncode(customer.toJson()); // Encode the customer data to JSON
    print('Sending Create Customer API: $jsonData'); // Print the JSON data

    final response = await http.post(
      Uri.parse(baseUrl + 'companies/api/customers/create'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 201) {
      print('Customer added successfully');
    } else {
      print('Failed to add customer. Response: ${response.body}'); // Print response body for debugging
      throw Exception('Failed to add customer. Status code: ${response.statusCode}');
    }
  }

  Future<void> addManualTransaction(ManualTransaction transaction) async {
    final jsonData = jsonEncode(transaction.toJson());
    print('Sending Create Manual Transaction API: $jsonData');

    try {
      final response = await http.post(
        Uri.parse(baseUrl + 'companies/api/add_manual_transaction'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonData,
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode != 201) {
        throw Exception('Failed to add manual transaction. Status code: ${response.statusCode}');
      }

      print('Manual transaction added successfully');
    } catch (e) {
      print('Error during API call: $e');
      throw Exception('Error during API call: $e');
    }
  }


}




