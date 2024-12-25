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
    return 0; // State ban đầu
  }

  String? fullName; // Tên người dùng
  String? location; // Địa chỉ GPS
  DateTime? lastFetchTime; // Thời gian fetch GPS gần nhất
  String? cachedFullName; // Cache tên người dùng
  String? cachedLocation; // Cache vị trí GPS

  static const gpsCacheDuration = Duration(minutes: 5);

  /// Tải tên người dùng (chỉ một lần)
  Future<void> loadUserNameOnce() async {
    if (cachedFullName != null) {
      fullName = cachedFullName;
      print("[HomePageIndex] Tên người dùng đã có trong cache: $fullName");
      return; // Không fetch lại
    }

    try {
      print("[HomePageIndex] Fetching user name...");
      final userInfo = await fetchUserInfo();
      fullName = userInfo.fullName;
      cachedFullName = fullName; // Cache tên người dùng
      print("[HomePageIndex] User name loaded: $fullName");
    } catch (e) {
      print("[HomePageIndex] Lỗi khi tải tên người dùng: $e");
      fullName = "Không thể tải tên người dùng";
    }
  }

  Future<void> loadGpsLocation({bool forceRefresh = false}) async {
    final now = DateTime.now();

    if (!forceRefresh &&
        cachedLocation != null &&
        lastFetchTime != null &&
        now.difference(lastFetchTime!) < gpsCacheDuration) {
      print("[HomePageIndex] Sử dụng cache GPS: $cachedLocation");
      location = cachedLocation;
      state = state + 1; // Cập nhật UI
      return;
    }

    // Load vị trí GPS mới
    try {
      print("[HomePageIndex] Fetching GPS location...");
      final userId = await SecureStorageManager.getUserId();
      if (userId == null) throw Exception("Không tìm thấy ID người dùng.");

      final deviceLocation = await LocationService.getCurrentLocation();
      if (deviceLocation == null) throw Exception("Không thể lấy GPS.");

      final latitude = deviceLocation.latitude;
      final longitude = deviceLocation.longitude;

      // Gửi tọa độ lên server
      await GpsApi.saveGpsLocation(
        latitude: latitude.toString(),
        longitude: longitude.toString(),
        timestamp: DateTime.now().toIso8601String(),
        userId: userId,
      );

      // Fetch từ server
      final gpsDataFromBe = await fetchGpsDataFromBe(userId);
      final latitudeFromBe = gpsDataFromBe['latitude'];
      final longitudeFromBe = gpsDataFromBe['longitude'];

      // Chuyển tọa độ thành địa chỉ
      location = await getAddressFromLatLng(latitudeFromBe, longitudeFromBe);

      // Cache kết quả
      cachedLocation = location;
      lastFetchTime = DateTime.now();

      print("[HomePageIndex] GPS location updated: $location");
    } catch (e) {
      print("[HomePageIndex] Lỗi khi tải vị trí GPS: $e");
      location = "Không thể tải vị trí";
    }

    state = state + 1; // Trigger rebuild
  }

  /// Chuyển tọa độ thành địa chỉ
  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      print("[HomePageIndex] Chuyển tọa độ thành địa chỉ...");
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.street}, ${place.locality}, ${place.country}";
      }
      return "Không tìm thấy địa chỉ";
    } catch (e) {
      print("[HomePageIndex] Lỗi khi chuyển tọa độ: $e");
      return "Lỗi khi lấy địa chỉ";
    }
  }

  /// Load toàn bộ dữ liệu lần đầu
  Future<void> loadInitialData() async {
    await Future.wait([
      loadUserNameOnce(),
      loadGpsLocation(),
    ]);
  }

  /// Thay đổi index trang
  void changeIndex(int value) {
    state = value;
  }
}
