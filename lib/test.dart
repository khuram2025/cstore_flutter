class ApiService {
  final String baseUrl = 'http://app.channab.com/';

  // ... other methods ...

  Future<List<dynamic>> fetchPOSData(int storeId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/pos/$storeId/'),
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
}
