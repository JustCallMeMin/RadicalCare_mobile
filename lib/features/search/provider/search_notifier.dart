import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:radicalcare/common/model/vehicle.dart';
import '../../../common/api/search_api.dart';
import '../../../common/utils/secure_storage.dart';
import '../../../common/utils/token_utils.dart';

part 'search_notifier.g.dart';

// Notifier cho việc tìm kiếm sản phẩm
@riverpod
class SearchNotifier extends _$SearchNotifier {
  @override
  Future<AsyncValue<List<Vehicle>>> build(String keyword) async {
    if (keyword.isEmpty) {
      return const AsyncValue.data([]); // Trả về danh sách rỗng nếu từ khóa rỗng
    }
    try {
      // Lấy token từ SecureStorageManager
      final token = await SecureStorageManager.getToken();
      if (token == null) {
        throw Exception("Token is not available");
      }

      // Lấy userId từ token
      final userId = TokenUtils.getUserIdFromToken(token);
      if (userId == null) {
        throw Exception("Failed to extract userId from token");
      }

      // Gọi API tìm kiếm phương tiện từ backend
      List<Vehicle> searchResults = await fetchVehiclesByKeyword(keyword, userId);
      return AsyncValue<List<Vehicle>>.data(searchResults); // Bao bọc kết quả trong AsyncValue
    } catch (e, stackTrace) {
      return AsyncValue<List<Vehicle>>.error(e, stackTrace); // Bao bọc lỗi trong AsyncValue
    }
  }
}
