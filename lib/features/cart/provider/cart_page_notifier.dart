import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../common/model/cart_item_model.dart';
import '../../../../common/api/cart_api.dart';
import '../../../../common/utils/secure_storage.dart';

part 'cart_page_notifier.g.dart';

@riverpod
class CartPageNotifier extends _$CartPageNotifier {
  List<CartItem> _cartItems = [];
  double _totalCost = 0.0;

  @override
  Future<List<CartItem>> build() async {
    return await fetchTemporaryCartItems();
  }

  Future<List<CartItem>> fetchTemporaryCartItems() async {
    try {
      final userId = await SecureStorageManager.getUserId();
      if (userId == null) {
        throw Exception('User ID is null');
      }

      // Gọi API lấy danh sách giỏ hàng tạm
      final response = await CartApi.fetchTemporaryCartItems(userId);

      if (response.isNotEmpty) {
        _cartItems = response; // Gán danh sách các CartItem
        _calculateTotalCost(); // Tính tổng lại mỗi khi fetch
        state = AsyncValue.data(_cartItems); // Cập nhật trạng thái thành công
      } else {
        throw Exception('No items found in the cart');
      }

      return _cartItems;
    } catch (e, stackTrace) {
      log('Failed to fetch temporary cart items', error: e, stackTrace: stackTrace);
      state = AsyncValue.error(e, stackTrace);
      return [];
    }
  }

  Future<void> addToTemporaryCart(String chassisNumber, int quantity) async {
    try {
      final userId = await SecureStorageManager.getUserId();
      if (userId == null) {
        throw Exception('User ID is null');
      }

      // Call API to add item
      final response = await CartApi.addTemporaryCartItem(userId, chassisNumber, quantity);

      if (response == "Item added to temporary cart successfully") {
        await fetchTemporaryCartItems(); // Refetch lại để đồng bộ dữ liệu
      } else {
        log('Failed to add item to temporary cart: $response');
      }
    } catch (e, stackTrace) {
      log('Error adding to temporary cart', error: e, stackTrace: stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateTemporaryCartItem(String cartItemId, int newQuantity) async {
    try {
      final userId = await SecureStorageManager.getUserId();
      if (userId == null) {
        throw Exception('User ID is null');
      }

      // Call API to update item
      final response = await CartApi.updateTemporaryCartItemQuantity(userId, cartItemId, newQuantity);

      if (response == "Temporary cart item quantity updated successfully") {
        await fetchTemporaryCartItems(); // Refetch lại để đồng bộ dữ liệu
      } else {
        log('Failed to update item in temporary cart: $response');
      }
    } catch (e, stackTrace) {
      log('Error updating temporary cart item', error: e, stackTrace: stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> clearTemporaryCart() async {
    try {
      final userId = await SecureStorageManager.getUserId();
      if (userId == null) {
        throw Exception('User ID is null');
      }

      // Call API to clear the cart
      final response = await CartApi.clearTemporaryCart(userId);

      if (response == "Temporary cart cleaned up successfully") {
        _cartItems.clear();
        _calculateTotalCost(); // Reset tổng chi phí
        state = AsyncValue.data(_cartItems);
      } else {
        log('Failed to clear temporary cart: $response');
      }
    } catch (e, stackTrace) {
      log('Error clearing temporary cart', error: e, stackTrace: stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> removeFromCart(String cartItemId) async {
    try {
      final userId = await SecureStorageManager.getUserId();
      if (userId == null) {
        throw Exception('User ID is null');
      }

      // Gọi API xóa sản phẩm
      final response = await CartApi.removeCartItem(userId, cartItemId);

      if (response['status'] == 200) {
        await fetchTemporaryCartItems(); // Refetch lại để đồng bộ dữ liệu
      } else {
        log('Failed to remove item from cart: ${response['message']}');
      }
    } catch (e, stackTrace) {
      log('Error removing from cart', error: e, stackTrace: stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void _calculateTotalCost() {
    // Tính tổng dựa trên subtotal và log từng bước
    _totalCost = _cartItems.fold(0, (sum, item) {
      print('Calculating subtotal for item ${item.vehicle.vehicleName}: ${item.subtotal}');
      return sum + (item.subtotal ?? 0);
    });
    print('Total cost calculated: $_totalCost');
  }

  double get totalCost => _totalCost;

  List<CartItem> get cartItems => _cartItems;
}
