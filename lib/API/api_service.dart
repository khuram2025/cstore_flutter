import 'dart:convert';
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

  Future<List<dynamic>> fetchPOSData(int storeId) async {
    final response = await http.get(
      Uri.parse(baseUrl +'companies/api/pos/$storeId/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data is Map<String, dynamic> && data.containsKey('products')) {
        return data['products'] as List<dynamic>;
      } else {
        return []; // Return an empty list if 'products' key is not found
      }
    } else {
      return []; // Return an empty list if response status code is not 200
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

}
