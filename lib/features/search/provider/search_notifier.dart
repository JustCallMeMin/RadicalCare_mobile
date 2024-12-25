import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:radicalcare/common/model/vehicle_model.dart';
import '../../../common/api/search_api.dart';
import '../../../common/utils/secure_storage.dart';
import '../../../common/utils/token_utils.dart';

part 'search_notifier.g.dart';

// Notifier cho việc tìm kiếm sản phẩm
@riverpod
class SearchNotifier extends _$SearchNotifier {
  @override
  Future<AsyncValue<List<Vehicle>>> build(String keyword) async {
    print('SearchNotifier started with keyword: $keyword'); // Log bắt đầu tìm kiếm

    if (keyword.isEmpty) {
      print('Keyword is empty, returning empty list.'); // Log khi từ khóa rỗng
      return const AsyncValue.data([]);
    }

    try {
      // Lấy token từ SecureStorageManager
      print('Fetching token from SecureStorageManager...');
      final token = await SecureStorageManager.getToken();
      if (token == null) {
        print('Token is not available.'); // Log khi token không khả dụng
        throw Exception("Token is not available");
      }
      print('Token fetched successfully.');

      // Lấy userId từ token
      print('Extracting userId from token...');
      final userId = TokenUtils.getUserIdFromToken(token);
      if (userId == null) {
        print('Failed to extract userId from token.'); // Log khi không lấy được userId
        throw Exception("Failed to extract userId from token");
      }
      print('UserId extracted: $userId');

      // Gọi API tìm kiếm phương tiện từ backend
      print('Calling fetchVehiclesByKeyword API with keyword: $keyword and userId: $userId...');
      List<Vehicle> searchResults = await fetchVehiclesByKeyword(keyword, userId);
      print('API call successful, fetched ${searchResults.length} vehicles.'); // Log khi gọi API thành công
      return AsyncValue<List<Vehicle>>.data(searchResults);
    } catch (e, stackTrace) {
      print('Error occurred during search: $e'); // Log lỗi nếu có ngoại lệ
      print('StackTrace: $stackTrace');
      return AsyncValue<List<Vehicle>>.error(e, stackTrace);
    }
  }
}
