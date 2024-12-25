import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/cart_item_model.dart';
import '../utils/secure_storage.dart';
import 'api_config.dart';

class CartApi {
  // Fetch all temporary cart items for a user
  static Future<List<CartItem>> fetchTemporaryCartItems(String userId) async {
    final token = await SecureStorageManager.getToken();
    if (token == null) {
      throw Exception("User is not authenticated");
    }

    final url = Uri.parse('$baseUrl/cart/temporary/$userId'); // Endpoint phù hợp với BE
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );


    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final List<dynamic> items = responseBody['data']['items'];

      // Ánh xạ từng item thành CartItem
      return items.map((item) => CartItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch temporary cart items: ${response.body}');
    }
  }
// Remove a single item from the cart
  static Future<Map<String, dynamic>> removeCartItem(String userId, String cartItemId) async {
    final token = await SecureStorageManager.getToken();
    if (token == null) {
      throw Exception("User is not authenticated");
    }

    final url = Uri.parse('$baseUrl/cart/temporary/$userId/item/$cartItemId');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to remove item from cart: ${response.body}');
    }
  }

  // Add an item to the temporary cart
  static Future<String> addTemporaryCartItem(String userId, String chassisNumber, int quantity) async {
    final token = await SecureStorageManager.getToken();
    if (token == null) {
      throw Exception("User is not authenticated");
    }

    // Build URL với query string
    final url = Uri.parse(
        '$baseUrl/cart/temporary/add?userId=$userId&chassisNumber=$chassisNumber&quantity=$quantity');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return "Item added to temporary cart successfully";
    } else {
      throw Exception('Failed to add item to temporary cart: ${response.body}');
    }
  }

  // Update a temporary cart item quantity
  static Future<String> updateTemporaryCartItemQuantity(String userId, String cartItemId, int newQuantity) async {
    final token = await SecureStorageManager.getToken();
    if (token == null) {
      throw Exception("User is not authenticated");
    }

    final url = Uri.parse('$baseUrl/cart/temporary/update'); // Endpoint phù hợp với BE
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "userId": userId,
        "cartItemId": cartItemId,
        "newQuantity": newQuantity,
      }),
    );

    print('Request Body: ${jsonEncode({
      "userId": userId,
      "cartItemId": cartItemId,
      "newQuantity": newQuantity,
    })}');

    if (response.statusCode == 200) {
      return "Temporary cart item quantity updated successfully";
    } else {
      throw Exception('Failed to update temporary cart item: ${response.body}');
    }
  }

  // Clear the temporary cart for a user
  static Future<String> clearTemporaryCart(String userId) async {
    final token = await SecureStorageManager.getToken();
    if (token == null) {
      throw Exception("User is not authenticated");
    }

    final url = Uri.parse('$baseUrl/cart/temporary/cleanup/$userId'); // Endpoint phù hợp với BE
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return "Temporary cart cleaned up successfully";
    } else {
      throw Exception('Failed to clear temporary cart: ${response.body}');
    }
  }
}
