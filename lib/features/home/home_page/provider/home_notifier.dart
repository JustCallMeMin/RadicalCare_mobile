import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:radicalcare/common/api/home_api.dart';
import 'package:radicalcare/common/api/gps_api.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../common/utils/location.dart';
import '../../../../common/utils/secure_storage.dart';

part 'home_notifier.g.dart';

@riverpod
class HomePageIndex extends _$HomePageIndex {
  @override
  int build() {
    return 0;
  }

  String? fullName;
  String? location;

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      print("[HomePageIndex] Converting coordinates to address: lat=$latitude, lng=$longitude");
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.street}, ${place.locality}, ${place.country}";
      }
      return "Không tìm thấy địa chỉ";
    } catch (e) {
      print("[HomePageIndex] Error converting coordinates: $e");
      return "Lỗi khi lấy địa chỉ";
    }
  }

  Future<void> fetchUserFullNameAndGps() async {
    try {
      print("[HomePageIndex] Fetching user info and GPS data");

      // Lấy User ID và Customer ID
      final userId = await SecureStorageManager.getUserId();
      final customerId = await SecureStorageManager.getCustomerId();

      if (userId == null) throw Exception("User ID not found.");

      // Lấy tọa độ GPS từ thiết bị
      final deviceLocation = await LocationService.getCurrentLocation();
      if (deviceLocation == null) {
        throw Exception("Unable to fetch device GPS location.");
      }
      final latitude = deviceLocation.latitude;
      final longitude = deviceLocation.longitude;

      print("[HomePageIndex] Device GPS: lat=$latitude, lng=$longitude");

      // Gửi tọa độ lên BE
      await GpsApi.saveGpsLocation(
        latitude: latitude.toString(),
        longitude: longitude.toString(),
        timestamp: DateTime.now().toIso8601String(),
        userId: userId,
      );

      print("[HomePageIndex] Posted GPS data to server");

      // Fetch tọa độ từ BE
      final gpsDataFromBe = await fetchGpsDataFromBe(userId);
      if (gpsDataFromBe == null) {
        throw Exception("Failed to fetch GPS data from server.");
      }

      final latitudeFromBe = gpsDataFromBe['latitude'];
      final longitudeFromBe = gpsDataFromBe['longitude'];

      print("[HomePageIndex] GPS from server: lat=$latitudeFromBe, lng=$longitudeFromBe");

      // Chuyển tọa độ thành địa chỉ
      final address = await getAddressFromLatLng(latitudeFromBe, longitudeFromBe);
      location = address;

      print("[HomePageIndex] Resolved location from BE: $location");

      // Fetch thông tin người dùng
      final userInfo = await fetchUserInfo();
      fullName = userInfo.fullName;

      print("[HomePageIndex] User full name fetched: $fullName");

      // Cập nhật lại state để giao diện render lại
      state = state + 1; // Chỉ cần thay đổi để trigger rebuild
    } catch (e) {
      print("[HomePageIndex] Error fetching user info or GPS: $e");
    }
  }

  void changeIndex(int value) {
    state = value;
  }
}
