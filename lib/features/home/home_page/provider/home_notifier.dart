import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:radicalcare/common/api/home_api.dart'; // Import API
import 'package:radicalcare/common/api/gps_api.dart'; // Thêm API GPS nếu cần
import 'package:geocoding/geocoding.dart';

import '../../../../common/utils/location.dart';
import '../../../../common/utils/secure_storage.dart';
part 'home_notifier.g.dart';

@riverpod
class HomePageIndex extends _$HomePageIndex {
  @override
  int build() {
    return 0; // Default index
  }

  // State lưu thông tin người dùng và GPS
  String? fullName;
  String? location;
  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.street}, ${place.locality}, ${place.country}";
      }
      return "Không tìm thấy địa chỉ";
    } catch (e) {
      print("Lỗi khi chuyển đổi tọa độ thành địa chỉ: $e");
      return "Lỗi khi lấy địa chỉ";
    }
  }

  // Lấy tên người dùng và vị trí GPS
  Future<void> fetchUserFullNameAndGps() async {
    try {
      final userId = await SecureStorageManager.getUserId();
      final customerId = await SecureStorageManager.getCustomerId();

      if (userId == null) throw Exception("User ID not found.");

      final gpsData = await GpsApi.fetchGpsLocation();
      final latitude = gpsData['latitude'];
      final longitude = gpsData['longitude'];

      final address = await getAddressFromLatLng(latitude, longitude);
      location = address;
      state = state;
    } catch (e) {
      print("Error fetching user info or GPS location: $e");
    }
  }


  void changeIndex(int value) {
    state = value; // Update state
  }

}
